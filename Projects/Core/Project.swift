import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .core(target: .init(
        dependencies: [
            .core(sources: .Network),
            .core(sources: .KeyChain),
            .core(sources: .UserDefault),
            .core(sources: .Repository),
            .core(sources: .JWT),
        ],
        settings: .settings(configurations: [
            .build(.debug),
            .build(.release),
        ])
    )),
]

let project: Project = .makeModule(
    name: ModulePath.Core.name,
    targets: targets
)
