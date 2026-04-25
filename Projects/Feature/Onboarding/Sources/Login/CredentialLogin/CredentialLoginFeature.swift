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
                // TODO: 회원가입 화면 연결
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
    }
}
