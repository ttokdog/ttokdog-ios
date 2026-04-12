import ProjectDescription

public extension Project {
    enum Environment {
        // MARK: - Metadata

        public static let appName: String = "Ttokdog"
        public static let bundlePrefix: String = "com.ttokdog"
        public static let currentAppVersion: String = "1.0.0"
        public static let organizationName: String = "ttokdog"

        // MARK: - Deployment

        public static let deploymentTarget: DeploymentTargets = .iOS("18.0")

        // MARK: - Target / Bundle Naming

        public static func targetName(deploymentTarget: ProjectDeploymentTarget) -> String {
            switch deploymentTarget {
            case .debug: "\(appName)-\(deploymentTarget.rawValue)"
            case .release: appName
            }
        }

        public static func bundleId(deploymentTarget: ProjectDeploymentTarget) -> String {
            switch deploymentTarget {
            case .debug: "\(bundlePrefix).\(deploymentTarget.rawValue)"
            case .release: "\(bundlePrefix).app"
            }
        }

        // MARK: - Settings

        public static let projectSettings: Settings = .settings(
            base: [
                "DEVELOPMENT_TEAM": .string("$(DEVELOPMENT_TEAM_ID)"),
                "CODE_SIGN_STYLE": "Automatic",
                "SWIFT_VERSION": "6.0",
                "OTHER_LDFLAGS": "$(inherited) -ObjC",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS": "YES",
                "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "NO",
                "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
            ],
            configurations: [
                .build(.debug),
                .build(.release),
            ],
            defaultSettings: .recommended
        )

        /// 타깃 레벨 설정.
        /// DEVELOPMENT_TEAM은 프로젝트에서 상속받도록 타깃에서는 설정하지 않는다.
        public static func makeSettings(
            deploymentTarget _: ProjectDeploymentTarget,
            enableDebugDylib: Bool = false
        ) -> Settings {
            var base: SettingsDictionary = [
                "SWIFT_VERSION": "6.0",
                "OTHER_LDFLAGS": "$(inherited) -ObjC",
                "CURRENT_PROJECT_VERSION": .string(currentAppVersion),
                "MARKETING_VERSION": .string(currentAppVersion),
                "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
            ]
            if enableDebugDylib {
                base["ENABLE_DEBUG_DYLIB"] = "YES"
            }
            return .settings(
                base: base,
                configurations: [
                    .build(.debug),
                    .build(.release),
                ],
                defaultSettings: .recommended
            )
        }

        public static func makeExampleSettings() -> Settings {
            makeSettings(deploymentTarget: .debug, enableDebugDylib: true)
        }
    }
}
