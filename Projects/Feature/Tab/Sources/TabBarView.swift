import SwiftUI
import ComposableArchitecture
import FeatureHome
import FeaturePlan
import FeatureMap
import FeatureProfile

public struct TabBarView: View {
    @Bindable public var store: StoreOf<TabFeature>

    public init(store: StoreOf<TabFeature>) {
        self.store = store
    }

    // TODO: 탭바 아이콘은 디자인 확정 후 DesignSystem 에셋으로 교체 예정
    public var body: some View {
        TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
            HomeView(store: store.scope(state: \.home, action: \.home))
                .tag(TabFeature.Tab.home)
                .tabItem {
                    Label("홈", systemImage: "house")
                }

            PlanView(store: store.scope(state: \.plan, action: \.plan))
                .tag(TabFeature.Tab.plan)
                .tabItem {
                    Label("댕플랜", systemImage: "calendar")
                }

            MapView(store: store.scope(state: \.map, action: \.map))
                .tag(TabFeature.Tab.map)
                .tabItem {
                    Label("동네산책", systemImage: "map")
                }

            ProfileView(store: store.scope(state: \.profile, action: \.profile))
                .tag(TabFeature.Tab.profile)
                .tabItem {
                    Label("My", systemImage: "person")
                }
        }
    }
}

#Preview {
    TabBarView(
        store: .init(
            initialState: TabFeature.State(),
            reducer: { TabFeature() }
        )
    )
}
