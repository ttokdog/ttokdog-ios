import SwiftUI
import ComposableArchitecture
import FeatureHome

@main
struct HomeExampleApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(
                store: .init(
                    initialState: HomeFeature.State(),
                    reducer: { HomeFeature() }
                )
            )
        }
    }
}
