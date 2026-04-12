import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .app(
        module: .iOS,
        deploymentTarget: .debug,
        target: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .debug),
            scripts: Project.Environment.appTargetScripts,
            dependencies: [
                .feature,
            ],
            settings: Project.Environment.makeSettings(deploymentTarget: .debug)
        )
    ),
    .app(
        module: .iOS,
        deploymentTarget: .release,
        target: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .release),
            scripts: Project.Environment.appTargetScripts,
            dependencies: [
                .feature,
            ],
            settings: Project.Environment.makeSettings(deploymentTarget: .release)
        )
    ),
    .app(
        tests: .iOS,
        target: .init(
            infoPlist: Project.Environment.testAppInfoPlist(),
            dependencies: [
                .target(name: Project.Environment.targetName(deploymentTarget: .debug)),
            ]
        )
    ),
]

let project: Project = .makeModule(
    name: Project.Environment.appName,
    targets: targets,
    schemes: [
        .make(.debug, name: Project.Environment.appName),
        .make(.release, name: Project.Environment.appName),
    ]
)
