import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Core.name + ModulePath.Core.JWT.rawValue,
    targets: [
        .core(sources: .JWT, target: .init(dependencies: [])),
        .core(tests: .JWT, target: .init(dependencies: [.core(sources: .JWT)])),
    ]
)
