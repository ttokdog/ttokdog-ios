import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .domain(target: .init(
        dependencies: [
            .core,
            .domain(sources: .Entity),
            .domain(sources: .Service),
            .domain(sources: .Data),
        ],
        settings: .settings(configurations: [
            .build(.debug),
            .build(.release),
        ])
    )),
]

let project: Project = .makeModule(
    name: ModulePath.Domain.name,
    targets: targets
)
