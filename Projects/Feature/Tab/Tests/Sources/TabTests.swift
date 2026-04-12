import Testing
@testable import FeatureTab

struct TabTests {
    @Test func defaultTabIsHome() {
        let state = TabFeature.State()
        #expect(state.selectedTab == .home)
    }
}
