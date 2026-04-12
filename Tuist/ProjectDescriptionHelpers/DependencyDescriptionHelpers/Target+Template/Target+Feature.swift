import ProjectDescription
import DependencyPlugin

public extension Target {
    static func feature(target: Target) -> Self {
        var newTarget = target
        newTarget.name = ModulePath.Feature.name
        return newTarget
    }

    static func feature(sources module: ModulePath.Feature, target: Target) -> Self {
        var newTarget = target
        newTarget.name = ModulePath.Feature.name + module.rawValue
        newTarget.sources = .sources
        return newTarget
    }

    static func feature(tests module: ModulePath.Feature, target: Target) -> Self {
        var newTarget = target
        newTarget.name = ModulePath.Feature.name + module.rawValue + "Tests"
        newTarget.product = .unitTests
        newTarget.sources = .tests
        return newTarget
    }

    static func feature(example module: ModulePath.Feature, target: Target) -> Self {
        var newTarget = target
        newTarget.name = ModulePath.Feature.name + module.rawValue + "Example"
        newTarget.sources = .exampleSources
        newTarget.product = .app
        newTarget.bundleId = "\(Project.Environment.bundleId(deploymentTarget: .debug))-\(module.rawValue)"
        newTarget.infoPlist = Project.Environment.appInfoPlist(deploymentTarget: .debug)
        newTarget.settings = Project.Environment.makeExampleSettings()
        return newTarget
    }
}
