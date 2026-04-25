import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

// MARK: - CredentialLoginView

public struct CredentialLoginView: View {
    @Bindable public var store: StoreOf<CredentialLoginFeature>

    public init(store: StoreOf<CredentialLoginFeature>) {
        self.store = store
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                title: "다른계정으로 로그인",
                onBack: { store.send(.backButtonTapped) }
            )

            VStack(spacing: 16) {
                idField
                passwordField
            }
            .padding(.top, 32)
            .padding(.horizontal, 20)

            if let errorMessage = store.errorMessage {
                ErrorLabel(message: errorMessage)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
            } else {
                Color.clear
                    .frame(height: 50)
            }

            loginButton
                .padding(.horizontal, 20)

            bottomLinks
                .padding(.top, 20)

            Spacer()
        }
        .background(Color.gray50)
        .navigationDestination(
            item: $store.scope(
                state: \.findAccount,
                action: \.findAccount
            )
        ) { findAccountStore in
            FindAccountView(store: findAccountStore)
                .navigationBarBackButtonHidden()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
    }

    // MARK: - Input Fields

    private var idField: some View {
        InputField(
            placeholder: "아이디를 입력해주세요",
            text: $store.id,
            hasError: store.errorMessage != nil
        )
    }

    private var passwordField: some View {
        InputField(
            placeholder: "비밀번호를 입력해주세요",
            text: $store.password,
            isSecure: true,
            isPasswordVisible: store.isPasswordVisible,
            onToggleVisibility: { store.send(.togglePasswordVisibility) },
            hasError: store.errorMessage != nil
        )
    }

    // MARK: - Login Button

    private var loginButton: some View {
        Button {
            store.send(.loginTapped)
        } label: {
            Text("로그인")
                .typography(.buttonL)
                .foregroundStyle(store.isLoginEnabled ? .white : Color.gray400)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(store.isLoginEnabled ? Color.primary500 : Color.gray300)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .disabled(!store.isLoginEnabled)
    }

    // MARK: - Bottom Links

    private var bottomLinks: some View {
        HStack {
            Button {
                store.send(.signUpTapped)
            } label: {
                Text("회원가입")
                    .typography(.body10)
                    .foregroundStyle(Color.gray500)
                    .underline()
            }

            Spacer()

            Button {
                store.send(.findAccountTapped)
            } label: {
                Text("아이디/비밀번호 찾기")
                    .typography(.body10)
                    .foregroundStyle(Color.gray500)
                    .underline()
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Preview

#Preview("기본") {
    CredentialLoginView(
        store: .init(
            initialState: CredentialLoginFeature.State(),
            reducer: { CredentialLoginFeature() }
        )
    )
}

#Preview("로그인 실패") {
    CredentialLoginView(
        store: .init(
            initialState: {
                var state = CredentialLoginFeature.State()
                state.id = "dddd"
                state.password = "dddd"
                state.errorMessage = "아이디 혹은 비밀번호가 일치하지 않아요."
                return state
            }(),
            reducer: { CredentialLoginFeature() }
        )
    )
}

#Preview("계정 잠금") {
    CredentialLoginView(
        store: .init(
            initialState: {
                var state = CredentialLoginFeature.State()
                state.id = "dddd"
                state.password = "dddd"
                state.errorMessage = "아이디 또는 비밀번호를 여러 번 잘못 입력했습니다.\n보안을 위해 10분 후 다시 시도해주세요."
                return state
            }(),
            reducer: { CredentialLoginFeature() }
        )
    )
}
