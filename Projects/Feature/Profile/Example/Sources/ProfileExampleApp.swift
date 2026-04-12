import SwiftUI
import ComposableArchitecture
import FeatureProfile

@main
struct ProfileExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ProfileView(
                store: .init(
                    initialState: ProfileFeature.State(),
                    reducer: { ProfileFeature() }
                )
            )
        }
    }
}
