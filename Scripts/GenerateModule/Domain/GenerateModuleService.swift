import Foundation

final class GenerateModuleService {
    private let modulePathRegistrar: ModulePathRegistrar
    private let layerProjectDependencyRegistrar: LayerProjectDependencyRegistrar
    private let layerExportRegistrar: LayerExportRegistrar
    private let moduleProjectCreator: ModuleProjectCreator
    private let moduleScaffoldRunner: ModuleScaffoldRunner
    private let targetStringFactory: TargetStringFactory
    private let projectSwiftFactory: ProjectSwiftFactory

    init(
        modulePathRegistrar: ModulePathRegistrar,
        layerProjectDependencyRegistrar: LayerProjectDependencyRegistrar,
        layerExportRegistrar: LayerExportRegistrar,
        moduleProjectCreator: ModuleProjectCreator,
        moduleScaffoldRunner: ModuleScaffoldRunner,
        targetStringFactory: TargetStringFactory = TargetStringFactory(),
        projectSwiftFactory: ProjectSwiftFactory = ProjectSwiftFactory()
    ) {
        self.modulePathRegistrar = modulePathRegistrar
        self.layerProjectDependencyRegistrar = layerProjectDependencyRegistrar
        self.layerExportRegistrar = layerExportRegistrar
        self.moduleProjectCreator = moduleProjectCreator
        self.moduleScaffoldRunner = moduleScaffoldRunner
        self.targetStringFactory = targetStringFactory
        self.projectSwiftFactory = projectSwiftFactory
    }

    convenience init(bash: Bash, fileManager: FileManager, currentPath: String) {
        let modulePathRegistrar = ModulePathRegistrar(fileManager: fileManager, currentPath: currentPath)
        let layerProjectDependencyRegistrar = LayerProjectDependencyRegistrar(fileManager: fileManager, currentPath: currentPath)
        let layerExportRegistrar = LayerExportRegistrar(fileManager: fileManager, currentPath: currentPath)
        let moduleProjectCreator = ModuleProjectCreator(fileManager: fileManager, currentPath: currentPath)
        let moduleScaffoldRunner = ModuleScaffoldRunner(fileManager: fileManager, currentPath: currentPath)
        self.init(
            modulePathRegistrar: modulePathRegistrar,
            layerProjectDependencyRegistrar: layerProjectDependencyRegistrar,
            layerExportRegistrar: layerExportRegistrar,
            moduleProjectCreator: moduleProjectCreator,
            moduleScaffoldRunner: moduleScaffoldRunner
        )
    }

    func generate(request: GenerateModuleRequest) {
        let targetString = targetStringFactory.make(from: request)
        let projectSwiftString = projectSwiftFactory.make(from: request, targetString: targetString)

        // 디렉토리 구조와 placeholder 파일을 생성한다.
        moduleScaffoldRunner.run(request: request)

        // 서브모듈 Project.swift를 생성한다.
        moduleProjectCreator.create(
            layer: request.layer,
            moduleName: request.moduleName,
            projectSwiftString: projectSwiftString
        )

        // Module.swift enum에 새 case를 등록한다.
        modulePathRegistrar.register(layer: request.layer, moduleName: request.moduleName)

        // umbrella Project.swift dependencies에 서브모듈을 추가한다.
        layerProjectDependencyRegistrar.register(layer: request.layer, moduleName: request.moduleName)

        // umbrella Exports 파일에 @_exported import를 추가한다.
        layerExportRegistrar.register(layer: request.layer, moduleName: request.moduleName)
    }
}
