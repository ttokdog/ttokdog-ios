import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToXCConfig(target: ProjectDeploymentTarget) -> Self {
        .relativeToRoot("xcconfigs/\(target.rawValue).xcconfig")
    }
}
