import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

// MARK: - Guardian Status View
/// 보호자 상태 선택하는 화면 View입니다.
public struct GuardianStatusView: View {
    
    @Bindable public var store: StoreOf<GuardianStatusFeature>
    
    // MARK: - Init
    public init(store: StoreOf<GuardianStatusFeature>) {
        self.store = store
    }
    
    // MARK: - Body
    public var body: some View {
        
        VStack(spacing: 44) {
            Text("똑독! 어떻게 시작할까요?")
                .typographyText(.title1)
                .foregroundStyle(Color.gray900)
            
            VStack(spacing: 14) {
                statusOptionButton(
                    title: "우리 아이를 키우고 있어요",
                    subTitle: "지금 바로 반려견을 등록하고\n관리할 수 있어요",
                    isSelected: store.selectedStatus == .hasPet,
                    action: { store.send(.statusOptionTapped(.hasPet)) }
                )
                
                statusOptionButton(
                    title: "아직 키우고 있지는 않아요",
                    subTitle: "부담 없이 둘러보며\n천천히 시작할 수 있어요",
                    isSelected: store.selectedStatus == .noPet,
                    action: { store.send(.statusOptionTapped(.noPet)) }
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
                                    isSelected: Bool,
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
        .background(isSelected ? Color.primary500.opacity(0.1) :  Color.gray200.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.primary500 : Color.clear, lineWidth: 1.5)
        )
        .onTapGesture {
            action()
        }
        
        
    }
    
    // MARK: - startButton
    private var startButton: some View {
        return Button(action: {
            store.send(.startButtonTapped)
        }, label: {
            Text("이렇게 시작할게요")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(store.isStartButtonEnabled ? Color.primary500 : Color.gray300)
                .foregroundStyle(Color.white)
                .typography(.buttonL)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        })
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
        .disabled(store.selectedStatus == nil)
    }
    
}

// MARK: - Preview
#Preview("기본 - 미선택") {
    GuardianStatusView(
        store: .init(
            initialState: GuardianStatusFeature.State(),
            reducer: { GuardianStatusFeature() }
        )
    )
}

#Preview("우리 아이를 키우고 있어요 선택") {
    GuardianStatusView(
        store: .init(
            initialState: {
                var state = GuardianStatusFeature.State()
                state.selectedStatus = .hasPet
                return state
            }(),
            reducer: { GuardianStatusFeature() }
        )
    )
}

#Preview("아직 키우고 있지는 않아요 선택") {
    GuardianStatusView(
        store: .init(
            initialState: {
                var state = GuardianStatusFeature.State()
                state.selectedStatus = .noPet
                return state
            }(),
            reducer: { GuardianStatusFeature() }
        )
    )
}
