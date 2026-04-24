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
                HStack {
                    Text(errorMessage)
                        .typography(.error)
                        .foregroundStyle(Color.error)
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.horizontal, 20)
            }

            loginButton
                .padding(.top, 24)
                .padding(.horizontal, 20)

            Spacer()

            bottomLinks
                .padding(.bottom, 40)
        }
        .background(Color.gray50)
    }

    private var idField: some View {
        TextField("아이디를 입력해주세요", text: $store.id)
            .typography(.body8)
            .padding(.horizontal, 16)
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
            .typography(.body8)

            Button {
                store.send(.togglePasswordVisibility)
            } label: {
                (store.isPasswordVisible ? Image.eye : Image.eyeOff)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.gray400)
            }
        }
        .padding(.horizontal, 16)
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

    private var loginButton: some View {
        Button {
            store.send(.loginTapped)
        } label: {
            Text("로그인")
                .typography(.buttonL)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(store.isLoginEnabled ? Color.primary500 : Color.gray400)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!store.isLoginEnabled)
    }

    private var bottomLinks: some View {
        HStack {
            Button {
                store.send(.signUpTapped)
            } label: {
                Text("회원가입")
                    .typography(.body10)
                    .foregroundStyle(Color.gray500)
            }

            Spacer()

            Button {
                store.send(.findPasswordTapped)
            } label: {
                Text("아이디/비밀번호 찾기")
                    .typography(.body10)
                    .foregroundStyle(Color.gray500)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CredentialLoginView(
        store: .init(
            initialState: CredentialLoginFeature.State(),
            reducer: { CredentialLoginFeature() }
        )
    )
}
