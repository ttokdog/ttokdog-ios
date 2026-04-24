import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

// MARK: - CredentialLoginView

public struct CredentialLoginView: View {
    @Bindable public var store: StoreOf<CredentialLoginFeature>
    @Environment(\.dismiss) private var dismiss

    public init(store: StoreOf<CredentialLoginFeature>) {
        self.store = store
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                title: "다른계정으로 로그인",
                onBack: { dismiss() }
            )

            VStack(spacing: 16) {
                idField
                passwordField
            }
            .padding(.top, 32)
            .padding(.horizontal, 20)

            if let errorMessage = store.errorMessage {
                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.error)

                    Text(errorMessage)
                        .typography(.error)
                        .foregroundStyle(Color.error)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
            } else {
                Spacer()
                    .frame(height: 50)
            }

            loginButton
                .padding(.horizontal, 20)

            bottomLinks
                .padding(.top, 20)
            
            Spacer()
        }
        .background(Color.gray50)
    }

    // MARK: - Input Fields

    private var idField: some View {
        HStack {
            TextField("아이디를 입력해주세요", text: $store.id)
                .typography(.body11)

            if !store.id.isEmpty {
                Button {
                    store.send(.binding(.set(\.id, "")))
                } label: {
                    Image.inputErase
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color.gray300)
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 52)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    store.errorMessage != nil ? Color.error : Color.gray200,
                    lineWidth: 1
                )
        )
    }

    private var passwordField: some View {
        HStack {
            Group {
                if store.isPasswordVisible {
                    TextField("비밀번호를 입력해주세요", text: $store.password)
                } else {
                    SecureField("비밀번호를 입력해주세요", text: $store.password)
                }
            }
            .typography(.body11)

            if !store.password.isEmpty {
                Button {
                    store.send(.togglePasswordVisibility)
                } label: {
                    (store.isPasswordVisible ? Image.eye : Image.eyeOff)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.gray300)
                }
            }

            if !store.password.isEmpty {
                Button {
                    store.send(.binding(.set(\.password, "")))
                } label: {
                    Image.inputErase
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color.gray400)
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 52)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    store.errorMessage != nil ? Color.error : Color.gray200,
                    lineWidth: 1
                )
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
