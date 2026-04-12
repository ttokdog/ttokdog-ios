import SwiftUI
import ComposableArchitecture
import FeatureAppCoordinator

@main
struct AppCoordinatorExampleApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: .init(
                    initialState: AppFeature.State(),
                    reducer: { AppFeature() }
                )
            )
        }
    }
}
