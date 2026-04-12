import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Profile.rawValue,
    targets: [
        .feature(sources: .Profile, target: .init(dependencies: [
            .domain,
            .shared(sources: .DesignSystem),
            .shared(sources: .ThirdParty),
        ])),
        .feature(tests: .Profile, target: .init(dependencies: [.feature(sources: .Profile)])),
    ]
)
