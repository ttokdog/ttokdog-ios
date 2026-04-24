import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

// MARK: - LoginView

public struct LoginView: View {
    private let kakaoYellow = Color(red: 254/255, green: 229/255, blue: 0/255)
    @Bindable public var store: StoreOf<LoginFeature>

    public init(store: StoreOf<LoginFeature>) {
        self.store = store
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // TODO: 일러스트 이미지 영역
                Rectangle()
                    .fill(Color.gray100)
                    .frame(width: 167, height: 167)
                    .padding(.top, 109)

                Spacer()

                VStack(spacing: 0) {
                    (Text("우리 아이를 위한 ")
                        .typographyText(.body6)
                        + Text("스마트한 반려생활,")
                        .typographyText(.body5)
                        + Text("\n똑독하게 시작해볼까요?")
                        .typographyText(.body6))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .typographyLineSpacing(.body6)
                        .padding(.top, 24)
                        .padding(.bottom, 26)

                    socialLoginButtons
                        .padding(.horizontal, 20)

                    credentialLoginButton
                        .padding(.top, 18)
                        .padding(.bottom, 34)
                }
                .background(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 15,
                        topTrailingRadius: 15
                    )
                    .fill(Color.primary500)
                )
            }
            .background(Color.gray50)
            .ignoresSafeArea(edges: .bottom)
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

    // MARK: - Social Login

    private var socialLoginButtons: some View {
        VStack(spacing: 12) {
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
                backgroundColor: kakaoYellow,
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
            HStack(spacing: 0) {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(.leading, 24)

                Spacer()

                Text(title)
                    .typography(.buttonL)
                    .foregroundStyle(foregroundColor)

                Spacer()

                Color.clear
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 24)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }

    // MARK: - Credential Login

    private var credentialLoginButton: some View {
        Button {
            store.send(.credentialLoginTapped)
        } label: {
            Text("다른계정으로 로그인")
                .typography(.body11)
                .foregroundStyle(Color.gray600)
                .underline()
        }
    }
}

// MARK: - Preview

#Preview {
    LoginView(
        store: .init(
            initialState: LoginFeature.State(),
            reducer: { LoginFeature() }
        )
    )
}
