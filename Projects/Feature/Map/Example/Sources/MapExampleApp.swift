import SwiftUI
import ComposableArchitecture
import FeatureMap

@main
struct MapExampleApp: App {
    var body: some Scene {
        WindowGroup {
            MapView(
                store: .init(
                    initialState: MapFeature.State(),
                    reducer: { MapFeature() }
                )
            )
        }
    }
}
