import SwiftUI
import ComposableArchitecture

public struct OnboardingView: View {
    @Bindable public var store: StoreOf<OnboardingFeature>

    public init(store: StoreOf<OnboardingFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Onboarding")
            .onAppear {
                store.send(.onAppear)
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
