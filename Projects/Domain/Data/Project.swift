import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name + ModulePath.Domain.Data.rawValue,
    targets: [
        .domain(
            sources: .Data,
            target: .init(dependencies: [
                .domain(sources: .Entity),
                .domain(sources: .Service),
                .core(sources: .Network),
                .core(sources: .Repository),
            ])
        ),
        .domain(tests: .Data, target: .init(dependencies: [.domain(sources: .Data)])),
    ]
)
