import SwiftUI
import SharedDesignSystem


struct TtokdogTextField: View {
    
    @Binding var text: String
    
    let placeholder: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 14) {
                textFieldView
                duplicateCheckButton()
            }
            .padding(.vertical, 7)
            .padding(.leading, 16)
            .padding(.trailing, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray200, lineWidth: 1.2)
            )
            // TODO: 에러 문구
            
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
            text = ""
        } label: {
            // TODO: 아이콘 디자인시스템 반영하기
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.gray)
        }
    }
    
    // MARK: - 중복확인 버튼
    private func duplicateCheckButton() -> some View {
        Button {

        } label: {
            Text("중복확인")
                .foregroundStyle(Color.gray400)
                .typography(.label1)
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.gray300, lineWidth: 1.2)
                )
        }
    }
    
}




// MARK: - Preview
#Preview {
    TtokdogTextField(
        text: .constant("dsdsdsdsds"),
        placeholder: "플레이스홀더"
    )
}
