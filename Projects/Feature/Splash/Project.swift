import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Splash.rawValue,
    targets: [
        .feature(sources: .Splash, target: .init(dependencies: [
            .domain,
            .shared(sources: .DesignSystem),
            .shared(sources: .ThirdParty),
        ])),
        .feature(tests: .Splash, target: .init(dependencies: [.feature(sources: .Splash)])),
        .feature(example: .Splash, target: .init(dependencies: [.feature(sources: .Splash)])),
    ]
)
