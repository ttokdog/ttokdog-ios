import SwiftUI
import ComposableArchitecture
import FeatureSplash

@main
struct SplashExampleApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView(
                store: .init(
                    initialState: SplashFeature.State(),
                    reducer: { SplashFeature() }
                )
            )
        }
    }
}
