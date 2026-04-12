import Foundation
import ComposableArchitecture
import FeatureSplash
import FeatureOnboarding
import FeatureTab

@Reducer
public struct AppFeature: Reducer {

    @ObservableState
    public enum State: Equatable {
        case splash(SplashFeature.State)
        case onboarding(OnboardingFeature.State)
        case tab(TabFeature.State)

        public init() {
            self = .splash(SplashFeature.State())
        }
    }

    public init() {}

    public enum Action {
        case splash(SplashFeature.Action)
        case onboarding(OnboardingFeature.Action)
        case tab(TabFeature.Action)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .splash(.delegate(.splashCompleted(isAuthenticated))):
                if isAuthenticated {
                    state = .tab(TabFeature.State())
                } else {
                    state = .onboarding(OnboardingFeature.State())
                }
                return .none

            case .splash, .onboarding, .tab:
                return .none
            }
        }
        .ifCaseLet(\.splash, action: \.splash) {
            SplashFeature()
        }
        .ifCaseLet(\.onboarding, action: \.onboarding) {
            OnboardingFeature()
        }
        .ifCaseLet(\.tab, action: \.tab) {
            TabFeature()
        }
    }
}
