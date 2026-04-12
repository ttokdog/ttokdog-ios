import Testing
import FeatureSplash
@testable import FeatureAppCoordinator

struct AppCoordinatorTests {
    @Test func initialStateIsSplash() {
        let state = AppFeature.State()
        #expect(state == .splash(SplashFeature.State()))
    }
}
