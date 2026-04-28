import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

struct SignupView: View {
    
    @Bindable public var store: StoreOf<SignupFeature>

    public init(store: StoreOf<SignupFeature>) {
        self.store = store
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "회원가입", onBack: { })
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // MARK: - 아이디
                    VStack(alignment: .leading, spacing: 6) {
                        FieldHeader(title: "아이디", description: "(6~15자 이내의 영문 소문자, 숫자 사용 가능)")
                        
                        DuplicateCheckInputField(
                            text: $store.id,
                            minimumLength: 6,
                            placeholder: "생성할 아이디를 입력해주세요",
                            checkResult: nil,
                            errorMessage: "중복된 아이디입니다.",
                            successMessage: "사용이 가능한 아이디입니다",
                            onClear: { store.send(.clearIdTapped)},
                            onDuplicateCheck: { store.send(.checkDuplicateIdTapped) }
                        )
                        
                        // TODO: 에러 문구
                        
                    }
                    
                    // MARK: - 비밀번호
                    VStack(alignment: .leading, spacing: 6) {
                        FieldHeader(title: "비밀번호", description: "(8~20자 이내의 영문/숫자/특수문자 혼합)")
                        
                        VStack(spacing: 6) {
                            SignupPasswordInputField(
                                text: $store.password,
                                placeholder: "생성할 비밀번호를 입력해주세요",
                                isVisible: store.isPasswordVisible,
                                isError: !store.password.isEmpty,
                                onToggleVisibility: { store.send(.togglePasswordVisibility) },
                                onClear: { store.send(.clearPasswordTapped) }
                            )
                            
                            SignupPasswordInputField(
                                text: $store.passwordConfirm,
                                placeholder: "비밀번호를 한번 더 입력해주세요",
                                isVisible: store.isPasswordConfirmVisible,
                                isError: false,
                                onToggleVisibility: { store.send(.togglePasswordConfirmVisibility) },
                                onClear: { store.send(.clearPasswordConfirmTapped) }
                            )
                            
                            // TODO: 에러 문구
                        }
                    }
                    
                    // MARK: - 이메일
                    VStack(alignment: .leading, spacing: 6) {
                        FieldHeader(title: "이메일")

                        PlainInputField(
                            text: $store.email,
                            placeholder: "example@example.com",
                            isError: true,
                            onClear: { store.send(.clearEmailTapped) }
                        )
                        
                        // TODO: 에러 문구
                        
                    }
                    
                    // MARK: - 닉네임
                    VStack(alignment: .leading, spacing: 6) {
                        FieldHeader(title: "닉네임", description: "(1~10자 이내의 한글/영문/숫자)")
                        
                        DuplicateCheckInputField(
                            text: $store.nickname,
                            minimumLength: 1,
                            placeholder: "사용할 닉네임을 입력하세요",
                            checkResult: nil,
                            errorMessage: "중복된 닉네임입니다.",
                            successMessage: "사용이 가능한 닉네임입니다",
                            onClear: { store.send(.clearNicknameTapped)},
                            onDuplicateCheck: { store.send(.checkDuplicateNicknameTapped) }
                        )
                        
                        // TODO: 에러 문구
                        
                    }
                    
                }
                .padding(20)
                
            } // 스크롤 블록
            
            // MARK: - 하단 뷰
            SignUpBottomView(
                isNextButtonEnabled: true,
                loginLinkAction: { },
                nextButtonAction: { }
            )
            
        }
    }
}

// MARK: - Preview

#Preview("기본 - 빈 상태") {
    SignupView(
        store: .init(
            initialState: SignupFeature.State(),
            reducer: { SignupFeature() }
        )
    )
}

#Preview("아이디 중복") {
    SignupView(
        store: .init(
            initialState: {
                var state = SignupFeature.State()
                state.id = "ttokdog1"
                state.idCheckResult = .duplicate
                return state
            }(),
            reducer: { SignupFeature() }
        )
    )
}

#Preview("아이디 사용가능") {
    SignupView(
        store: .init(
            initialState: {
                var state = SignupFeature.State()
                state.id = "ttokdog1"
                state.idCheckResult = .available
                return state
            }(),
            reducer: { SignupFeature() }
        )
    )
}

#Preview("비밀번호 불일치") {
    SignupView(
        store: .init(
            initialState: {
                var state = SignupFeature.State()
                state.id = "ttokdog1"
                state.idCheckResult = .available
                state.password = "Test1234!"
                state.passwordConfirm = "Test5678!"
                return state
            }(),
            reducer: { SignupFeature() }
        )
    )
}

#Preview("전체 입력 완료") {
    SignupView(
        store: .init(
            initialState: {
                var state = SignupFeature.State()
                state.id = "ttokdog1"
                state.idCheckResult = .available
                state.password = "Test1234!"
                state.passwordConfirm = "Test1234!"
                state.email = "ttokdog@gmail.com"
                state.nickname = "똑독이"
                state.nicknameCheckResult = .available
                return state
            }(),
            reducer: { SignupFeature() }
        )
    )
}
