import SwiftUI

/// 똑독 아이콘 시스템
///
/// Asset Catalog 기반. Tuist `resourceSynthesizers: [.assets()]`로 자동 생성된
/// `SharedDesignSystemAsset`을 `Image(asset:)` computed property로 감싸서 제공합니다.
///
/// > Note: Xcode 자동 생성 extension과의 충돌 방지를 위해
/// > `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = NO`로 설정되어 있습니다.
///
/// ## 사용법
/// ```swift
/// Image.eye
/// Image.google
/// ```

public extension Image {
    
    // MARK: - 공통 아이콘
    
    /// eye - 비밀번호 보기
    static var eye: Image { Image(asset: SharedDesignSystemAsset.eye) }
    /// eyeOff - 비밀번호 숨기기
    static var eyeOff: Image { Image(asset: SharedDesignSystemAsset.eyeOff) }
    /// back - 뒤로가기
    static var back: Image { Image(asset: SharedDesignSystemAsset.back) }
    /// close - 닫기
    static var close: Image { Image(asset: SharedDesignSystemAsset.inputErase) }
    
    
}

