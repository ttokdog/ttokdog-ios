import SwiftUI
import ComposableArchitecture
import FeatureAppCoordinator

@main
struct TtokdogApp: App {
    let store = Store(
        initialState: AppFeature.State(),
        reducer: { AppFeature() }
    )

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}
