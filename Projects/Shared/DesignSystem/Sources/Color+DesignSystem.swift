import SwiftUI

// MARK: - Brand Colors

public extension Color {
    static var primary100: Color { Color(asset: SharedDesignSystemAsset.primary100) }
    static var primary500: Color { Color(asset: SharedDesignSystemAsset.primary500) }
    static var primary700: Color { Color(asset: SharedDesignSystemAsset.primary700) }
    static var secondary100: Color { Color(asset: SharedDesignSystemAsset.secondary100) }
    static var secondary500: Color { Color(asset: SharedDesignSystemAsset.secondary500) }
}

// MARK: - Neutral Grayscale

public extension Color {
    static var gray50: Color { Color(asset: SharedDesignSystemAsset.gray50) }
    static var gray100: Color { Color(asset: SharedDesignSystemAsset.gray100) }
}

// MARK: - Semantic System

public extension Color {
    static var success: Color { Color(asset: SharedDesignSystemAsset.success) }
    static var warning: Color { Color(asset: SharedDesignSystemAsset.warning) }
    static var error: Color { Color(asset: SharedDesignSystemAsset.error) }
}
