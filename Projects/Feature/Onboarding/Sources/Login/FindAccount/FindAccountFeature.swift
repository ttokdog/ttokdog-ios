import Foundation
import ComposableArchitecture

// MARK: - FindAccountFeature

@Reducer
public struct FindAccountFeature {

    // MARK: - Tab

    public enum Tab: Int, CaseIterable, Equatable {
        case findId
        case findPassword

        var title: String {
            switch self {
            case .findId: "아이디 찾기"
            case .findPassword: "비밀번호 찾기"
            }
        }
    }

    // MARK: - FindIdState

    public struct FindIdState: Equatable {
        public var email: String = ""
        public var emailError: String?
        public var notFoundError: String?
        // TODO: 인증번호 입력 상태 추가 (verificationCode, isVerificationSent, timer 등)
        // TODO: 아이디 찾기 결과 상태 추가 (foundId 등)

        public var isSendVerificationEnabled: Bool {
            !email.isEmpty
        }

        public init() {}
    }

    // MARK: - FindPasswordState

    public struct FindPasswordState: Equatable {
        public var loginId: String = ""
        public var email: String = ""
        public var loginIdError: String?
        public var emailError: String?
        public var accountNotFoundError: String?

        public var isTempPasswordEnabled: Bool {
            !loginId.isEmpty && !email.isEmpty
        }

        public init() {}
    }

    // MARK: - State

    @ObservableState
    public struct State: Equatable {
        public var selectedTab: Tab = .findId
        public var findId: FindIdState = .init()
        public var findPassword: FindPasswordState = .init()
        public var showTempPasswordAlert: Bool = false
        // TODO: 로딩 상태 추가 (isLoading)

        public init() {}
    }

    public init() {}

    // MARK: - Action

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tabSelected(Tab)
        case sendVerificationTapped
        // TODO: 인증번호 입력/확인 액션 추가 (verifyCodeTapped, resendVerificationTapped)
        // TODO: 아이디 찾기 API 응답 액션 추가
        case tempPasswordTapped
        // TODO: 임시 비밀번호 발급 API 응답 액션 추가
        case tempPasswordAlertConfirmed
        case backButtonTapped
        case delegate(Delegate)

        public enum Delegate {
            case navigateToLogin
        }
    }

    // MARK: - Reducer

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.findId.email):
                state.findId.emailError = nil
                state.findId.notFoundError = nil
                return .none

            case .binding(\.findPassword.loginId):
                state.findPassword.loginIdError = nil
                state.findPassword.accountNotFoundError = nil
                return .none

            case .binding(\.findPassword.email):
                state.findPassword.emailError = nil
                state.findPassword.accountNotFoundError = nil
                return .none

            case .binding:
                return .none

            case .tabSelected(let tab):
                state.selectedTab = tab
                state.findId.emailError = nil
                state.findId.notFoundError = nil
                state.findPassword.loginIdError = nil
                state.findPassword.emailError = nil
                state.findPassword.accountNotFoundError = nil
                return .none

            case .sendVerificationTapped:
                if !Self.isValidEmail(state.findId.email) {
                    state.findId.emailError = "올바른 이메일 형식을 입력해주세요."
                }
                guard state.findId.emailError == nil else {
                    return .none
                }
                // TODO: 인증번호 전송 API 연동
                // TODO: API 성공 → 인증번호 입력 UI 표시, 타이머 시작
                // TODO: API 실패 → notFoundError 설정 (가입 정보 없음)
                return .none

            case .tempPasswordTapped:
                if state.findPassword.loginId.count < 6 || state.findPassword.loginId.count > 15 {
                    state.findPassword.loginIdError = "아이디는 6~15자 이내로 입력해주세요."
                }
                if !Self.isValidEmail(state.findPassword.email) {
                    state.findPassword.emailError = "올바른 이메일 형식을 입력해주세요."
                }
                guard state.findPassword.loginIdError == nil && state.findPassword.emailError == nil else {
                    return .none
                }
                // TODO: 임시 비밀번호 발급 API 연동
                // TODO: API 성공 → showTempPasswordAlert = true (현재 스텁)
                // TODO: API 실패 → accountNotFoundError 설정 (가입된 정보 없음)
                state.showTempPasswordAlert = true
                return .none

            case .tempPasswordAlertConfirmed:
                state.showTempPasswordAlert = false
                return .send(.delegate(.navigateToLogin))

            case .backButtonTapped:
                return .none

            case .delegate:
                return .none
            }
        }
    }

    private static func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+\\-]+@[A-Za-z0-9.\\-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }
}
