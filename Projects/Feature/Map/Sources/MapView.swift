import SwiftUI
import ComposableArchitecture

public struct MapView: View {
    @Bindable public var store: StoreOf<MapFeature>

    public init(store: StoreOf<MapFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Map")
            .onAppear {
                store.send(.onAppear)
            }
    }
}

#Preview {
    MapView(
        store: .init(
            initialState: MapFeature.State(),
            reducer: {
                MapFeature()
            }
        )
    )
}
