import SwiftUI
import ComposableArchitecture

public struct PlanView: View {
    @Bindable public var store: StoreOf<PlanFeature>

    public init(store: StoreOf<PlanFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Plan")
            .onAppear {
                store.send(.onAppear)
            }
    }
}

#Preview {
    PlanView(
        store: .init(
            initialState: PlanFeature.State(),
            reducer: {
                PlanFeature()
            }
        )
    )
}
