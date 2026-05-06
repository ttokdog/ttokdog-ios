import Foundation
import ComposableArchitecture

// MARK: - CredentialLoginFeature

@Reducer
public struct CredentialLoginFeature {

    // MARK: - State

    @ObservableState
    public struct State: Equatable {
        public var id: String = ""
        public var password: String = ""
        public var isPasswordVisible: Bool = false
        public var errorMessage: String?
        @Presents var findAccount: FindAccountFeature.State?
        /// 회원가입 진입 — SignupView 정보 입력부터 시작 (다음으로 → 약관동의 → 보호자 상태 선택까지 SignupFeature 내부 체인)
        @Presents var signup: SignupFeature.State?

        public var isLoginEnabled: Bool {
            !id.isEmpty && !password.isEmpty
        }

        public init() {}
    }

    public init() {}

    // MARK: - Action

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loginTapped
        case togglePasswordVisibility
        case signUpTapped
        case findAccountTapped
        case findAccount(PresentationAction<FindAccountFeature.Action>)
        /// 회원가입 화면 위임 액션
        case signup(PresentationAction<SignupFeature.Action>)
        case backButtonTapped
        case delegate(Delegate)

        public enum Delegate {
            case loginCompleted
        }
    }

    // MARK: - Reducer

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                state.errorMessage = nil
                return .none

            case .loginTapped:
                // TODO: 로그인 API 연동
                return .none

            case .togglePasswordVisibility:
                state.isPasswordVisible.toggle()
                return .none

            case .signUpTapped:
                // 회원가입 진입 — SignupView 정보 입력부터 시작
                state.signup = SignupFeature.State()
                return .none

            case .signup(.presented(.delegate(.navigateToLogin))):
                // SignupView "로그인 하러가기" 또는 약관동의 X → 회원가입 플로우 종료, 작성 데이터 폐기
                state.signup = nil
                return .none

            case .signup(.presented(.delegate(.signupFlowCompleted))):
                // TODO: 회원가입 전체 플로우 완료 → 메인 진입 등 후속 단계 연결
                state.signup = nil
                return .none

            case .signup:
                return .none

            case .findAccountTapped:
                state.findAccount = FindAccountFeature.State()
                return .none

            case .findAccount(.presented(.backButtonTapped)),
                 .findAccount(.presented(.delegate(.navigateToLogin))):
                state.findAccount = nil
                return .none

            case .findAccount:
                return .none

            case .backButtonTapped:
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$findAccount, action: \.findAccount) {
            FindAccountFeature()
        }
        .ifLet(\.$signup, action: \.signup) {
            SignupFeature()
        }
    }
}
