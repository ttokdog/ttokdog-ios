import Foundation
import ComposableArchitecture

// MARK: - LoginFeature

@Reducer
public struct LoginFeature: Reducer {

    @ObservableState
    public struct State: Equatable {
        @Presents var credentialLogin: CredentialLoginFeature.State?

        public init() {}
    }

    public init() {}

    public enum Action {
        case googleLoginTapped
        case appleLoginTapped
        case kakaoLoginTapped
        case credentialLoginTapped
        case credentialLogin(PresentationAction<CredentialLoginFeature.Action>)
        case delegate(Delegate)

        public enum Delegate {
            case loginCompleted
        }
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .googleLoginTapped:
                // TODO: Google 로그인 연동
                return .none

            case .appleLoginTapped:
                // TODO: Apple 로그인 연동
                return .none

            case .kakaoLoginTapped:
                // TODO: Kakao 로그인 연동
                return .none

            case .credentialLoginTapped:
                state.credentialLogin = CredentialLoginFeature.State()
                return .none

            case .credentialLogin(.presented(.delegate(.loginCompleted))):
                state.credentialLogin = nil
                return .send(.delegate(.loginCompleted))

            case .credentialLogin:
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$credentialLogin, action: \.credentialLogin) {
            CredentialLoginFeature()
        }
    }
}
