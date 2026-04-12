import ProjectDescription

public extension Scheme {
    static func make(
        _ deploymentTarget: ProjectDeploymentTarget,
        name appName: String
    ) -> Self {
        let schemeName: String = switch deploymentTarget {
        case .debug: "\(appName)-\(deploymentTarget.rawValue)"
        case .release: appName
        }

        return .scheme(
            name: schemeName,
            shared: true,
            buildAction: .buildAction(targets: [.target(schemeName)]),
            runAction: .runAction(
                configuration: deploymentTarget.configurationName,
                executable: .target(schemeName)
            ),
            archiveAction: .archiveAction(configuration: deploymentTarget.configurationName),
            profileAction: .profileAction(configuration: deploymentTarget.configurationName),
            analyzeAction: .analyzeAction(configuration: deploymentTarget.configurationName)
        )
    }
}
