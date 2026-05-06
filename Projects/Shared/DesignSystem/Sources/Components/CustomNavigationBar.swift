import SwiftUI

public struct CustomNavigationBar: View {
    private let title: String?
    private let onBack: (() -> Void)?
    private let trailing: TrailingItem?

    public struct TrailingItem {
        let icon: Image
        let action: () -> Void

        public init(icon: Image, action: @escaping () -> Void) {
            self.icon = icon
            self.action = action
        }
    }

    public init(
        title: String? = nil,
        onBack: (() -> Void)? = nil,
        trailing: TrailingItem? = nil
    ) {
        self.title = title
        self.onBack = onBack
        self.trailing = trailing
    }

    public var body: some View {
        HStack(spacing: 0) {
            leadingView
            Spacer()
            titleView
            Spacer()
            trailingView
        }
        .frame(height: 50)
        .padding(.horizontal, 10)
    }

    @ViewBuilder
    private var leadingView: some View {
        if let onBack {
            Button(action: onBack) {
                Image.navigationBack
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .frame(width: 44, height: 44)
        } else {
            Color.clear
                .frame(width: 44, height: 44)
        }
    }

    @ViewBuilder
    private var titleView: some View {
        if let title {
            Text(title)
                .typography(.body6)
                .foregroundStyle(Color.gray800)
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private var trailingView: some View {
        if let trailing {
            Button(action: trailing.action) {
                trailing.icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .frame(width: 44, height: 44)
        } else {
            Color.clear
                .frame(width: 44, height: 44)
        }
    }
}

// MARK: - Preview

#Preview("타이틀 + 뒤로가기") {
    CustomNavigationBar(
        title: "설정",
        onBack: {}
    )
}

#Preview("전체 구성") {
    CustomNavigationBar(
        title: "프로필",
        onBack: {},
        trailing: .init(icon: .eyeOn, action: {})
    )
}

#Preview("타이틀만") {
    CustomNavigationBar(title: "홈")
}
