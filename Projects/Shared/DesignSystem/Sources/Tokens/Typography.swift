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

    /// Pretendard Bold 36 (-2%, 120%)
    case display1

    // MARK: - Head

    /// Pretendard Bold 32 (-2%, 120%)
    case head1
    /// Pretendard SemiBold 28 (-2%, 120%)
    case head2

    // MARK: - Title

    /// Pretendard SemiBold 24 (-2%, 130%)
    case title1
    /// Pretendard SemiBold 22 (-2%, 130%)
    case title2
    /// Pretendard SemiBold 20 (-2%, 130%)
    case title3
    /// Pretendard SemiBold 18 (-2%, 130%)
    case title4

    // MARK: - Body

    /// Pretendard Bold 18 (-2%, 140%)
    case body1
    /// Pretendard SemiBold 18 (-2%, 140%)
    case body2
    /// Pretendard Medium 18 (-2%, 140%)
    case body3
    /// Pretendard Regular 18 (-2%, 140%)
    case body4
    /// Pretendard Bold 16 (-2%, 140%)
    case body5
    /// Pretendard SemiBold 16 (-2%, 140%)
    case body6
    /// Pretendard Medium 16 (-2%, 140%)
    case body7
    /// Pretendard Regular 16 (-2%, 140%)
    case body8
    /// Pretendard SemiBold 14 (-2%, 145%)
    case body9
    /// Pretendard Medium 14 (-2%, 145%)
    case body10
    /// Pretendard Regular 14 (-2%, 145%)
    case body11

    // MARK: - Label

    /// Pretendard SemiBold 13 (-2%, 150%)
    case label1
    /// Pretendard Medium 13 (-2%, 150%)
    case label2
    /// Pretendard Regular 13 (-2%, 150%)
    case label3

    // MARK: - Caption

    /// Pretendard SemiBold 12 (-2%, 150%)
    case caption1
    /// Pretendard Medium 12 (-2%, 150%)
    case caption2
    /// Pretendard Regular 12 (-2%, 150%)
    case caption3

    // MARK: - Button

    /// Pretendard SemiBold 16 (-2%, 140%)
    case buttonL
    /// Pretendard SemiBold 14 (-2%, 145%)
    case buttonM

    // MARK: - Error

    /// Pretendard SemiBold 13 (-2%, 150%)
    case error

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
        case .body3: SharedDesignSystemFontFamily.Pretendard.medium
        case .body4: SharedDesignSystemFontFamily.Pretendard.regular
        case .body5: SharedDesignSystemFontFamily.Pretendard.bold
        case .body6: SharedDesignSystemFontFamily.Pretendard.semiBold
        case .body7: SharedDesignSystemFontFamily.Pretendard.medium
        case .body8: SharedDesignSystemFontFamily.Pretendard.regular
        case .body9: SharedDesignSystemFontFamily.Pretendard.semiBold
        case .body10: SharedDesignSystemFontFamily.Pretendard.medium
        case .body11: SharedDesignSystemFontFamily.Pretendard.regular

        case .label1: SharedDesignSystemFontFamily.Pretendard.semiBold
        case .label2: SharedDesignSystemFontFamily.Pretendard.medium
        case .label3: SharedDesignSystemFontFamily.Pretendard.regular

        case .caption1: SharedDesignSystemFontFamily.Pretendard.semiBold
        case .caption2: SharedDesignSystemFontFamily.Pretendard.medium
        case .caption3: SharedDesignSystemFontFamily.Pretendard.regular

        case .buttonL: SharedDesignSystemFontFamily.Pretendard.semiBold
        case .buttonM: SharedDesignSystemFontFamily.Pretendard.semiBold

        case .error: SharedDesignSystemFontFamily.Pretendard.semiBold
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
        case .body3: 18
        case .body4: 16
        case .body5: 16
        case .body6: 16
        case .body7: 14
        case .body8: 14
        case .body9: 14
        case .body10: 14
        case .body11: 14
            
        case .label1: 13
        case .label2: 13
        case .label3: 13
            
        case .caption1: 12
        case .caption2: 12
        case .caption3: 12
            
        case .buttonL: 16
        case .buttonM: 14
            
        case .error: 13
  
        }
    }

    /// 행간 비율 (디자인 시안 기준)
    var lineHeightRatio: CGFloat {
        switch self {
        case .display1: 1.2
            
        case .head1: 1.2
        case .head2: 1.2
            
        case .title1: 1.3
        case .title2: 1.3
        case .title3: 1.3
        case .title4: 1.5
            
        case .body1: 1.4
        case .body2: 1.4
        case .body3: 1.4
        case .body4: 1.4
        case .body5: 1.4
        case .body6: 1.4
        case .body7: 1.4
        case .body8: 1.4
        case .body9: 1.45
        case .body10: 1.45
        case .body11: 1.45
            
        case .label1: 1.5
        case .label2: 1.5
        case .label3: 1.5
            
        case .caption1: 1.5
        case .caption2: 1.5
        case .caption3: 1.5
            
        case .buttonL: 1.4
        case .buttonM: 1.45
            
        case .error: 1.5
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
