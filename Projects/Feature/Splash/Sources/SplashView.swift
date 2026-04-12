import SwiftUI
import ComposableArchitecture

public struct SplashView: View {
    @Bindable public var store: StoreOf<SplashFeature>

    public init(store: StoreOf<SplashFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Splash")
            .onAppear {
                store.send(.onAppear)
            }
    }
}

#Preview {
    SplashView(
        store: .init(
            initialState: SplashFeature.State(),
            reducer: {
                SplashFeature()
            }
        )
    )
}
