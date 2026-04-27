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
/// Image.eyeOn
/// Image.google
/// ```

public extension Image {
    
    // MARK: - 공통 아이콘
    
    /// eyeOn - 비밀번호 보기
    static var eyeOn: Image { Image(asset: SharedDesignSystemAsset.eyeOn) }
    /// eyeOff - 비밀번호 숨기기
    static var eyeOff: Image { Image(asset: SharedDesignSystemAsset.eyeOff) }
    /// navigationBack - 네비게이션바 뒤로가기
    static var navigationBack: Image { Image(asset: SharedDesignSystemAsset.navigationBack) }
    /// inputErase - 텍스트 입력 지우기
    static var inputErase: Image { Image(asset: SharedDesignSystemAsset.inputErase) }

    // MARK: - 소셜 로그인 아이콘

    /// Google 로그인
    static var googleIcon: Image { Image(asset: SharedDesignSystemAsset.googleIcon) }
    /// Apple 로그인
    static var appleIcon: Image { Image(asset: SharedDesignSystemAsset.appleIcon) }
    /// Kakao 로그인
    static var kakaoIcon: Image { Image(asset: SharedDesignSystemAsset.kakaoIcon) }

}

