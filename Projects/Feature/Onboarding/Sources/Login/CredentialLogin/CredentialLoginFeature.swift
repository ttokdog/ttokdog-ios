import Foundation
import ComposableArchitecture

// MARK: - CredentialLoginFeature

@Reducer
public struct CredentialLoginFeature: Reducer {

    @ObservableState
    public struct State: Equatable {
        public var id: String = ""
        public var password: String = ""
        public var isPasswordVisible: Bool = false
        public var errorMessage: String?

        public var isLoginEnabled: Bool {
            !id.isEmpty && !password.isEmpty
        }

        public init() {}
    }

    public init() {}

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loginTapped
        case togglePasswordVisibility
        case signUpTapped
        case findPasswordTapped
        case delegate(Delegate)

        public enum Delegate {
            case loginCompleted
        }
    }

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

            case .findPasswordTapped:
                // TODO: 비밀번호 찾기 화면 연결
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
