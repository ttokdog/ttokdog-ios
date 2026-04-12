import ProjectDescription
import DependencyPlugin

public extension Target {
    static func app(
        module: ModulePath.App,
        deploymentTarget: ProjectDeploymentTarget,
        target: Target
    ) -> Self {
        var newTarget = target
        newTarget.name = ModulePath.App.name + module.rawValue

        switch module {
        case .iOS:
            newTarget.product = .app
            newTarget.name = Project.Environment.targetName(deploymentTarget: deploymentTarget)
            newTarget.productName = Project.Environment.targetName(deploymentTarget: deploymentTarget)
            newTarget.bundleId = Project.Environment.bundleId(deploymentTarget: deploymentTarget)
            newTarget.sources = .sources
            newTarget.resources = ["Resources/**"]
        }
        return newTarget
    }

    static func app(tests module: ModulePath.App, target: Target) -> Self {
        let deploymentTarget = ProjectDeploymentTarget.debug
        var newTarget = target
        newTarget.name = Project.Environment.appName + "-\(deploymentTarget.rawValue)-Tests"
        newTarget.product = .unitTests
        newTarget.productName = nil

        switch module {
        case .iOS:
            newTarget.destinations = .iOS
            newTarget.bundleId = "\(Project.Environment.bundlePrefix).\(deploymentTarget.rawValue).tests"
            newTarget.sources = .tests
        }

        return newTarget
    }
}
