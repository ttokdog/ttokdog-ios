import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name + ModulePath.Domain.Service.rawValue,
    targets: [
        .domain(
            sources: .Service,
            target: .init(dependencies: [
                .domain(sources: .Entity),
            ])
        ),
        .domain(tests: .Service, target: .init(dependencies: [.domain(sources: .Service)])),
    ]
)
