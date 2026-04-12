import SwiftUI
import ComposableArchitecture
import FeatureTab

@main
struct TabExampleApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarView(
                store: .init(
                    initialState: TabFeature.State(),
                    reducer: { TabFeature() }
                )
            )
        }
    }
}
