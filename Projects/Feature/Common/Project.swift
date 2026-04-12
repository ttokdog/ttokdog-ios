import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Common.rawValue,
    targets: [
        .feature(sources: .Common, target: .init(dependencies: [
            .shared(sources: .DesignSystem),
            .shared(sources: .Util),
        ])),
    ]
)
