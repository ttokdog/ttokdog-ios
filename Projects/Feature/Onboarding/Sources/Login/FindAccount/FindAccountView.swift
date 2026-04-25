import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

// MARK: - FindAccountView

public struct FindAccountView: View {
    @Bindable public var store: StoreOf<FindAccountFeature>

    public init(store: StoreOf<FindAccountFeature>) {
        self.store = store
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNavigationBar(
                    title: "아이디/비밀번호 찾기",
                    onBack: { store.send(.backButtonTapped) }
                )

                tabPicker

                switch store.selectedTab {
                case .findId:
                    findIdContent
                case .findPassword:
                    findPasswordContent
                }

                Spacer()
            }
            .background(Color.gray50)
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil, from: nil, for: nil
                )
            }

            if store.showTempPasswordAlert {
                tempPasswordAlertOverlay
            }
        }
    }

    // MARK: - Tab Picker

    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(FindAccountFeature.Tab.allCases, id: \.self) { tab in
                Button {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil, from: nil, for: nil
                    )
                    store.send(.tabSelected(tab))
                } label: {
                    VStack(spacing: 8) {
                        Text(tab.title)
                            .typography(store.selectedTab == tab ? .body9 : .body11)
                            .foregroundStyle(
                                store.selectedTab == tab ? Color.primary500 : Color.gray400
                            )

                        Rectangle()
                            .fill(store.selectedTab == tab ? Color.primary500 : Color.gray200)
                            .frame(height: store.selectedTab == tab ? 2 : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            }
        }
    }

    // MARK: - 아이디 찾기

    private var findIdContent: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("이메일")
                    .typography(.body11)
                    .foregroundStyle(Color.gray500)

                InputField(
                    placeholder: "example@example.com",
                    text: $store.findId.email,
                    keyboardType: .emailAddress,
                    hasError: store.findId.emailError != nil || store.findId.notFoundError != nil
                )

                if let error = store.findId.emailError {
                    ErrorLabel(message: error)
                } else if let error = store.findId.notFoundError {
                    ErrorLabel(message: error)
                }
            }

            Button {
                store.send(.sendVerificationTapped)
            } label: {
                Text("인증번호 전송")
                    .typography(.buttonL)
                    .foregroundStyle(store.findId.isSendVerificationEnabled ? .white : Color.gray400)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(store.findId.isSendVerificationEnabled ? Color.primary500 : Color.gray300)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .disabled(!store.findId.isSendVerificationEnabled)
            .padding(.top, 46)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }

    // MARK: - 비밀번호 찾기

    private var findPasswordContent: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("아이디")
                    .typography(.body11)
                    .foregroundStyle(Color.gray500)

                InputField(
                    placeholder: "아이디를 입력해주세요",
                    text: $store.findPassword.loginId,
                    hasError: store.findPassword.loginIdError != nil || store.findPassword.accountNotFoundError != nil
                )

                if let error = store.findPassword.loginIdError {
                    ErrorLabel(message: error)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("이메일")
                    .typography(.body11)
                    .foregroundStyle(Color.gray500)

                InputField(
                    placeholder: "example@example.com",
                    text: $store.findPassword.email,
                    keyboardType: .emailAddress,
                    hasError: store.findPassword.emailError != nil || store.findPassword.accountNotFoundError != nil
                )

                if let error = store.findPassword.emailError {
                    ErrorLabel(message: error)
                }
            }
            .padding(.top, 20)

            Button {
                store.send(.tempPasswordTapped)
            } label: {
                Text("임시 비밀번호 발급")
                    .typography(.buttonL)
                    .foregroundStyle(store.findPassword.isTempPasswordEnabled ? .white : Color.gray400)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(store.findPassword.isTempPasswordEnabled ? Color.primary500 : Color.gray300)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .disabled(!store.findPassword.isTempPasswordEnabled)
            .padding(.top, 46)

            if let error = store.findPassword.accountNotFoundError {
                ErrorLabel(message: error)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
    }

    // MARK: - 임시 비밀번호 발급 완료 Alert

    private var tempPasswordAlertOverlay: some View {
        CustomAlert(
            title: "이메일로 임시 비밀번호를 보냈어요.",
            description: "발급된 임시 비밀번호로 로그인 후,\n반드시 새 비밀번호로 변경해주세요.",
            primaryButtonTitle: "로그인 하러가기",
            primaryAction: { store.send(.tempPasswordAlertConfirmed) }
        )
    }

}

// MARK: - Preview

#Preview("아이디 찾기") {
    FindAccountView(
        store: .init(
            initialState: FindAccountFeature.State(),
            reducer: { FindAccountFeature() }
        )
    )
}

#Preview("아이디 찾기 - 이메일 형식 에러") {
    FindAccountView(
        store: .init(
            initialState: {
                var state = FindAccountFeature.State()
                state.findId.email = "ttokdog"
                state.findId.emailError = "올바른 이메일 형식을 입력해주세요."
                return state
            }(),
            reducer: { FindAccountFeature() }
        )
    )
}

#Preview("아이디 찾기 - 가입 정보 없음") {
    FindAccountView(
        store: .init(
            initialState: {
                var state = FindAccountFeature.State()
                state.findId.email = "ttokdog@naver.com"
                state.findId.notFoundError = "가입 정보가 없어요."
                return state
            }(),
            reducer: { FindAccountFeature() }
        )
    )
}

#Preview("비밀번호 찾기 - 빈 상태") {
    FindAccountView(
        store: .init(
            initialState: {
                var state = FindAccountFeature.State()
                state.selectedTab = .findPassword
                return state
            }(),
            reducer: { FindAccountFeature() }
        )
    )
}

#Preview("비밀번호 찾기 - 유효성 에러") {
    FindAccountView(
        store: .init(
            initialState: {
                var state = FindAccountFeature.State()
                state.selectedTab = .findPassword
                state.findPassword.loginId = "t"
                state.findPassword.loginIdError = "아이디는 6~15자 이내로 입력해주세요."
                state.findPassword.email = "ttokdog"
                state.findPassword.emailError = "올바른 이메일 형식을 입력해주세요."
                return state
            }(),
            reducer: { FindAccountFeature() }
        )
    )
}

#Preview("비밀번호 찾기 - 가입 정보 없음") {
    FindAccountView(
        store: .init(
            initialState: {
                var state = FindAccountFeature.State()
                state.selectedTab = .findPassword
                state.findPassword.loginId = "t"
                state.findPassword.email = "ttokdog@naver.com"
                state.findPassword.accountNotFoundError = "가입된 정보가 없어요."
                return state
            }(),
            reducer: { FindAccountFeature() }
        )
    )
}

#Preview("비밀번호 찾기 - 임시 비밀번호 발급 완료") {
    FindAccountView(
        store: .init(
            initialState: {
                var state = FindAccountFeature.State()
                state.selectedTab = .findPassword
                state.findPassword.loginId = "ttokdog"
                state.findPassword.email = "ttokdog@naver.com"
                state.showTempPasswordAlert = true
                return state
            }(),
            reducer: { FindAccountFeature() }
        )
    )
}
