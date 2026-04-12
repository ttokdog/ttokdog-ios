import Foundation
import ComposableArchitecture
import FeatureHome
import FeaturePlan
import FeatureMap
import FeatureProfile

@Reducer
public struct TabFeature: Reducer {

    public enum Tab: String, Equatable, CaseIterable {
        case home
        case plan
        case map
        case profile
    }

    @ObservableState
    public struct State: Equatable {
        public var selectedTab: Tab = .home
        public var home: HomeFeature.State = .init()
        public var plan: PlanFeature.State = .init()
        public var map: MapFeature.State = .init()
        public var profile: ProfileFeature.State = .init()

        public init() {}
    }

    public init() {}

    public enum Action {
        case tabSelected(Tab)
        case home(HomeFeature.Action)
        case plan(PlanFeature.Action)
        case map(MapFeature.Action)
        case profile(ProfileFeature.Action)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none

            case .home, .plan, .map, .profile:
                return .none
            }
        }

        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Scope(state: \.plan, action: \.plan) {
            PlanFeature()
        }
        Scope(state: \.map, action: \.map) {
            MapFeature()
        }
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
    }
}
