import SwiftUI
import ComposableArchitecture
import FeaturePlan

@main
struct PlanExampleApp: App {
    var body: some Scene {
        WindowGroup {
            PlanView(
                store: .init(
                    initialState: PlanFeature.State(),
                    reducer: { PlanFeature() }
                )
            )
        }
    }
}
