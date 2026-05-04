import SwiftUI
import ComposableArchitecture
import FeatureOnboarding

@main
struct OnboardingExampleApp: App {
    var body: some Scene {
        WindowGroup {
            OnboardingView(
                store: .init(
                    initialState: OnboardingFeature.State(),
                    reducer: { OnboardingFeature() }
                )
            )
            
            // MARK: - 디바이스 테스트용 (회원가입 화면)
            // TODO: 실제 배포 시 OnboardingView로 교체 필요
//            SignupView(
//                store: .init(
//                    initialState: SignupFeature.State(),
//                    reducer: { SignupFeature() }
//                )
//            )
            
        }
    }
}
