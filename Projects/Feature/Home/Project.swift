import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Home.rawValue,
    targets: [
        .feature(sources: .Home, target: .init(dependencies: [
            .domain,
            .shared(sources: .DesignSystem),
            .shared(sources: .ThirdParty),
        ])),
        .feature(tests: .Home, target: .init(dependencies: [.feature(sources: .Home)])),
    ]
)
