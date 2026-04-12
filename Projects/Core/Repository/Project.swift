import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Core.name + ModulePath.Core.Repository.rawValue,
    targets: [
        .core(sources: .Repository, target: .init(dependencies: [])),
        .core(tests: .Repository, target: .init(dependencies: [.core(sources: .Repository)])),
    ]
)
