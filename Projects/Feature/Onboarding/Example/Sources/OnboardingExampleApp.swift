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
        }
    }
}
