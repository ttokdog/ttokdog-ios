import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Core.name + ModulePath.Core.UserDefault.rawValue,
    targets: [
        .core(sources: .UserDefault, target: .init(dependencies: [])),
        .core(tests: .UserDefault, target: .init(dependencies: [.core(sources: .UserDefault)])),
    ]
)
