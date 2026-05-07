import Foundation
import ComposableArchitecture

// MARK: - VerificationCodeFeature

@Reducer
public struct VerificationCodeFeature {

    // MARK: - 정책 상수

    /// 화면 정책 단일 출처 (Single Source of Truth).
    private enum Policy {
        /// 인증 입력 제한 시간 (초)
        static let totalSeconds: Int = 180
        /// 재전송 버튼 활성화 임계 — 남은 시간 ≤ 120초일 때 활성화
        static let resendUnlockThreshold: Int = 120
        /// 인증 입력 시도 한도 — 초과 시 attemptExceeded alert
        static let maxAttempts: Int = 5
        /// 인증번호 재전송 한도 — 초과 시 resendExceeded alert
        static let maxResends: Int = 5
    }

    // MARK: - 부가 타입

    /// 소셜 로그인 제공자 (성공 alert 텍스트 분기에 사용)
    public enum SocialProvider: String, Equatable, Sendable {
        case kakao, google, apple

        /// alert 본문에 노출되는 한글 표기
        public var displayName: String {
            switch self {
            case .kakao:  "카카오"
            case .google: "구글"
            case .apple:  "애플"
            }
        }
    }

    /// 입력 필드 시각 상태
    public enum InputState: Equatable {
        /// 미입력 / 입력 중 (정상 톤)
        case idle
        /// 코드 오류 (빨간 박스 + 하단 메시지)
        case error
    }

    /// 입력 필드 하단에 표시되는 인라인 메시지
    public enum BottomMessage: Equatable {
        /// "인증번호를 정확히 입력해주세요. (n회 남음)"
        case codeMismatch(remaining: Int)
        /// "인증번호가 재전송되었어요. 메일함을 확인해주세요"
        case resent
    }

    /// alert 종류 — single source of truth로 reducer가 분기
    public enum AlertKind: Equatable {
        /// 3분 타이머 만료 → "확인" (모달만 닫기)
        case timeExpired
        /// 입력 5회 초과 → "확인" (모달만 닫기)
        case attemptExceeded
        /// 재전송 5회 초과 → "돌아가기" (pop)
        case resendExceeded
        /// 일일 인증 요청 10회 초과 → "돌아가기" (pop)
        case dailyExceeded
        /// 이메일 가입 계정 — 마스킹된 아이디 발송 안내
        case successEmailSignup(maskedId: String)
        /// 소셜 가입 계정 — 해당 소셜 로그인 안내
        case successSocialSignup(provider: SocialProvider)
    }

    // MARK: - State

    @ObservableState
    public struct State: Equatable {
        // MARK: - 입력
        /// 마스킹된 이메일 (예: "tto****@gmail.com") — 부모 화면에서 주입
        public var maskedEmail: String
        /// 사용자가 입력한 인증번호 (0~6자리, 숫자만)
        public var code: String = ""

        // MARK: - 타이머
        /// 남은 시간 (초). 초기 180.
        public var remainingSeconds: Int = Policy.totalSeconds
        /// 타이머 동작 여부
        public var isTimerRunning: Bool = false

        // MARK: - 카운트
        /// 인증 확인 시도 횟수 (낙관적 카운트)
        public var attemptCount: Int = 0
        /// 인증번호 재전송 횟수
        public var resendCount: Int = 0

        // MARK: - 진행 상태 (연타 방지)
        /// 인증 확인 요청 진행 중 — 응답 대기 동안 추가 탭 차단
        public var isVerifying: Bool = false
        /// 재전송 요청 진행 중 — 응답 대기 동안 추가 탭 차단
        public var isResending: Bool = false

        // MARK: - UI
        /// 입력 박스 시각 상태
        public var inputState: InputState = .idle
        /// 입력 박스 하단 인라인 메시지 (없으면 nil)
        public var bottomMessage: BottomMessage? = nil
        /// 표시 중인 alert (없으면 nil)
        public var alert: AlertKind? = nil

        // MARK: - 파생값

        /// 6자리 모두 채워졌는지
        public var isCodeFilled: Bool { code.count == 6 }

        /// 재전송 버튼 활성화 — 남은시간 2분 이하 + 재전송 횟수 5회 미만 + 진행 중 아님
        public var isResendEnabled: Bool {
            remainingSeconds <= Policy.resendUnlockThreshold
                && resendCount < Policy.maxResends
                && !isResending
        }

        /// 인증 확인 버튼 활성화 — 6자리 완성 + 에러 상태가 아님 + 진행 중 아님
        public var isVerifyEnabled: Bool {
            isCodeFilled && inputState != .error && !isVerifying
        }

        /// "MM:SS" 포맷 (예: "03:00", "00:42")
        public var formattedTime: String {
            String(format: "%02d:%02d", remainingSeconds / 60, remainingSeconds % 60)
        }

        public init(maskedEmail: String) {
            self.maskedEmail = maskedEmail
        }
    }

    // MARK: - Action

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 화면 onAppear — 타이머 시작
        case onAppear
        /// 1초 경과 (타이머 effect가 디스패치)
        case timerTicked
        /// "인증 확인" 버튼 탭
        case verifyTapped
        /// 인증 검증 응답
        case verifyResponse(VerifyResponse)
        /// "재전송" 버튼 탭
        case resendTapped
        /// 재전송 응답
        case resendResponse(ResendResponse)
        /// alert primary 버튼 탭
        case alertConfirmed
        /// 네비게이션 뒤로가기 버튼 탭
        case backButtonTapped
        /// 부모(FindAccount)에 위임할 이벤트
        case delegate(Delegate)

