import Foundation

@main
enum GenerateModule {
    static func main() {
        let bash = Bash()
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        let generateModuleService = GenerateModuleService(
            bash: bash,
            fileManager: fileManager,
            currentPath: currentPath
        )
        let viewController = GenerateModuleViewController(
            generateModuleService: generateModuleService
        )
        viewController.render()
    }
}
