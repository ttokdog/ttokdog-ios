import SwiftUI
import SharedDesignSystem

// MARK: - SignUp Bottom View
/**
 회원가입 화면 하단 고정 액션 영역 컴포넌트
 
 - 주요 기능:
 - '이미 회원이신가요?' 로그인 전환 브릿지 제공
 - '다음으로' 메인 액션 버튼 제공
 **/
struct SignUpBottomView: View {
    
    let isNextButtonEnabled: Bool // 다음으로 버튼 활성화 여부
    let loginLinkAction: () -> Void // 로그인하러가기 버튼 탭 시 호출되는 클로저
    let nextButtonAction: () -> Void // 다음으로 버튼 탭 시 호출되는 클로저
    
    @State private var isKeyboardVisible = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // 이미 회원이신가요? 로그인하러가기
            if !isKeyboardVisible {
                HStack(spacing: 4) {
                    Text("이미 회원이신가요?")
                        .typographyText(.label3)
                        .foregroundStyle(Color.gray400)
                    
                    Button {
                        loginLinkAction()
                    } label: {
                        Text("로그인하러가기")
                            .typographyText(.label1)
                            .foregroundStyle(Color.primary500)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
            }
            
            // 다음으로 버튼 (활성화 여부에 따라 색상 변경)
            Button {
                nextButtonAction()
            } label: {
                Text("다음으로")
                    .typography(.buttonL)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(isNextButtonEnabled ? Color.primary500 : Color.gray300)
                    .foregroundStyle(isNextButtonEnabled ? Color.white : Color.gray400)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .disabled(!isNextButtonEnabled)
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            
        }
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -4)
        .mask(
            Rectangle()
                .padding(.top, -20) // 하단 그림자 잘라내기
        )
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
        
    }
}



// MARK: - Preview
#Preview("다음 버튼 - 활성화") {
    SignUpBottomView(isNextButtonEnabled: true, loginLinkAction: { }, nextButtonAction: { })
        
}

#Preview("다음 버튼 - 비활성화") {
    SignUpBottomView(isNextButtonEnabled: false, loginLinkAction: { }, nextButtonAction: { })
}
