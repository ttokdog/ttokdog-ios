import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Shared.name + ModulePath.Shared.ThirdParty.rawValue,
    targets: [
        .shared(
            sources: .ThirdParty,
            target: .init(dependencies: [
                .external(name: "ComposableArchitecture"),
                .external(name: "NukeUI"),
            ])
        ),
    ]
)
