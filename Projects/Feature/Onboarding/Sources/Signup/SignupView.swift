import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

public struct SignupView: View {
    
    @Bindable public var store: StoreOf<SignupFeature>

    public init(store: StoreOf<SignupFeature>) {
        self.store = store
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "회원가입", onBack: { })
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // MARK: - 아이디
                    VStack(alignment: .leading, spacing: 10) {
                        FieldHeader(title: "아이디", description: "(6~15자 이내의 영문 소문자, 숫자 사용 가능)")
                        
                        DuplicateCheckInputField(
                            text: $store.id,
                            minimumLength: 6,
                            placeholder: "생성할 아이디를 입력해주세요",
                            checkResult: store.idCheckResult,
                            errorMessage: "중복된 아이디입니다.",
                            successMessage: "사용이 가능한 아이디입니다",
                            onClear: { store.send(.clearIdTapped)},
                            onDuplicateCheck: { store.send(.checkDuplicateIdTapped) }
                        )
                        .keyboardType(.asciiCapable)
                        
                        
                    }
                    
                    // MARK: - 비밀번호
                    VStack(alignment: .leading, spacing: 10) {
                        FieldHeader(title: "비밀번호", description: "(8~20자 이내의 영문/숫자/특수문자 혼합)")
                        
                        VStack(alignment: .leading, spacing: 6) {
                            SignupPasswordInputField(
                                text: $store.password,
                                placeholder: "생성할 비밀번호를 입력해주세요",
                                isVisible: store.isPasswordVisible,
                                isError: store.isPasswordInvalid ,
                                onToggleVisibility: { store.send(.togglePasswordVisibility) },
                                onClear: { store.send(.clearPasswordTapped) }
                            )
                            .keyboardType(.asciiCapable)
                            
                            SignupPasswordInputField(
                                text: $store.passwordConfirm,
                                placeholder: "비밀번호를 한번 더 입력해주세요",
                                isVisible: store.isPasswordConfirmVisible,
                                isError: store.isPasswordConfirmMismatch,
                                onToggleVisibility: { store.send(.togglePasswordConfirmVisibility) },
                                onClear: { store.send(.clearPasswordConfirmTapped) }
                            )
                            .keyboardType(.asciiCapable)
                            
        
                            if !store.password.isEmpty && !store.isPasswordLengthValid {
                                InlineValidationMessage(message: "비밀번호는 8자 이상이어야 해요.", type: .error)
                            }
                            
                            
                            if !store.password.isEmpty && (!store.isPasswordContainsLetter || !store.isPasswordContainsNumber || !store.isPasswordContainsSpecialChar) {
                                InlineValidationMessage(message: "비밀번호는 반드시 영문/숫자/특수문자를 포함해야 해요.", type: .error)
                            }
                            
                            
                            if store.isPasswordConfirmMismatch {
                                InlineValidationMessage(message: "비밀번호가 일치하지 않아요. 다시 확인해주세요.", type: .error)
                            }

                        }
                    }
                    
                    // MARK: - 이메일
                    VStack(alignment: .leading, spacing: 10) {
                        FieldHeader(title: "이메일")

                        PlainInputField(
                            text: $store.email,
                            placeholder: "example@example.com",
                            isError: !store.email.isEmpty && !store.isEmailValid,
                            onClear: { store.send(.clearEmailTapped) }
                        )
                        .keyboardType(.asciiCapable)
                        
                        // TODO: 에러 문구
                        if !store.isEmailValid && !store.email.isEmpty {
                            InlineValidationMessage(message: "올바른 이메일 형식을 입력해주세요.", type: .error)
                        }
                        
                    }
                    
                    // MARK: - 닉네임
                    VStack(alignment: .leading, spacing: 10) {
                        FieldHeader(title: "닉네임", description: "(1~10자 이내의 한글/영문/숫자)")
                        
                        DuplicateCheckInputField(
                            text: $store.nickname,
                            minimumLength: 1,
                            placeholder: "사용할 닉네임을 입력하세요",
                            checkResult: store.nicknameCheckResult,
                            errorMessage: "중복된 닉네임입니다.",
                            successMessage: "사용이 가능한 닉네임입니다",
                            onClear: { store.send(.clearNicknameTapped)},
                            onDuplicateCheck: { store.send(.checkDuplicateNicknameTapped) }
                        )
                        
                    }
                    
                }
                .padding(20)
                
            } // 스크롤 블록
            
            // MARK: - 하단 뷰
            SignUpBottomView(
                isNextButtonEnabled: store.isSignUpEnabled,
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

#Preview("아이디 입력 상태") {
    SignupView(
        store: .init(
            initialState: {
                var state = SignupFeature.State()
                state.id = "dogdogdog"
                return state
            }(),
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


#Preview("비밀번호 조건 불충족") {
    SignupView(
        store: .init(
            initialState: {
                var state = SignupFeature.State()
                state.id = "ttokdog1"
                state.idCheckResult = .available
                state.password = "test12" // 8자 미만 + 특수문자 없음
                state.passwordConfirm = "test12"
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
                state.password = "Test1234!!"
                state.passwordConfirm = "Test1234!!"
                state.email = "ttokdog@gmail.com"
                state.nickname = "똑독이"
                state.nicknameCheckResult = .available
                return state
            }(),
            reducer: { SignupFeature() }
        )
    )
}

