import SwiftUI
import ComposableArchitecture

public struct ProfileView: View {
    @Bindable public var store: StoreOf<ProfileFeature>

    public init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Profile")
            .onAppear {
                store.send(.onAppear)
            }
    }
}

#Preview {
    ProfileView(
        store: .init(
            initialState: ProfileFeature.State(),
            reducer: {
                ProfileFeature()
            }
        )
    )
}