        @CasePathable
        public enum Delegate: Equatable {
            /// FindAccount 화면으로 pop 요청 (한도 초과 등)
            case popToFindAccount
            /// 로그인 화면으로 이동 (인증 성공 후 "로그인 하러가기" / "OO 로그인" 탭)
            case navigateToLogin
        }
    }

    // MARK: - Cancellation IDs

    /// 사이드 이펙트 취소 식별자
    private enum CancelID: Hashable {
        case timer, verify, resend
    }

    // MARK: - Dependencies

    @Dependency(\.continuousClock) var clock
    @Dependency(\.verificationCodeClient) var client

    public init() {}

    // MARK: - Reducer

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            // MARK: Binding

            case .binding(\.code):
                // 숫자만 추리고 6자로 자르기
                let digitsOnly = state.code.filter(\.isNumber)
                let trimmed = String(digitsOnly.prefix(6))
                if state.code != trimmed {
                    state.code = trimmed
                }
                // 입력이 다시 시작되면 에러 톤/안내 메시지 해제
                if state.inputState == .error {
                    state.inputState = .idle
                }
                if case .codeMismatch = state.bottomMessage {
                    state.bottomMessage = nil
                }
                return .none

            case .binding:
                return .none

            // MARK: Timer

            case .onAppear:
                // 이미 동작 중이면 재시작하지 않음 (네비 재진입 방어)
                guard !state.isTimerRunning else { return .none }
                state.isTimerRunning = true
                return .run { [clock] send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)

            case .timerTicked:
                state.remainingSeconds = max(0, state.remainingSeconds - 1)
                if state.remainingSeconds == 0 {
                    state.isTimerRunning = false
                    state.alert = .timeExpired
                    return .cancel(id: CancelID.timer)
                }
                return .none

            // MARK: Verify

            case .verifyTapped:
                // 6자리 채워졌고 에러/진행 상태 아닐 때만 호출 (UI 가드와 이중 방어)
                guard state.isVerifyEnabled else { return .none }
                state.isVerifying = true
                state.attemptCount += 1   // 낙관적 카운트 — UI의 (n회 남음) 즉시 갱신
                let email = state.maskedEmail   // TODO: [백엔드 연동] 원본 이메일로 교체 (현재는 마스킹값 전달)
                let code = state.code
                return .run { [client] send in
                    await send(.verifyResponse(try await client.verify(email, code)))
                }
                .cancellable(id: CancelID.verify, cancelInFlight: true)

            case .verifyResponse(.mismatch):
                state.isVerifying = false
                state.inputState = .error
                let remaining = max(0, Policy.maxAttempts - state.attemptCount)
                state.bottomMessage = .codeMismatch(remaining: remaining)
                if state.attemptCount >= Policy.maxAttempts {
                    state.alert = .attemptExceeded
                    return .cancel(id: CancelID.timer)
                }
                return .none

            case .verifyResponse(.successEmailSignup(let maskedId)):
                state.isVerifying = false
                state.isTimerRunning = false
                state.alert = .successEmailSignup(maskedId: maskedId)
                return .cancel(id: CancelID.timer)

            case .verifyResponse(.successSocialSignup(let provider)):
                state.isVerifying = false
                state.isTimerRunning = false
                state.alert = .successSocialSignup(provider: provider)
                return .cancel(id: CancelID.timer)

            case .verifyResponse(.attemptExceeded):
                state.isVerifying = false
                state.alert = .attemptExceeded
                return .cancel(id: CancelID.timer)

            case .verifyResponse(.dailyExceeded):
                state.isVerifying = false
                state.alert = .dailyExceeded
                return .cancel(id: CancelID.timer)

            // MARK: Resend

            case .resendTapped:
                guard state.isResendEnabled else { return .none }
                state.isResending = true
                state.resendCount += 1
                let email = state.maskedEmail   // TODO: [백엔드 연동] 원본 이메일로 교체 (현재는 마스킹값 전달)
                return .run { [client] send in
                    await send(.resendResponse(try await client.resend(email)))
                }
                .cancellable(id: CancelID.resend, cancelInFlight: true)

            case .resendResponse(.sent):
                // 입력 초기화 + 새 3분 타이머
                state.isResending = false
                state.code = ""
                state.inputState = .idle
                state.bottomMessage = .resent
                state.remainingSeconds = Policy.totalSeconds
                state.isTimerRunning = true
                return .merge(
                    .cancel(id: CancelID.timer),
                    .run { [clock] send in
                        for await _ in clock.timer(interval: .seconds(1)) {
                            await send(.timerTicked)
                        }
                    }
                    .cancellable(id: CancelID.timer, cancelInFlight: true)
                )

            case .resendResponse(.resendExceeded):
                state.isResending = false
                state.alert = .resendExceeded
                return .cancel(id: CancelID.timer)

            case .resendResponse(.dailyExceeded):
                state.isResending = false
                state.alert = .dailyExceeded
                return .cancel(id: CancelID.timer)

            // MARK: Alert

            case .alertConfirmed:
                let kind = state.alert
                state.alert = nil
                switch kind {
                case .resendExceeded, .dailyExceeded:
                    return .send(.delegate(.popToFindAccount))
                case .successEmailSignup, .successSocialSignup:
                    // 인증 성공 → 로그인 화면으로 이동 (FindAccount → CredentialLogin 단계까지 dismiss)
                    return .send(.delegate(.navigateToLogin))
                case .timeExpired, .attemptExceeded, .none:
                    // 모달만 닫고 같은 화면 유지 (사용자가 새 인증번호 요청 가능)
                    return .none
                }

            // MARK: Navigation

            case .backButtonTapped:
                return .merge(
                    .cancel(id: CancelID.timer),
                    .cancel(id: CancelID.verify),
                    .cancel(id: CancelID.resend),
                    .send(.delegate(.popToFindAccount))
                )

            case .delegate:
                return .none
            }
        }
    }
}
