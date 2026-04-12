import ProjectDescription

// MARK: - App

public extension ProjectDescription.Path {
    static var app: Self {
        .relativeToRoot("Projects/\(ModulePath.App.name)")
    }
}

// MARK: - Feature

public extension ProjectDescription.Path {
    static var feature: Self {
        .relativeToRoot("Projects/\(ModulePath.Feature.name)")
    }

    static func feature(subModule: ModulePath.Feature) -> Self {
        .relativeToRoot("Projects/\(ModulePath.Feature.name)/\(subModule.rawValue)")
    }
}

// MARK: - Domain

public extension ProjectDescription.Path {
    static var domain: Self {
        .relativeToRoot("Projects/\(ModulePath.Domain.name)")
    }

    static func domain(subModule: ModulePath.Domain) -> Self {
        .relativeToRoot("Projects/\(ModulePath.Domain.name)/\(subModule.rawValue)")
    }
}

// MARK: - Core

public extension ProjectDescription.Path {
    static var core: Self {
        .relativeToRoot("Projects/\(ModulePath.Core.name)")
    }

    static func core(subModule: ModulePath.Core) -> Self {
        .relativeToRoot("Projects/\(ModulePath.Core.name)/\(subModule.rawValue)")
    }
}

// MARK: - Shared

public extension ProjectDescription.Path {
    static var shared: Self {
        .relativeToRoot("Projects/\(ModulePath.Shared.name)")
    }

    static func shared(subModule: ModulePath.Shared) -> Self {
        .relativeToRoot("Projects/\(ModulePath.Shared.name)/\(subModule.rawValue)")
    }
}
