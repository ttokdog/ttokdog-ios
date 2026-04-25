import SwiftUI
import SharedDesignSystem

// MARK: - ErrorLabel

struct ErrorLabel: View {
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Image(systemName: "info.circle")
                .font(.system(size: 14))
                .foregroundStyle(Color.error)

            Text(message)
                .typography(.error)
                .foregroundStyle(Color.error)
        }
    }
}

// MARK: - Preview

#Preview {
    ErrorLabel(message: "올바른 이메일 형식을 입력해주세요.")
        .padding(.horizontal, 20)
}
