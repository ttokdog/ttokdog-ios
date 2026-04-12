import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Core.name + ModulePath.Core.Network.rawValue,
    targets: [
        .core(sources: .Network, target: .init(dependencies: [])),
        .core(tests: .Network, target: .init(dependencies: [.core(sources: .Network)])),
    ]
)
