import SwiftUI

// MARK: - CustomAlert

public struct CustomAlert<Content: View>: View {
    private let title: String
    private let description: String?
    private let content: Content
    private let primaryButtonTitle: String
    private let primaryAction: () -> Void
    private let secondaryButtonTitle: String?
    private let secondaryAction: (() -> Void)?

    public init(
        title: String,
        description: String? = nil,
        primaryButtonTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryButtonTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil
    ) where Content == EmptyView {
        self.title = title
        self.description = description
        self.content = EmptyView()
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryAction = secondaryAction
    }

    public init(
        title: String,
        description: String? = nil,
        primaryButtonTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryButtonTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.description = description
        self.content = content()
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: 8) {
                Text(title)
                    .typography(.title3)
                    .foregroundStyle(Color.gray900)
                    .multilineTextAlignment(.center)

                if let description {
                    Text(description)
                        .typography(.body8)
                        .foregroundStyle(Color.gray500)
                        .multilineTextAlignment(.center)
                }

                content

                buttonArea
                    .padding(.top, 8)
            }
            .padding(24)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private var buttonArea: some View {
        if let secondaryButtonTitle, let secondaryAction {
            HStack(spacing: 8) {
                Button(action: secondaryAction) {
                    Text(secondaryButtonTitle)
                        .typography(.buttonL)
                        .foregroundStyle(Color.gray600)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.gray100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button(action: primaryAction) {
                    Text(primaryButtonTitle)
                        .typography(.buttonL)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.primary500)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        } else {
            Button(action: primaryAction) {
                Text(primaryButtonTitle)
                    .typography(.buttonL)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.primary500)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

// MARK: - Preview

#Preview("단일 버튼") {
    CustomAlert(
        title: "이메일로 임시 비밀번호를 보냈어요.",
        description: "발급된 임시 비밀번호로 로그인 후,\n반드시 새 비밀번호로 변경해주세요.",
        primaryButtonTitle: "로그인 하러가기",
        primaryAction: {}
    )
}

#Preview("2버튼") {
    CustomAlert(
        title: "우리 아이 수정을 그만할까요?",
        description: "이전 화면으로 돌아가면\n수정된 내용은 저장되지 않아요.",
        primaryButtonTitle: "이어서 할래요",
        primaryAction: {},
        secondaryButtonTitle: "나갈래요",
        secondaryAction: {}
    )
}

#Preview("타이틀만") {
    CustomAlert(
        title: "인증번호 재발송횟수(5회)를 초과했어요.\n24시간 뒤에 다시 시도하세요.",
        primaryButtonTitle: "넘어가기",
        primaryAction: {}
    )
}

#Preview("커스텀 콘텐츠") {
    CustomAlert(
        title: "이메일로 가입하신 아이디를 보냈어요.",
        description: "개인정보 보호를 위해 화면에는 일부만 표시해요.\n메일함에서 전체 아이디를 확인해주세요.",
        primaryButtonTitle: "로그인 하러가기",
        primaryAction: {}
    ) {
        Text("( 아이디 : tto*** )")
            .typography(.body6)
            .foregroundStyle(Color.primary500)
    }
}
