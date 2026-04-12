import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Tab.rawValue,
    targets: [
        .feature(sources: .Tab, target: .init(dependencies: [
            .feature(sources: .Home),
            .feature(sources: .Plan),
            .feature(sources: .Map),
            .feature(sources: .Profile),
            .shared(sources: .DesignSystem),
            .shared(sources: .ThirdParty),
        ])),
        .feature(tests: .Tab, target: .init(dependencies: [.feature(sources: .Tab)])),
        .feature(example: .Tab, target: .init(dependencies: [.feature(sources: .Tab)])),
    ]
)
