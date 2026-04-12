import SwiftUI
import ComposableArchitecture
import FeatureSplash
import FeatureOnboarding
import FeatureTab

public struct AppView: View {
    @Bindable public var store: StoreOf<AppFeature>

    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }

    public var body: some View {
        switch store.state {
        case .splash:
            if let splashStore = store.scope(state: \.splash, action: \.splash) {
                SplashView(store: splashStore)
            }

        case .onboarding:
            if let onboardingStore = store.scope(state: \.onboarding, action: \.onboarding) {
                OnboardingView(store: onboardingStore)
            }

        case .tab:
            if let tabStore = store.scope(state: \.tab, action: \.tab) {
                TabBarView(store: tabStore)
            }
        }
    }
}

#Preview {
    AppView(
        store: .init(
            initialState: AppFeature.State(),
            reducer: { AppFeature() }
        )
    )
}
