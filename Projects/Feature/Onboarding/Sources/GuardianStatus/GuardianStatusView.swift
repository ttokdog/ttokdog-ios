import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

// MARK: - Guardian Status View
/// 보호자 상태 선택하는 화면 View입니다.
struct GuardianStatusView: View {
    var body: some View {
        
        VStack(spacing: 44) {
            Text("똑독! 어떻게 시작할까요?")
                .typographyText(.title1)
                .foregroundStyle(Color.gray900)
            
            VStack(spacing: 14) {
                statusOptionButton(
                    title: "우리 아이를 키우고 있어요",
                    subTitle: "지금 바로 반려견을 등록하고\n관리할 수 있어요",
                    action: { }
                )
                
                statusOptionButton(
                    title: "아직 키우고 있지는 않아요",
                    subTitle: "부담 없이 둘러보며\n천천히 시작할 수 있어요",
                    action: { }
                )
            }
            
            Spacer()
            
            startButton
            
        }
        .padding(.top, 62)
        .padding(.horizontal, 20)
        
    }
    
    // MARK: - Status Option Button
    private func statusOptionButton(title: String,
                                    subTitle: String,
                                    action: @escaping () -> Void) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text(title)
               .typographyText(.body2)
               .foregroundStyle(Color.gray900)
            
            Text(subTitle)
               .typographyText(.body8)
               .foregroundStyle(Color.gray700)
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primary500.opacity(0.1))
        
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.primary500, lineWidth: 1.5)
        )
        
    }
    
    // MARK: - startButton
    private var startButton: some View {
        return Button(action: {
            // TODO: 가입 시작하기 기능구현하기
            
        }, label: {
            Text("이렇게 시작할게요")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Color.gray300)
                .foregroundStyle(Color.white)
                .typography(.buttonL)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        })
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
    }
    
}

// MARK: - Preview
#Preview {
    GuardianStatusView()
}
