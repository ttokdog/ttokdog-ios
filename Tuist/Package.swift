// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
    baseSettings: .settings(
        configurations: [
            .build(.debug),
            .build(.release),
        ]
    )
)
#endif

let package = Package(
    name: "ttokdog",
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.17.0"
        ),
        .package(
            url: "https://github.com/kean/Nuke",
            from: "12.0.0"
        ),
        .package(
            url: "https://github.com/kakao/kakao-ios-sdk",
            from: "2.22.0"
        ),
        .package(
            url: "https://github.com/google/GoogleSignIn-iOS",
            from: "8.0.0"
        ),
    ]
)
