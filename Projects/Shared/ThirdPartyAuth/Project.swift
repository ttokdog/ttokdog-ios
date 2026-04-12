import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Shared.name + ModulePath.Shared.ThirdPartyAuth.rawValue,
    targets: [
        .shared(
            sources: .ThirdPartyAuth,
            target: .init(dependencies: [
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKUser"),
                .external(name: "GoogleSignIn"),
            ])
        ),
    ]
)
