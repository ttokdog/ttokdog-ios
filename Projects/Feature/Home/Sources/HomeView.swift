import SwiftUI
import ComposableArchitecture

public struct HomeView: View {
    @Bindable public var store: StoreOf<HomeFeature>

    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Home")
            .onAppear {
                store.send(.onAppear)
            }
    }
}

#Preview {
    HomeView(
        store: .init(
            initialState: HomeFeature.State(),
            reducer: {
                HomeFeature()
            }
        )
    )
}
