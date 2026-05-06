import Foundation
import ComposableArchitecture


@Reducer
public struct GuardianStatusFeature: Reducer {
    
    public init() { }
    
    // MARK: - Guardian Status Type
    public enum GuardianStatus: Equatable {
        case hasPet // 우리 아이를 키우고 있어요
        case noPet // 아직 키우고 있지는 않아요
    }
    
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var selectedStatus: GuardianStatus? = nil
        
        /// 선택된 상태가 있을 때 시작 버튼 활성화
        public var isStartButtonEnabled: Bool {
            selectedStatus != nil
        }
    }
    
    // MARK: - Action
    public enum Action {
        case backButtonTapped
        case statusOptionTapped(GuardianStatus)
        case startButtonTapped
        case delegate(Delegate)
                
        public enum Delegate {
            case startCompleted
            case backTapped
        }

    }
    
    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .backButtonTapped:
                // TODO: 네비게이션 뒤로가기
                return .none
            case .statusOptionTapped(let status):
                state.selectedStatus = status
                return .none
            case .startButtonTapped:
                guard state.isStartButtonEnabled else {
                    return .none
                }
                
                return .send(.delegate(.startCompleted))
            case .delegate(_):
                return .none
            }
            
        }
    }
    
}
