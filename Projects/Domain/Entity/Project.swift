import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name + ModulePath.Domain.Entity.rawValue,
    targets: [
        .domain(sources: .Entity, target: .init(dependencies: [])),
        .domain(tests: .Entity, target: .init(dependencies: [.domain(sources: .Entity)])),
    ]
)
