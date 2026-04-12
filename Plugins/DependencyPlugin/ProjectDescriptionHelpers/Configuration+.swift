import ProjectDescription

public extension Configuration {
    static func build(_ deploymentTarget: ProjectDeploymentTarget) -> Self {
        switch deploymentTarget {
        case .debug:
            return .debug(
                name: deploymentTarget.configurationName,
                xcconfig: .relativeToXCConfig(target: deploymentTarget)
            )
        case .release:
            return .release(
                name: deploymentTarget.configurationName,
                xcconfig: .relativeToXCConfig(target: deploymentTarget)
            )
        }
    }
}
