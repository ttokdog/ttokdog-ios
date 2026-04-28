import SwiftUI
import SharedDesignSystem

/// 중복체크 결과 상태
enum DuplicateCheckResult {
    case available // 사용가능
    case duplicate // 중복
}

// MARK: - DuplicateCheckInputField
/// 중복확인 버튼이 포함된 텍스트 필드 컴포넌트
/// 아이디, 닉네임 중복확인에 사용
struct DuplicateCheckInputField: View {
    
    @Binding var text: String
    var minimumLength: Int
    let placeholder: String
    let checkResult: DuplicateCheckResult?
    let errorMessage: String
    let successMessage: String
    let onClear: () -> Void
    let onDuplicateCheck: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 14) {
                textFieldView
                duplicateCheckButton
            }
            .padding(.vertical, 7)
            .padding(.leading, 16)
            .padding(.trailing, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1.2)
            )
            // 에러문구
            switch checkResult {
            case .available:
                InlineValidationMessage(message: successMessage, type: .success)
            case .duplicate:
                InlineValidationMessage(message: errorMessage, type: .error)
            case .none:
                EmptyView()
            }
        }
    }
    
    // MARK: - 보더 색상
    private var borderColor: Color {
        switch checkResult {
        case .duplicate: return Color.error
        case .available, .none: return Color.gray200
        }
    }
    
    // MARK: -  중복 버튼 색상
    private var buttonForegroundColor: Color {
        switch checkResult {
        case .duplicate: return Color.gray400  // 중복이면 그레이
//        case .none: return text.isEmpty ? Color.gray400 : Color.primary500
        case .none: return text.count >= minimumLength ? Color.primary500 : Color.gray400
        case .available: return Color.white
        }
    }

    private var buttonBorderColor: Color {
        switch checkResult {
        case .duplicate: return Color.gray300  // 중복이면 그레이
//        case .none: return text.isEmpty ? Color.gray300 : Color.primary500
        case .none: return text.count >= minimumLength ? Color.primary500 : Color.gray300
        case .available: return Color.primary500
        }
    }
    
    // MARK: - 텍스트 필드
    private var textFieldView: some View {
        HStack {
            TextField(placeholder, text: $text)
                .foregroundStyle(Color.gray900)
                .typography(.body11)
            
            if !text.isEmpty {
                clearButton
            }
            
        }
    }
    
    // MARK: - 지우기 버튼
    private var clearButton: some View {
        Button {
            onClear()
        } label: {
            Image.inputErase
        }
    }
    
    // MARK: - 중복확인 버튼
    private var duplicateCheckButton: some View {
        Button {
            onDuplicateCheck()
        } label: {
            if checkResult == .available {
                // TODO: 이미지 교체
                Image.check
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .background(Color.primary500)
                    .clipShape(Capsule())
            } else {
                Text("중복확인")
                    .foregroundStyle(buttonForegroundColor)
                    .typography(.label1)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(buttonBorderColor, lineWidth: 1.2)
                    )
            }
        }
        .disabled(text.count < minimumLength || checkResult == .available) // 텍스트 비어있거나 이미 사용가능 확인된 경우 버튼 비활성화
    }
    
}


// MARK: - Preview
#Preview("미입력") {
    DuplicateCheckInputField(
        text: .constant(""),
        minimumLength: 6,
        placeholder: "생성할 아이디를 입력해주세요",
        checkResult: nil,
        errorMessage: "중복된 아이디입니다.",
        successMessage: "사용이 가능한 아이디입니다.",
        onClear: { },
        onDuplicateCheck: { }
    )
    .padding(20)
}

#Preview("입력중") {
    DuplicateCheckInputField(
        text: .constant("ttoㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ"),
        minimumLength: 6,
        placeholder: "생성할 아이디를 입력해주세요",
        checkResult: nil,
        errorMessage: "중복된 아이디입니다.",
        successMessage: "사용이 가능한 아이디입니다.",
        onClear: { },
        onDuplicateCheck: { }
    )
    .padding(20)
}

#Preview("중복") {
    DuplicateCheckInputField(
        text: .constant("dogdogdog"),
        minimumLength: 6,
        placeholder: "생성할 아이디를 입력해주세요",
        checkResult: .duplicate,
        errorMessage: "중복된 아이디입니다.",
        successMessage: "사용이 가능한 아이디입니다.",
        onClear: { },
        onDuplicateCheck: { }
    )
    .padding(20)
}

#Preview("사용가능") {
    DuplicateCheckInputField(
        text: .constant("ttokdog"),
        minimumLength: 6,
        placeholder: "생성할 아이디를 입력해주세요",
        checkResult: .available,
        errorMessage: "중복된 아이디입니다.",
        successMessage: "사용이 가능한 아이디입니다.",
        onClear: { },
        onDuplicateCheck: { }
    )
    .padding(20)
}



   
    

