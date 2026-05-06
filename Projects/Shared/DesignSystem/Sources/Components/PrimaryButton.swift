import SwiftUI

/// 똑독 메인 CTA(Call To Action) 버튼.
///
/// 화면 하단의 주요 액션 버튼(예: "로그인", "다음으로", "인증 확인", "똑독 시작하기")에 일관되게 사용한다.
/// - 활성 상태: `primary500` 배경 + `white` 텍스트
/// - 비활성 상태: `gray300` 배경 + `gray400` 텍스트 + 탭 비활성화
///
/// ## 사용법
/// ```swift
/// PrimaryButton(title: "다음으로", isEnabled: state.isValid) {
///     store.send(.nextTapped)
/// }
///
/// // 높이/코너 반경을 조정해야 하는 경우
/// PrimaryButton(title: "똑독 시작하기", height: 70) { ... }
/// ```
public struct PrimaryButton: View {
    private let title: String
    private let isEnabled: Bool
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let action: () -> Void

    public init(
        title: String,
        isEnabled: Bool = true,
        height: CGFloat = 60,
        cornerRadius: CGFloat = 15,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.height = height
        self.cornerRadius = cornerRadius
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .typography(.buttonL)
                .foregroundStyle(isEnabled ? Color.white : Color.gray400)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(isEnabled ? Color.primary500 : Color.gray300)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .disabled(!isEnabled)
    }
}

// MARK: - Preview

#Preview("활성 - 기본 (60)") {
    PrimaryButton(title: "다음으로") {}
        .padding(20)
}

#Preview("비활성 - 기본 (60)") {
    PrimaryButton(title: "다음으로", isEnabled: false) {}
        .padding(20)
}

#Preview("활성 - 큰 사이즈 (70)") {
    PrimaryButton(title: "똑독 시작하기", height: 70) {}
        .padding(20)
}

#Preview("활성 - 작은 사이즈 (54, cornerRadius 12)") {
    PrimaryButton(title: "확인", height: 54, cornerRadius: 12) {}
        .padding(20)
}
