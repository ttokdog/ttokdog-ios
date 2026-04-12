import Foundation
import ComposableArchitecture

@Reducer
public struct MapFeature: Reducer {

    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public init() {}

    public enum Action {
        case onAppear
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
