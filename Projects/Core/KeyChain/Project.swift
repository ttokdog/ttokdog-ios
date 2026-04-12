import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Core.name + ModulePath.Core.KeyChain.rawValue,
    targets: [
        .core(sources: .KeyChain, target: .init(dependencies: [])),
        .core(tests: .KeyChain, target: .init(dependencies: [.core(sources: .KeyChain)])),
    ]
)
