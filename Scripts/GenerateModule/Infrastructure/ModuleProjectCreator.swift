import Foundation

final class ModuleProjectCreator {
    private let fileManager: FileManager
    private let currentPath: String

    init(fileManager: FileManager, currentPath: String) {
        self.fileManager = fileManager
        self.currentPath = currentPath
    }

    func create(layer: LayerType, moduleName: String, projectSwiftString: String) {
        let rootURL = URL(fileURLWithPath: currentPath, isDirectory: true)
        let moduleURL = rootURL
            .appendingPathComponent("Projects", isDirectory: true)
            .appendingPathComponent(layer.rawValue, isDirectory: true)
            .appendingPathComponent(moduleName, isDirectory: true)

        fileManager.makeDirectory(path: moduleURL.path)
        fileManager.writeContentInFile(
            path: moduleURL.appendingPathComponent("Project.swift", isDirectory: false).path,
            content: projectSwiftString
        )
    }
}
