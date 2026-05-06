import SwiftUI
import SharedDesignSystem

// MARK: - Terms Agreement Row View
/// 약관동의 화면에서 개별 약관 항목을 표시하는 Row 컴포넌트
/// - 약관 이름(필수/선택 표시 포함)과 우측 보기 버튼으로 구성
struct TermsAgreementRowView: View {
    
    // MARK: - Properties
    let title: String
    let isChecked: Bool
    let onCheck: (Bool) -> Void
    let onDetailTapped: () -> Void
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 13) {
    
            Button(action: {
                onCheck(!isChecked)
            }, label: {
                Image.check
                    .renderingMode(.template)
                    .foregroundStyle(isChecked ? Color.primary500 : Color.gray300)
            })
            
            
            Text(title)
                .foregroundStyle(Color.gray500)
                .typographyText(.body8)
            
            Spacer()
            
            
            Button(action: {
                onDetailTapped()
            }, label: {
                Text("보기")
                    .foregroundStyle(Color.gray400)
                    .typographyText(.body11)
            })
        }
        
    }
    
}

// MARK: - Preview
#Preview("필수 - 미체크") {
    TermsAgreementRowView(
        title: "[필수] 이용약관",
        isChecked: false,
        onCheck: { _ in },
        onDetailTapped: { },
    )
    .padding(5)
}

#Preview("필수 - 체크") {
    TermsAgreementRowView(
        title: "[필수] 이용약관",
        isChecked: true,
        onCheck: { _ in },
        onDetailTapped: { },
    )
    .padding(5)
}

#Preview("선택 - 미체크") {
    TermsAgreementRowView(
        title: "[선택] 위치정보 이용 동의",
        isChecked: false,
        onCheck: { _ in },
        onDetailTapped: { },
    )
    .padding(5)
}

#Preview("선택 - 체크") {
    TermsAgreementRowView(
        title: "[선택] 위치정보 이용 동의",
        isChecked: true,
        onCheck: { _ in },
        onDetailTapped: { },
    )
    .padding(5)

}
