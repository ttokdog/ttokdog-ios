import ProjectDescription

public extension Project.Environment {
    static func appInfoPlist(deploymentTarget: ProjectDeploymentTarget) -> InfoPlist {
        .extendingDefault(with: [
            "CFBundleDisplayName": "똑독",
            "CFBundleShortVersionString": .string(currentAppVersion),
            "CFBundleVersion": .string(currentAppVersion),
            "UILaunchScreen": [
                "UIColorName": "",
                "UIImageName": "",
            ],
            "UISupportedInterfaceOrientations": [
                "UIInterfaceOrientationPortrait",
            ],
            "ITSAppUsesNonExemptEncryption": false,
        ])
    }

    static func testAppInfoPlist() -> InfoPlist {
        .extendingDefault(with: [
            "CFBundleDisplayName": "똑독-Tests",
        ])
    }
}
