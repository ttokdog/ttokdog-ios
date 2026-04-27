import SwiftUI
import SharedDesignSystem

struct SignupPasswordInputField: View {
    @Binding var text: String
    
    let placeholder: String
    let isVisible: Bool
    let isError: Bool
    let onToggleVisibility: () -> Void
    let onClear: () -> Void
    
    var body: some View {
        
        HStack {
            Group {
                if isVisible {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
            }
            .foregroundStyle(text.isEmpty ? Color.gray400 : Color.gray900)
            .typography(.body11)
            
            
            if !text.isEmpty {
                HStack(spacing: 14) {
                    Button(action: onToggleVisibility) {
                        isVisible ? Image.eyeOff : Image.eye
                    }
                    
                    Button(action: onClear) {
                        Image.inputErase
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)
        .padding(.trailing, 14)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isError ? Color.error : Color.gray200, lineWidth: 1.2)
        )
        
    }
}
// MARK: - Preview
#Preview("비밀번호 - 비어있음") {
    SignupPasswordInputField(
        text: .constant(""),
        placeholder: "생성할 비밀번호를 입력해주세요",
        isVisible: false,
        isError: false,
        onToggleVisibility: { },
        onClear: { }
    )
    .padding()
}

#Preview("비밀번호 - 입력중 숨김") {
    SignupPasswordInputField(
        text: .constant("dbwldhks"),
        placeholder: "생성할 비밀번호를 입력해주세요",
        isVisible: false,
        isError: false,
        onToggleVisibility: { },
        onClear: { }
    )
    .padding()
}

#Preview("비밀번호 - 입력중 보임") {
    SignupPasswordInputField(
        text: .constant("dbwldhks"),
        placeholder: "생성할 비밀번호를 입력해주세요",
        isVisible: true,
        isError: false,
        onToggleVisibility: { },
        onClear: { }
    )
    .padding()
}

#Preview("비밀번호 확인 - 숨김") {
    SignupPasswordInputField(
        text: .constant("dbwldhks"),
        placeholder: "비밀번호를 한번 더 입력해주세요",
        isVisible: false,
        isError: false,
        onToggleVisibility: { },
        onClear: { }
    )
    .padding()
}

#Preview("비밀번호 확인 - 보임") {
    SignupPasswordInputField(
        text: .constant("dbwldhks"),
        placeholder: "비밀번호를 한번 더 입력해주세요",
        isVisible: true,
        isError: false,
        onToggleVisibility: { },
        onClear: { }
    )
    .padding()
}

#Preview("비밀번호 - 에러") {
    SignupPasswordInputField(
        text: .constant("dbwldhks"),
        placeholder: "생성할 비밀번호를 입력해주세요",
        isVisible: false,
        isError: true,
        onToggleVisibility: { },
        onClear: { }
    )
    .padding()
}

#Preview("비밀번호 확인 - 에러") {
    SignupPasswordInputField(
        text: .constant("dbwldhks"),
        placeholder: "비밀번호를 한번 더 입력해주세요",
        isVisible: false,
        isError: true,
        onToggleVisibility: { },
        onClear: { }
    )
    .padding()
}
