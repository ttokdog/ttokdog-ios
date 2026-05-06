import Testing
import ComposableArchitecture
@testable import FeatureOnboarding

@MainActor
struct VerificationCodeTests {

    // MARK: - Initial State

    @Test
    func initialState_기본값() async {
        let state = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
        #expect(state.code == "")
        #expect(state.remainingSeconds == 180)
        #expect(state.attemptCount == 0)
        #expect(state.resendCount == 0)
        #expect(state.inputState == .idle)
        #expect(state.bottomMessage == nil)
        #expect(state.alert == nil)
        #expect(state.formattedTime == "03:00")
        #expect(state.isCodeFilled == false)
        #expect(state.isVerifyEnabled == false)
    }

    // MARK: - Code Binding

    @Test
    func code_바인딩_숫자만_6자_cap() async {
        let store = TestStore(
            initialState: VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
        ) {
            VerificationCodeFeature()
        }

        // 알파벳 + 숫자 혼합, 6자 초과 → 숫자만 6자로 잘려야 함
        await store.send(\.binding.code, "abc1234567") {
            $0.code = "123456"
        }
    }

    @Test
    func code_재입력_시_에러상태_해제() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.code = "123456"
                s.inputState = .error
                s.bottomMessage = .codeMismatch(remaining: 4)
                return s
            }()
        ) {
            VerificationCodeFeature()
        }

        await store.send(\.binding.code, "1234") {
            $0.code = "1234"
            $0.inputState = .idle
            $0.bottomMessage = nil
        }
    }

    // MARK: - Timer

    @Test
    func 타이머_초당_remainingSeconds_감소() async {
        let clock = TestClock()
        let store = TestStore(
            initialState: VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
        ) {
            VerificationCodeFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }

        await store.send(.onAppear) { $0.isTimerRunning = true }

        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTicked) { $0.remainingSeconds = 179 }

        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTicked) { $0.remainingSeconds = 178 }

        // 정리 — 타이머 cancel + delegate
        await store.send(.backButtonTapped)
        await store.receive(\.delegate.popToFindAccount)
    }

    @Test
    func 타이머_만료_시_timeExpired_alert() async {
        let clock = TestClock()
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.remainingSeconds = 1
                return s
            }()
        ) {
            VerificationCodeFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }

        await store.send(.onAppear) { $0.isTimerRunning = true }

        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTicked) {
            $0.remainingSeconds = 0
            $0.isTimerRunning = false
            $0.alert = .timeExpired
        }
    }

    // MARK: - Derived 활성화 조건

    @Test
    func 재전송버튼_2분이전엔_비활성화() {
        var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
        s.remainingSeconds = 121
        #expect(s.isResendEnabled == false)
    }

    @Test
    func 재전송버튼_2분이하면_활성화() {
        var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
        s.remainingSeconds = 120
        #expect(s.isResendEnabled == true)
    }

    @Test
    func 재전송_5회_도달_시_재전송버튼_비활성화() {
        var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
        s.remainingSeconds = 60
        s.resendCount = 5
        #expect(s.isResendEnabled == false)
    }

    @Test
    func 인증버튼_6자_미만_비활성화() {
        var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
        s.code = "12345"
        #expect(s.isVerifyEnabled == false)
    }

    @Test
    func 인증버튼_에러상태_시_비활성화() {
        var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
        s.code = "123456"
        s.inputState = .error
        #expect(s.isVerifyEnabled == false)
    }

    // MARK: - Verify Mismatch

    @Test
    func verify_mismatch_응답_시_n회남음과_에러상태() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.code = "000000"
                return s
            }()
        ) {
            VerificationCodeFeature()
        } withDependencies: {
            $0.verificationCodeClient.verify = { _, _ in .mismatch }
        }

        await store.send(.verifyTapped) {
            $0.isVerifying = true
            $0.attemptCount = 1
        }
        await store.receive(\.verifyResponse) {
            $0.isVerifying = false
            $0.inputState = .error
            $0.bottomMessage = .codeMismatch(remaining: 4)
        }
    }

    @Test
    func 입력_5회_실패_시_attemptExceeded_alert() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.code = "000000"
                s.attemptCount = 4
                return s
            }()
        ) {
            VerificationCodeFeature()
        } withDependencies: {
            $0.verificationCodeClient.verify = { _, _ in .mismatch }
        }

        await store.send(.verifyTapped) {
            $0.isVerifying = true
            $0.attemptCount = 5
        }
        await store.receive(\.verifyResponse) {
            $0.isVerifying = false
            $0.inputState = .error
            $0.bottomMessage = .codeMismatch(remaining: 0)
            $0.alert = .attemptExceeded
        }
    }

    @Test
    func verify_진행중_재탭_시_attemptCount_중복증가_방지() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.code = "000000"
                s.isVerifying = true   // 이미 진행 중
                return s
            }()
        ) {
            VerificationCodeFeature()
        }

        // isVerifying이 true이므로 isVerifyEnabled는 false → guard에서 차단
        await store.send(.verifyTapped)
        // 상태 변화 없음 (attemptCount 그대로 0)
    }

    // MARK: - Verify Success / Server-side limit

    @Test
    func verify_successEmailSignup_응답_시_alert_표시와_타이머_중단() async {
        let clock = TestClock()
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.code = "123456"
                return s
            }()
        ) {
            VerificationCodeFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.verificationCodeClient.verify = { _, _ in .successEmailSignup(maskedId: "tto***") }
        }

        await store.send(.verifyTapped) {
            $0.isVerifying = true
            $0.attemptCount = 1
        }
        await store.receive(\.verifyResponse) {
            $0.isVerifying = false
            $0.alert = .successEmailSignup(maskedId: "tto***")
            $0.isTimerRunning = false
        }
    }

    @Test
    func verify_successSocialSignup_응답_시_alert_표시() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.code = "123456"
                return s
            }()
        ) {
            VerificationCodeFeature()
        } withDependencies: {
            $0.verificationCodeClient.verify = { _, _ in .successSocialSignup(provider: .kakao) }
        }

        await store.send(.verifyTapped) {
            $0.isVerifying = true
            $0.attemptCount = 1
        }
        await store.receive(\.verifyResponse) {
            $0.isVerifying = false
            $0.alert = .successSocialSignup(provider: .kakao)
            $0.isTimerRunning = false
        }
    }

    @Test
    func verify_서버_attemptExceeded_응답_시_alert() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.code = "123456"
                return s
            }()
        ) {
            VerificationCodeFeature()
        } withDependencies: {
            $0.verificationCodeClient.verify = { _, _ in .attemptExceeded }
        }

        await store.send(.verifyTapped) {
            $0.isVerifying = true
            $0.attemptCount = 1
        }
        await store.receive(\.verifyResponse) {
            $0.isVerifying = false
            $0.alert = .attemptExceeded
        }
    }

    @Test
    func verify_서버_dailyExceeded_응답_시_alert() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.code = "123456"
                return s
            }()
        ) {
            VerificationCodeFeature()
        } withDependencies: {
            $0.verificationCodeClient.verify = { _, _ in .dailyExceeded }
        }

        await store.send(.verifyTapped) {
            $0.isVerifying = true
            $0.attemptCount = 1
        }
        await store.receive(\.verifyResponse) {
            $0.isVerifying = false
            $0.alert = .dailyExceeded
        }
    }

    // MARK: - Resend

    @Test
    func resend_sent_응답_시_타이머_리셋_및_코드_초기화() async {
        let clock = TestClock()
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.remainingSeconds = 60
                s.code = "1234"
                s.inputState = .error
                s.bottomMessage = .codeMismatch(remaining: 3)
                return s
            }()
        ) {
            VerificationCodeFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.verificationCodeClient.resend = { _ in .sent }
        }

        await store.send(.resendTapped) {
            $0.isResending = true
            $0.resendCount = 1
        }
        await store.receive(\.resendResponse) {
            $0.isResending = false
            $0.code = ""
            $0.inputState = .idle
            $0.remainingSeconds = 180
            $0.bottomMessage = .resent
            $0.isTimerRunning = true
        }

        await store.send(.backButtonTapped)
        await store.receive(\.delegate.popToFindAccount)
    }

    @Test
    func resend_resendExceeded_응답_시_alert() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.remainingSeconds = 60
                return s
            }()
        ) {
            VerificationCodeFeature()
        } withDependencies: {
            $0.verificationCodeClient.resend = { _ in .resendExceeded }
        }

        await store.send(.resendTapped) {
            $0.isResending = true
            $0.resendCount = 1
        }
        await store.receive(\.resendResponse) {
            $0.isResending = false
            $0.alert = .resendExceeded
        }
    }

    @Test
    func resend_dailyExceeded_응답_시_alert() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.remainingSeconds = 60
                return s
            }()
        ) {
            VerificationCodeFeature()
        } withDependencies: {
            $0.verificationCodeClient.resend = { _ in .dailyExceeded }
        }

        await store.send(.resendTapped) {
            $0.isResending = true
            $0.resendCount = 1
        }
        await store.receive(\.resendResponse) {
            $0.isResending = false
            $0.alert = .dailyExceeded
        }
    }

    @Test
    func resend_진행중_재탭_시_resendCount_중복증가_방지() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.remainingSeconds = 60
                s.isResending = true
                return s
            }()
        ) {
            VerificationCodeFeature()
        }

        // isResending이 true이므로 isResendEnabled는 false → guard에서 차단
        await store.send(.resendTapped)
    }

    // MARK: - Alert Confirmed

    @Test
    func alertConfirmed_timeExpired_시_모달만_닫음() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.alert = .timeExpired
                return s
            }()
        ) {
            VerificationCodeFeature()
        }

        await store.send(.alertConfirmed) { $0.alert = nil }
    }

    @Test
    func alertConfirmed_attemptExceeded_시_모달만_닫음() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.alert = .attemptExceeded
                return s
            }()
        ) {
            VerificationCodeFeature()
        }

        await store.send(.alertConfirmed) { $0.alert = nil }
    }

    @Test
    func alertConfirmed_resendExceeded_시_pop() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.alert = .resendExceeded
                return s
            }()
        ) {
            VerificationCodeFeature()
        }

        await store.send(.alertConfirmed) { $0.alert = nil }
        await store.receive(\.delegate.popToFindAccount)
    }

    @Test
    func alertConfirmed_dailyExceeded_시_pop() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.alert = .dailyExceeded
                return s
            }()
        ) {
            VerificationCodeFeature()
        }

        await store.send(.alertConfirmed) { $0.alert = nil }
        await store.receive(\.delegate.popToFindAccount)
    }

    @Test
    func alertConfirmed_successEmail_시_navigateToLogin_위임() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.alert = .successEmailSignup(maskedId: "tto***")
                return s
            }()
        ) {
            VerificationCodeFeature()
        }

        await store.send(.alertConfirmed) { $0.alert = nil }
        await store.receive(\.delegate.navigateToLogin)
    }

    @Test
    func alertConfirmed_successSocial_시_navigateToLogin_위임() async {
        let store = TestStore(
            initialState: {
                var s = VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com")
                s.alert = .successSocialSignup(provider: .kakao)
                return s
            }()
        ) {
            VerificationCodeFeature()
        }

        await store.send(.alertConfirmed) { $0.alert = nil }
        await store.receive(\.delegate.navigateToLogin)
    }
}
