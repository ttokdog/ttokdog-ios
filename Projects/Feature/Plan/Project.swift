import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Plan.rawValue,
    targets: [
        .feature(sources: .Plan, target: .init(dependencies: [
            .domain,
            .shared(sources: .DesignSystem),
            .shared(sources: .ThirdParty),
        ])),
        .feature(tests: .Plan, target: .init(dependencies: [.feature(sources: .Plan)])),
        .feature(example: .Plan, target: .init(dependencies: [.feature(sources: .Plan)])),
    ]
)
