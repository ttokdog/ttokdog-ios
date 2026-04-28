import SwiftUI
import ComposableArchitecture

struct SignupView: View {
    
    @Bindable public var store: StoreOf<SignupFeature>

    public init(store: StoreOf<SignupFeature>) {
        self.store = store
    }
    
    // MARK: - Body
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                // MARK: - 아이디
                TtokdogTextField(text: $store.id,
                                 title: "아이디",
                                 description: "(6~15자 이내의 영문 소문자, 숫자 사용 가능)",
                                 placeholder: "생성할 아이디를 입력해주세요")
                
                
                // MARK: - 비밀번호
                VStack(alignment: .leading, spacing: 6) {
                    // TODO: 중복사용이 많아서 컴포넌트 분리하기
                    VStack(alignment: .leading, spacing: 2) {
                        Text("비밀번호")
                            .foregroundStyle(Color.gray700)
                            .typography(.body9)
                        Text("8~20자 이내의 영문/숫자/특수문자 혼합")
                            .foregroundStyle(Color.gray500)
                            .typography(.body11)
                    }
                    
                    VStack(spacing: 6) {
                        SignupPasswordInputField(text: $store.password,
                                                 placeholder: "생성할 비밀번호를 입력해주세요",
                                                 isVisible: store.isPasswordValid,
                                                 isError: false,
                                                 onToggleVisibility: { },
                                                 onClear: { })
                        
                        SignupPasswordInputField(text: $store.passwordConfirm,
                                                 placeholder: "비밀번호를 한번 더 입력해주세요",
                                                 isVisible: store.isPasswordConfirmVisible,
                                                 isError: false,
                                                 onToggleVisibility: { },
                                                 onClear: { })
                    }
                }
                
                // MARK: - 이메일
                VStack {
                    Text("이메일")
                        .foregroundStyle(Color.gray700)
                        .typography(.body9)
                    HStack {
                        
                    }
                    
                }
                
                // MARK: - 닉네임
                

            }
            .padding(20)
            
        } // 스크롤 블록
    }
}

// MARK: - Preview
#Preview {
    SignupView(
        store: .init(
            initialState: SignupFeature.State(),
            reducer: { SignupFeature() }
        )
    )
}
