import Foundation
import ComposableArchitecture

@Reducer
public struct SplashFeature: Reducer {

    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public init() {}

    public enum Action {
        case onAppear
        case delegate(Delegate)

        public enum Delegate {
            case splashCompleted(isAuthenticated: Bool)
        }
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // TODO: 인증 상태 확인 로직 연결 (Domain 레이어)
                // 현재는 스텁으로 미인증 상태를 반환
                return .send(.delegate(.splashCompleted(isAuthenticated: false)))

            case .delegate:
                return .none
            }
        }
    }
}
