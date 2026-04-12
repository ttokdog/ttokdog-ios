import ProjectDescription
import DependencyPlugin

public extension Target {
    static func shared(target: Target) -> Self {
        var newTarget = target
        newTarget.name = ModulePath.Shared.name
        return newTarget
    }

    static func shared(sources module: ModulePath.Shared, target: Target) -> Self {
        var newTarget = target
        newTarget.name = ModulePath.Shared.name + module.rawValue
        newTarget.sources = .sources

        if module == .DesignSystem {
            newTarget.product = .staticFramework
            newTarget.resources = ["Resources/**"]
            newTarget.bundleId = "\(Project.Environment.bundlePrefix).\(module.rawValue.lowercased())"
            newTarget.settings = .settings(
                base: [
                    "ENABLE_MODULE_VERIFIER": "YES",
                    "MODULE_VERIFIER_SUPPORTED_LANGUAGE_STANDARDS": "gnu11 gnu++14",
                ],
                configurations: [
                    .build(.debug),
                    .build(.release),
                ],
                defaultSettings: .recommended
            )
        }

        return newTarget
    }

    static func shared(tests module: ModulePath.Shared, target: Target) -> Self {
        var newTarget = target
        newTarget.name = ModulePath.Shared.name + module.rawValue + "Tests"
        newTarget.product = .unitTests
        newTarget.sources = .tests
        return newTarget
    }

    static func shared(example module: ModulePath.Shared, target: Target) -> Self {
        var newTarget = target
        newTarget.name = ModulePath.Shared.name + module.rawValue + "Example"
        newTarget.sources = .exampleSources
        newTarget.product = .app
        newTarget.bundleId = !target.bundleId.isEmpty
            ? target.bundleId
            : "\(Project.Environment.bundlePrefix).\(module.rawValue.lowercased()).example"
        newTarget.settings = Project.Environment.makeExampleSettings()
        return newTarget
    }
}
