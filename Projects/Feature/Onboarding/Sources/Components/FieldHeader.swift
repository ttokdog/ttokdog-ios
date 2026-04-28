import SwiftUI
import SharedDesignSystem

struct FieldHeader: View {

    let title: String
    var description: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .foregroundStyle(Color.gray700)
                .typography(.body9)
            
            if let description {
                Text(description)
                    .foregroundStyle(Color.gray500)
                    .typography(.body11)
            }
        }
    }
}

// MARK: - Preview
#Preview("설명 없음") {
    FieldHeader(title: "이메일")
        .padding(20)
}

#Preview("아이디") {
    FieldHeader(title: "아이디",
                description: "(6~15자 이내의 영문 소문자, 숫자 가능)")
        .padding(20)
}

#Preview("비밀번호") {
    FieldHeader(title: "비밀번호",
                description: "(8~20자 이내의 영문/숫자/특수문자 혼합)")
        .padding(20)
}

#Preview("닉네임") {
    FieldHeader(title: "닉네임",
                description: "(1~10자 이내의 한글/영문/숫자)")
        .padding(20)
}
