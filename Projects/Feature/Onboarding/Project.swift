import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Onboarding.rawValue,
    targets: [
        .feature(sources: .Onboarding, target: .init(dependencies: [
            .domain,
            .shared(sources: .DesignSystem),
            .shared(sources: .ThirdParty),
            .shared(sources: .ThirdPartyAuth),
        ])),
        .feature(tests: .Onboarding, target: .init(dependencies: [.feature(sources: .Onboarding)])),
        .feature(example: .Onboarding, target: .init(dependencies: [.feature(sources: .Onboarding)])),
    ]
)
