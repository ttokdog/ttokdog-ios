import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

// MARK: - LoginView

public struct LoginView: View {
    @Bindable public var store: StoreOf<LoginFeature>

    public init(store: StoreOf<LoginFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                // TODO: 일러스트 이미지 영역
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray100)
                    .frame(height: 200)
                    .padding(.horizontal, 40)

                Spacer()

                Text("우리 아이를 위한 스마트한 반려생활,\n똑독하게 시작해볼까요?")
                    .typography(.body6)
                    .foregroundStyle(Color.gray900)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)

                socialLoginButtons
                    .padding(.horizontal, 20)

                credentialLoginButton
                    .padding(.top, 16)
                    .padding(.bottom, 40)
            }
            .background(Color.gray50)
            .navigationDestination(
                item: $store.scope(
                    state: \.credentialLogin,
                    action: \.credentialLogin
                )
            ) { credentialStore in
                CredentialLoginView(store: credentialStore)
                    .navigationBarBackButtonHidden()
            }
        }
    }

    private var socialLoginButtons: some View {
        VStack(spacing: 10) {
            socialButton(
                icon: .googleIcon,
                title: "Google로 시작하기",
                backgroundColor: .white,
                foregroundColor: Color.gray900,
                action: { store.send(.googleLoginTapped) }
            )

            socialButton(
                icon: .appleIcon,
                title: "Apple로 시작하기",
                backgroundColor: .black,
                foregroundColor: .white,
                action: { store.send(.appleLoginTapped) }
            )

            socialButton(
                icon: .kakaoIcon,
                title: "Kakao로 시작하기",
                backgroundColor: Color(red: 254/255, green: 229/255, blue: 0/255),
                foregroundColor: .black,
                action: { store.send(.kakaoLoginTapped) }
            )
        }
    }

    private func socialButton(
        icon: Image,
        title: String,
        backgroundColor: Color,
        foregroundColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                Text(title)
                    .typography(.buttonL)
                    .foregroundStyle(foregroundColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var credentialLoginButton: some View {
        Button {
            store.send(.credentialLoginTapped)
        } label: {
            Text("다른계정으로 로그인")
                .typography(.body10)
                .foregroundStyle(Color.gray400)
        }
    }
}

#Preview {
    LoginView(
        store: .init(
            initialState: LoginFeature.State(),
            reducer: { LoginFeature() }
        )
    )
}
