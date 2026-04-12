import ProjectDescription

// MARK: - Feature

public extension TargetDependency {
    static var feature: Self {
        .project(target: ModulePath.Feature.name, path: .feature)
    }

    static func feature(sources module: ModulePath.Feature) -> Self {
        .project(
            target: ModulePath.Feature.name + module.rawValue,
            path: .feature(subModule: module)
        )
    }

    static func feature(tests module: ModulePath.Feature) -> Self {
        .project(
            target: ModulePath.Feature.name + module.rawValue + "Tests",
            path: .feature(subModule: module)
        )
    }

    static func feature(example module: ModulePath.Feature) -> Self {
        .project(
            target: ModulePath.Feature.name + module.rawValue + "Example",
            path: .feature(subModule: module)
        )
    }
}

// MARK: - Domain

public extension TargetDependency {
    static var domain: Self {
        .project(target: ModulePath.Domain.name, path: .domain)
    }

    static func domain(sources module: ModulePath.Domain) -> Self {
        .project(
            target: ModulePath.Domain.name + module.rawValue,
            path: .domain(subModule: module)
        )
    }

    static func domain(tests module: ModulePath.Domain) -> Self {
        .project(
            target: ModulePath.Domain.name + module.rawValue + "Tests",
            path: .domain(subModule: module)
        )
    }
}

// MARK: - Core

public extension TargetDependency {
    static var core: Self {
        .project(target: ModulePath.Core.name, path: .core)
    }

    static func core(sources module: ModulePath.Core) -> Self {
        .project(
            target: ModulePath.Core.name + module.rawValue,
            path: .core(subModule: module)
        )
    }

    static func core(tests module: ModulePath.Core) -> Self {
        .project(
            target: ModulePath.Core.name + module.rawValue + "Tests",
            path: .core(subModule: module)
        )
    }
}

// MARK: - Shared

public extension TargetDependency {
    static var shared: Self {
        .project(target: ModulePath.Shared.name, path: .shared)
    }

    static func shared(sources module: ModulePath.Shared) -> Self {
        .project(
            target: ModulePath.Shared.name + module.rawValue,
            path: .shared(subModule: module)
        )
    }

    static func shared(tests module: ModulePath.Shared) -> Self {
        .project(
            target: ModulePath.Shared.name + module.rawValue + "Tests",
            path: .shared(subModule: module)
        )
    }

    static func shared(example module: ModulePath.Shared) -> Self {
        .project(
            target: ModulePath.Shared.name + module.rawValue + "Example",
            path: .shared(subModule: module)
        )
    }
}
