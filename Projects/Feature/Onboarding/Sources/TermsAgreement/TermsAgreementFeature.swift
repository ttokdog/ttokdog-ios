import SwiftUI
import ComposableArchitecture

/// 약관동의 화면 Feature 입니다
@Reducer
public struct TermsAgreementFeature: Reducer {
    
    public init() { }
    
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var isAllChecked: Bool = false          // 전체동의
        public var isTermsChecked: Bool = false        // [필수] 이용약관
        public var isPrivacyChecked: Bool = false      // [필수] 개인정보 수집
        public var isThirdPartyChecked: Bool = false   // [필수] 제3자 정보제공
        public var isAgeChecked: Bool = false          // [필수] 만 14세 이상
        public var isLocationChecked: Bool = false     // [선택] 위치정보
        public var isMarketingChecked: Bool = false    // [선택] 마케팅 수신
        
        // 필수 약관 모두 동의 여부 (가입 버튼 활성화 조건)
        public var isRequiredAllChecked: Bool {
            isTermsChecked &&
            isPrivacyChecked &&
            isThirdPartyChecked &&
            isAgeChecked
        }
        
        public init() { }
    }
    
    // MARK: -  Action
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case allCheckToggled // 전체동의 탭
        case signupButtonTapped // 동의하고 가입하기 탭
        case closeButtonTapped // 네비게이션 닫기 탭
        case delegate(Delegate)
        // TODO: 보기 액션 추가
        
        
        public enum Delegate: Equatable {
            case signupCompleted
            case closeTapped
        }
    }
    
    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding(_):
                return .none
                
            case .allCheckToggled:
                state.isAllChecked.toggle()
                let checked = state.isAllChecked
                state.isTermsChecked = checked
                state.isPrivacyChecked = checked
                state.isThirdPartyChecked = checked
                state.isAgeChecked = checked
                state.isLocationChecked = checked
                state.isMarketingChecked = checked
                return .none
                
            case .signupButtonTapped:
                guard state.isRequiredAllChecked else {
                    return .none
                }
                
                return Effect.send(.delegate(.signupCompleted))
                
            case .delegate(_):
                return .none
            case .closeButtonTapped:
                return Effect.send(.delegate(.closeTapped))
            }
            
        }
    }
    
    
}

