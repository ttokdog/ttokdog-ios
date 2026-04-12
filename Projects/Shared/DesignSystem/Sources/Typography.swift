import SwiftUI

/// 똑독 Typography 시스템
///
/// Pretendard 폰트 기반. 각 스타일은 (자간, 행간 비율)을 포함합니다.
///
/// ## 폰트 등록
/// 앱 시작 시 `SharedDesignSystemFontFamily.registerAllCustomFonts()`를 호출하거나,
/// Tuist 생성 accessor를 통해 자동 등록됩니다.
///
/// ## 자간 (tracking)
/// 디자인 시안의 퍼센트 값을 SwiftUI tracking(pt)으로 변환:
/// ```
/// tracking = fontSize * (percent / 100)
/// 예: 36pt, -2% → 36 * -0.02 = -0.72pt
/// ```
///
/// ## 행간 (lineSpacing)
/// 디자인 시안의 퍼센트 값은 line-height 비율. SwiftUI lineSpacing은 기본 줄 높이에
/// 추가되는 여백이므로, 실제 UIFont의 lineHeight를 기준으로 계산합니다:
/// ```
/// targetLineHeight = fontSize * (percent / 100)
/// lineSpacing = targetLineHeight - UIFont.lineHeight
/// 예: 36pt, 140% → target 50.4 - UIFont.lineHeight(약 43) = 약 7.4pt
/// ```
///
/// ## 사용법
/// ```swift
/// Text("제목").typography(.display1)
/// Text("본문").typography(.body1)
/// ```
public enum Typography {
    // MARK: - Display

    /// Pretendard Bold 36 (-2%, 140%)
    case display1

    // MARK: - Head

    /// Pretendard Bold 32 (-2%, 140%)
    case head1
    /// Pretendard SemiBold 28 (-2%, 140%)
    case head2

    // MARK: - Title

    /// Pretendard SemiBold 24 (-2%, 140%)
    case title1
    /// Pretendard SemiBold 22 (-2%, 145%)
    case title2
    /// Pretendard SemiBold 20 (-2%, 150%)
    case title3
    /// Pretendard SemiBold 18 (-2%, 150%)
    case title4

    // MARK: - Body

    /// Pretendard Bold 18 (-2%, 150%)
    case body1
    /// Pretendard SemiBold 18 (-2%, 150%)
    case body2

    /// 폰트 (Tuist 생성 accessor 기반, 자동 등록 보장)
    public var font: Font {
        fontConvertible.swiftUIFont(size: fontSize)
    }

    /// 자간 (pt) — fontSize * (percent / 100)
    public var tracking: CGFloat {
        fontSize * -0.02
    }

    /// 행간 (pt) — targetLineHeight - UIFont 기본 lineHeight
    public var lineSpacing: CGFloat {
        let targetLineHeight = fontSize * lineHeightRatio
        let baseLineHeight = fontConvertible.font(size: fontSize).lineHeight
        return max(targetLineHeight - baseLineHeight, 0)
    }
}

// MARK: - Internal

private extension Typography {
    var fontConvertible: SharedDesignSystemFontConvertible {
        switch self {
        case .display1: SharedDesignSystemFontFamily.Pretendard.bold
        case .head1: SharedDesignSystemFontFamily.Pretendard.bold
        case .head2: SharedDesignSystemFontFamily.Pretendard.semiBold
        case .title1: SharedDesignSystemFontFamily.Pretendard.semiBold
        case .title2: SharedDesignSystemFontFamily.Pretendard.semiBold
        case .title3: SharedDesignSystemFontFamily.Pretendard.semiBold
        case .title4: SharedDesignSystemFontFamily.Pretendard.semiBold
        case .body1: SharedDesignSystemFontFamily.Pretendard.bold
        case .body2: SharedDesignSystemFontFamily.Pretendard.semiBold
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .display1: 36
        case .head1: 32
        case .head2: 28
        case .title1: 24
        case .title2: 22
        case .title3: 20
        case .title4: 18
        case .body1: 18
        case .body2: 18
        }
    }

    /// 행간 비율 (디자인 시안 기준)
    var lineHeightRatio: CGFloat {
        switch self {
        case .display1: 1.4
        case .head1: 1.4
        case .head2: 1.4
        case .title1: 1.4
        case .title2: 1.45
        case .title3: 1.5
        case .title4: 1.5
        case .body1: 1.5
        case .body2: 1.5
        }
    }
}

// MARK: - ViewModifier

public struct TypographyModifier: ViewModifier {
    let typography: Typography

    public func body(content: Content) -> some View {
        content
            .font(typography.font)
            .tracking(typography.tracking)
            .lineSpacing(typography.lineSpacing)
    }
}

public extension View {
    func typography(_ style: Typography) -> some View {
        modifier(TypographyModifier(typography: style))
    }
}
