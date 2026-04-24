import SwiftUI

/// 똑독 컬러 시스템
///
/// Asset Catalog 기반. Tuist `resourceSynthesizers: [.assets()]`로 자동 생성된
/// `SharedDesignSystemAsset`을 `Color(asset:)` computed property로 감싸서 제공합니다.
///
/// > Note: Xcode 자동 생성 extension과의 충돌 방지를 위해
/// > `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = NO`로 설정되어 있습니다.
///
/// ## 사용법
/// ```swift
/// Text("제목").foregroundStyle(.primary500)
/// Circle().fill(.secondary500)
/// ```

// MARK: - Brand Colors

public extension Color {
    /// Primary 100 — 가장 연한 브랜드 컬러
    static var primary100: Color { Color(asset: SharedDesignSystemAsset.primary100) }
    /// Primary 500 — 메인 브랜드 컬러
    static var primary500: Color { Color(asset: SharedDesignSystemAsset.primary500) }
    /// Primary 700 — 진한 브랜드 컬러
    static var primary700: Color { Color(asset: SharedDesignSystemAsset.primary700) }
    /// Secondary 100 — 가장 연한 보조 컬러
    static var secondary100: Color { Color(asset: SharedDesignSystemAsset.secondary100) }
    /// Secondary 500 — 메인 보조 컬러
    static var secondary500: Color { Color(asset: SharedDesignSystemAsset.secondary500) }
}

// MARK: - Neutral Grayscale

public extension Color {
    /// Gray 50 — 가장 연한 회색 (배경용)
    static var gray50: Color { Color(asset: SharedDesignSystemAsset.gray50) }
    /// Gray 100 — 연한 회색 (구분선, 보조 배경)
    static var gray100: Color { Color(asset: SharedDesignSystemAsset.gray100) }
    /// Gray 200 —
    static var gray200: Color { Color(asset: SharedDesignSystemAsset.gray200) }
    /// Gray 300 —
    static var gray300: Color { Color(asset: SharedDesignSystemAsset.gray300) }
    /// Gray 400 — Disabled button (비활성화된 버튼)
    static var gray400: Color { Color(asset: SharedDesignSystemAsset.gray400) }
    /// Gray 500 —
    static var gray500: Color { Color(asset: SharedDesignSystemAsset.gray500) }
    /// Gray 600 —
    static var gray600: Color { Color(asset: SharedDesignSystemAsset.gray600) }
    /// Gray 700 — Sub text (보조 텍스트 컬러)
    static var gray700: Color { Color(asset: SharedDesignSystemAsset.gray700) }
    /// Gray 800 —
    static var gray800: Color { Color(asset: SharedDesignSystemAsset.gray800) }
    /// Gray 900 — 가장 진한 회색  (메인, CTA 텍스트 컬러)
    static var gray900: Color { Color(asset: SharedDesignSystemAsset.gray900) }
}

// MARK: - Semantic System

public extension Color {
    /// 성공 상태 표시
    static var success: Color { Color(asset: SharedDesignSystemAsset.success) }
    /// 경고 상태 표시
    static var warning: Color { Color(asset: SharedDesignSystemAsset.warning) }
    /// 에러 상태 표시
    static var error: Color { Color(asset: SharedDesignSystemAsset.error) }
}
