import SwiftUI
import ComposableArchitecture

// MARK: - OnboardingView

/// 온보딩 플로우 라우팅 View
/// - OnboardingFeature의 enum State에 따라 child View를 표시
public struct OnboardingView: View {
    @Bindable public var store: StoreOf<OnboardingFeature>

    public init(store: StoreOf<OnboardingFeature>) {
        self.store = store
    }

    public var body: some View {
        switch store.state {
        case .tutorial:
            if let tutorialStore = store.scope(state: \.tutorial, action: \.tutorial) {
                TutorialView(store: tutorialStore)
            }
        case .login:
            if let loginStore = store.scope(state: \.login, action: \.login) {
                LoginView(store: loginStore)
            }
        }
    }
}

#Preview {
    OnboardingView(
        store: .init(
            initialState: OnboardingFeature.State(),
            reducer: {
                OnboardingFeature()
            }
        )
    )
}
