import SwiftUI

// TODO: 그라데이션 추가 시 여기에 등록
public extension LinearGradient {
    /// TTOKDOG Gradient 01 — 135deg, Secondary500 → Primary500
    static let gradient01 = LinearGradient(
        colors: [.secondary500, .primary500],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
