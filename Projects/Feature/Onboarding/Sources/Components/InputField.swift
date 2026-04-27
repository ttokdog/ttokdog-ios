import SwiftUI
import SharedDesignSystem

// MARK: - InputField

struct InputField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var isPasswordVisible: Bool = false
    var onToggleVisibility: (() -> Void)? = nil
    var keyboardType: UIKeyboardType = .default
    var hasError: Bool = false

    var body: some View {
        HStack {
            Group {
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                }
            }
            .typography(.body11)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

            if isSecure && !text.isEmpty {
                Button {
                    onToggleVisibility?()
                } label: {
                    (isPasswordVisible ? Image.eyeOn : Image.eyeOff)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.gray300)
                }
                .accessibilityLabel(isPasswordVisible ? "비밀번호 숨기기" : "비밀번호 보기")
            }

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image.inputErase
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(isSecure ? Color.gray400 : Color.gray300)
                }
                .accessibilityLabel("입력 내용 지우기")
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 52)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    hasError ? Color.error : Color.gray200,
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Preview

#Preview("기본") {
    InputField(
        placeholder: "example@example.com",
        text: .constant("")
    )
    .padding(.horizontal, 20)
}

#Preview("입력 중") {
    InputField(
        placeholder: "example@example.com",
        text: .constant("ttokdog@naver.com")
    )
    .padding(.horizontal, 20)
}

#Preview("에러") {
    InputField(
        placeholder: "example@example.com",
        text: .constant("ttokdog"),
        hasError: true
    )
    .padding(.horizontal, 20)
}

#Preview("비밀번호") {
    InputField(
        placeholder: "비밀번호를 입력해주세요",
        text: .constant("password123"),
        isSecure: true,
        isPasswordVisible: false,
        onToggleVisibility: {}
    )
    .padding(.horizontal, 20)
}
