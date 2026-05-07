import SwiftUI
import SharedDesignSystem

/// 6자리 숫자 인증번호 입력 컴포넌트.
///
/// 화면에는 6개의 분리된 박스가 보이지만, 실제 입력 영역은 위에 깔린 투명한 단일
/// `TextField`. iOS 시스템 키패드와 SMS 자동완성(`textContentType(.oneTimeCode)`)을 그대로 활용한다.
public struct VerificationCodeInputField: View {

    @Binding private var text: String
    private let isError: Bool

    @FocusState private var isFocused: Bool
    /// 박스에 실제로 노출되는 글자 수.
    /// 일괄 채움(자동완성/붙여넣기) 시 `text.count` 보다 작을 수 있으며 한 글자씩 증가하여 따라잡는다.
    @State private var displayedLength: Int = 0

    /// 입력 자릿수 (현재 화면에서는 상수 6)
    private let length: Int = 6

    /// 한 글자 채움 사이 간격
    private let staggerDelay: Duration = .milliseconds(60)

    public init(text: Binding<String>, isError: Bool) {
        self._text = text
        self.isError = isError
    }

    public var body: some View {
        ZStack {
            // 박스 6개 — 표시 전용
            HStack(spacing: 8) {
                ForEach(0..<length, id: \.self) { index in
                    box(at: index)
                }
            }

            // 실제 입력 영역 — 투명 TextField
            // 자동 포커스는 다른 온보딩 화면과의 일관성을 위해 두지 않음.
            // 사용자가 박스를 탭하면 first responder가 되어 키보드가 올라온다.
            TextField("", text: $text)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .tint(.clear)              // 캐럿 숨김
                .foregroundStyle(.clear)   // 입력 텍스트 숨김 (박스가 그림)
                .focused($isFocused)
                .onChange(of: text) { oldValue, newValue in
                    // SMS 자동완성이 6자리 초과/숫자 외 문자를 삽입할 수 있어 View 단 방어 정제.
                    // Reducer 측 binding(\.code) 정제와 이중 가드.
                    let filtered = String(newValue.filter(\.isNumber).prefix(length))
                    if text != filtered {
                        text = filtered
                        return  // 정제 후 다시 onChange가 들어오니 이번 이벤트는 종료
                    }

                    // 노출 길이 갱신 — 한 번에 2글자 이상 늘면 자동완성/붙여넣기로 보고 한 글자씩 채움.
                    let oldCount = oldValue.count
                    let newCount = filtered.count
                    if newCount > oldCount + 1 {
                        animateStaggeredFill(from: oldCount, to: newCount)
                    } else {
                        displayedLength = newCount
                    }
                }
        }
        // 입력값 변화 시 박스 fill/border/lineWidth가 부드럽게 전환 (자동완성 일괄 채움 시에도 동일).
        .animation(.easeInOut(duration: 0.15), value: text)
        .animation(.easeInOut(duration: 0.15), value: isError)
    }

    @ViewBuilder
    private func box(at index: Int) -> some View {
        let isCurrent = index == displayedLength && isFocused && !isError
        let character = character(at: index)
        let filled = !character.isEmpty

        Text(character)
            .typography(.head2)
            .foregroundStyle(textColor(filled: filled))
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(fillColor(filled: filled))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        borderColor(isCurrent: isCurrent, filled: filled),
                        lineWidth: borderLineWidth(isCurrent: isCurrent)
                    )
            )
    }

    private func character(at index: Int) -> String {
        // 자동완성 staggered 채움 중에는 displayedLength까지만 노출.
        guard index < min(text.count, displayedLength) else { return "" }
        return String(text[text.index(text.startIndex, offsetBy: index)])
    }

    /// 일괄 채움 시 `from` → `to` 까지 한 글자씩 단계적으로 노출.
    @MainActor
    private func animateStaggeredFill(from start: Int, to end: Int) {
        displayedLength = start
        Task { @MainActor in
            for i in 1...(end - start) {
                try? await Task.sleep(for: staggerDelay)
                // 도중에 다른 이벤트로 길이가 다시 줄거나 텍스트가 비워졌으면 중단
                guard text.count >= start + i else { return }
                displayedLength = start + i
            }
        }
    }

    /// 박스 안 숫자 색상 — 입력된 칸은 메인 컬러, 에러 시 에러 색.
    private func textColor(filled: Bool) -> Color {
        if isError { return .error }
        if filled { return .primary500 }
        return .gray900
    }

    private func fillColor(filled: Bool) -> Color {
        if isError { return Color.error.opacity(0.08) }
        return filled ? Color.primary100 : Color.white
    }

    /// 박스 테두리 — 에러 또는 입력 완료 칸은 테두리 없음, 현재 입력 위치만 메인 컬러 강조.
    private func borderColor(isCurrent: Bool, filled: Bool) -> Color {
        if isError || filled { return .clear }
        if isCurrent { return .primary500 }
        return .gray200
    }

    /// 박스 테두리 두께 — 현재 입력해야 하는 칸만 2pt, 그 외는 1.2pt.
    private func borderLineWidth(isCurrent: Bool) -> CGFloat {
        isCurrent ? 2 : 1.2
    }
}

// MARK: - Preview

#Preview("빈 상태") {
    StatefulPreview(initial: "") { binding in
        VerificationCodeInputField(text: binding, isError: false)
            .padding()
    }
}

#Preview("2자 입력") {
    StatefulPreview(initial: "22") { binding in
        VerificationCodeInputField(text: binding, isError: false)
            .padding()
    }
}

#Preview("에러 상태") {
    StatefulPreview(initial: "225485") { binding in
        VerificationCodeInputField(text: binding, isError: true)
            .padding()
    }
}

/// Preview에서 @Binding을 다루기 위한 작은 헬퍼.
private struct StatefulPreview<Content: View>: View {
    @State private var value: String
    let content: (Binding<String>) -> Content

    init(initial: String, @ViewBuilder content: @escaping (Binding<String>) -> Content) {
        self._value = State(initialValue: initial)
        self.content = content
    }

    var body: some View { content($value) }
}
