import Foundation

final class LayerExportRegistrar {
    private let fileManager: FileManager
    private let rootURL: URL

    init(fileManager: FileManager, currentPath: String) {
        self.fileManager = fileManager
        self.rootURL = URL(fileURLWithPath: currentPath, isDirectory: true).standardizedFileURL
    }

    func register(layer: LayerType, moduleName: String) {
        let exportFileURL = rootURL
            .appendingPathComponent("Projects", isDirectory: true)
            .appendingPathComponent(layer.rawValue, isDirectory: true)
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("\(layer.rawValue)Exports.swift", isDirectory: false)
        let exportFilePath = exportFileURL.path

        guard fileManager.fileExists(atPath: exportFilePath) else {
            fatalError("❌ Failed to find layer export file at \(exportFilePath)")
        }

        let exportLine = "@_exported import \(layer.rawValue)\(moduleName)"
        guard let exportFileContent = try? String(contentsOfFile: exportFilePath, encoding: .utf8) else {
            fatalError("❌ Failed to read \(exportFilePath)")
        }

        if exportFileContent.contains(exportLine) {
            return
        }

        let lines = exportFileContent.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        var updatedLines = lines
        var insertionIndex = 0
        var foundImport = false

        for (index, line) in lines.enumerated() {
            if line.trimmingCharacters(in: .whitespaces).hasPrefix("import ") {
                insertionIndex = index + 1
                foundImport = true
            }
        }

        if !foundImport {
            insertionIndex = lines.count
        }

        updatedLines.insert(exportLine, at: insertionIndex)
        let updatedContent = updatedLines.joined(separator: "\n")

        do {
            try updatedContent.write(to: exportFileURL, atomically: true, encoding: .utf8)
        } catch {
            fatalError("❌ Failed to write \(exportFilePath): \(error)")
        }
    }
}
