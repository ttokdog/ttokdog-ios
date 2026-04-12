import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Shared.name + ModulePath.Shared.Logger.rawValue,
    targets: [
        .shared(
            sources: .Logger,
            target: .init(dependencies: [])
        ),
    ]
)
