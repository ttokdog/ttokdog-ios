import SwiftUI
import ComposableArchitecture
import FeatureOnboarding

@main
struct OnboardingExampleApp: App {
    var body: some Scene {
        WindowGroup {
            // MARK: - 전체 온보딩 플로우 테스트 (튜토리얼부터 시작)
            // 흐름:
            //   1. 튜토리얼 (3페이지 스와이프) — Skip 또는 마지막 페이지 "시작하기"
            //   2. 로그인 화면 (LoginView) — 소셜 로그인 / "다른계정으로 로그인"
            //   3. 자격 로그인 화면 (CredentialLoginView) — 아이디/비번 입력 / "아이디·비밀번호 찾기"
            //   4. 아이디 찾기 (FindAccountView) — 이메일 입력 → "인증번호 전송"
            //   5. 인증번호 입력 (VerificationCodeView) — 6자리 입력 / 재전송 / 한도 alert / 인증 성공
            //   6. 인증 성공 alert "로그인 하러가기" → CredentialLogin으로 자동 복귀
            //
            // 참고:
            // - OnboardingFeature.State()는 매번 .tutorial로 시작하므로 "앱 처음 실행" 상태를 그대로 재현.
            //   (실제 앱은 AppFeature/Splash에서 처음 실행 여부를 분기하지만, 여기서는 매번 처음부터.)
            // - 인증번호 stub: "123456" → successEmailSignup alert, 그 외 6자리 → mismatch.
            // - 시뮬레이터에서 클립보드에 6자리 숫자 복사 후 Cmd+V → staggered 자동완성 효과 확인 가능.
            OnboardingView(
                store: .init(
                    initialState: OnboardingFeature.State(),
                    reducer: { OnboardingFeature() }
                )
            )

            // MARK: - 이전 단독 테스트 화면들 (필요 시 위 OnboardingView를 주석 처리하고 사용)
//            TermsAgreementView(
//                store: .init(
//                    initialState: TermsAgreementFeature.State(),
//                    reducer: { TermsAgreementFeature() }
//                )
//            )
//
//            VerificationCodeView(
//                store: .init(
//                    initialState: VerificationCodeFeature.State(maskedEmail: "tto****@gmail.com"),
//                    reducer: { VerificationCodeFeature() }
//                )
//            )
        }
    }
}
