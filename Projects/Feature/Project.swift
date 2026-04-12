import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .feature(target: .init(
        dependencies: [
            .domain,
            .feature(sources: .AppCoordinator),
            .feature(sources: .Tab),
            .feature(sources: .Splash),
            .feature(sources: .Common),
            .feature(sources: .Onboarding),
            .feature(sources: .Home),
            .feature(sources: .Profile),
            .feature(sources: .Plan),
            .feature(sources: .Map),
        ],
        settings: .settings(configurations: [
            .build(.debug),
            .build(.release),
        ])
    )),
]

let project: Project = .makeModule(
    name: ModulePath.Feature.name,
    targets: targets
)
