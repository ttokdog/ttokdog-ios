import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .shared(target: .init(
        dependencies: [
            .shared(sources: .DesignSystem),
            .shared(sources: .Util),
            .shared(sources: .Logger),
        ],
        settings: .settings(configurations: [
            .build(.debug),
            .build(.release),
        ])
    )),
]

let project: Project = .makeModule(
    name: ModulePath.Shared.name,
    targets: targets
)
