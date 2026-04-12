import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.AppCoordinator.rawValue,
    targets: [
        .feature(sources: .AppCoordinator, target: .init(dependencies: [
            .feature(sources: .Tab),
            .feature(sources: .Splash),
            .feature(sources: .Onboarding),
            .shared(sources: .ThirdParty),
        ])),
        .feature(tests: .AppCoordinator, target: .init(dependencies: [.feature(sources: .AppCoordinator)])),
        .feature(example: .AppCoordinator, target: .init(dependencies: [.feature(sources: .AppCoordinator)])),
    ]
)
