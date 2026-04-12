import Foundation

struct ProjectSwiftFactory {
    func make(from request: GenerateModuleRequest, targetString: String) -> String {
        """
        import ProjectDescription
        import ProjectDescriptionHelpers
        import DependencyPlugin

        let project = Project.makeModule(
            name: ModulePath.\(request.layer.rawValue).name + ModulePath.\(request.layer.rawValue).\(request.moduleName).rawValue,
            targets: \(targetString)
        )
        """
    }
}
