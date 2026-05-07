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

        /// 약관 동의 후 push되는 보호자 상태 선택 화면
        @Presents public var guardianStatus: GuardianStatusFeature.State?

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
        /// 보호자 상태 선택 화면 위임 액션
        case guardianStatus(PresentationAction<GuardianStatusFeature.Action>)
        case delegate(Delegate)
        // TODO: 보기 액션 추가


        @CasePathable
        public enum Delegate: Equatable {
            case closeTapped
            /// 보호자 상태 선택까지 완료 — 회원가입 플로우 다음 단계로 진행 (현재 미정)
            case signupFlowCompleted
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
                state.guardianStatus = GuardianStatusFeature.State()
                return .none

            case .guardianStatus(.presented(.delegate(.backTapped))):
                state.guardianStatus = nil
                return .none

            case .guardianStatus(.presented(.delegate(.startCompleted))):
                // TODO: 회원가입 다음 단계 연결 (e.g., SignupView 입력 또는 가입 완료 후 메인 진입)
                state.guardianStatus = nil
                return .send(.delegate(.signupFlowCompleted))

            case .guardianStatus:
                return .none

            case .delegate:
                return .none

            case .closeButtonTapped:
                return Effect.send(.delegate(.closeTapped))
            }

        }
        .ifLet(\.$guardianStatus, action: \.guardianStatus) {
            GuardianStatusFeature()
        }
    }
}

