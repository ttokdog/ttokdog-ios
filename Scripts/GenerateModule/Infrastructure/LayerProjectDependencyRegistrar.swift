import Foundation

final class LayerProjectDependencyRegistrar {
    private let fileManager: FileManager
    private let rootURL: URL

    init(fileManager: FileManager, currentPath: String) {
        self.fileManager = fileManager
        self.rootURL = URL(fileURLWithPath: currentPath, isDirectory: true).standardizedFileURL
    }

    func register(layer: LayerType, moduleName: String) {
        let projectFileURL = rootURL
            .appendingPathComponent("Projects", isDirectory: true)
            .appendingPathComponent(layer.rawValue, isDirectory: true)
            .appendingPathComponent("Project.swift", isDirectory: false)
        let projectFilePath = projectFileURL.path

        guard fileManager.fileExists(atPath: projectFilePath) else {
            fatalError("❌ Failed to find layer Project.swift at \(projectFilePath)")
        }

        let dependencyLine = ".\(layer.rawValue.lowercased())(sources: .\(moduleName))"
        guard let projectContent = try? String(contentsOfFile: projectFilePath, encoding: .utf8) else {
            fatalError("❌ Failed to read \(projectFilePath)")
        }

        if projectContent.contains(dependencyLine) {
            return
        }

        var updated = projectContent
        let dependencyBodyRange = findDependenciesBodyRange(in: projectContent, filePath: projectFilePath)
        let dependencyIndentation = inferDependencyIndentation(in: projectContent, bodyRange: dependencyBodyRange)
        let needsLeadingNewline = !projectContent[dependencyBodyRange].contains("\n")
        let dependencyEntry = "\(needsLeadingNewline ? "\n" : "")\(dependencyIndentation)\(dependencyLine),\n"
        updated.insert(contentsOf: dependencyEntry, at: dependencyBodyRange.upperBound)

        do {
            try updated.write(to: projectFileURL, atomically: true, encoding: .utf8)
        } catch {
            fatalError("❌ Failed to write \(projectFilePath): \(error)")
        }
    }

    private func findDependenciesBodyRange(in content: String, filePath: String) -> Range<String.Index> {
        guard let dependenciesKeyRange = content.range(of: "dependencies:") else {
            fatalError("❌ Failed to find dependencies key in \(filePath)")
        }

        guard let openingBracketIndex = content[dependenciesKeyRange.upperBound...].firstIndex(of: "[") else {
            fatalError("❌ Failed to find dependencies array in \(filePath)")
        }

        var depth = 0
        var index = openingBracketIndex
        while index < content.endIndex {
            let character = content[index]
            if character == "[" {
                depth += 1
            } else if character == "]" {
                depth -= 1
                if depth == 0 {
                    return content.index(after: openingBracketIndex)..<index
                }
            }
            index = content.index(after: index)
        }

        fatalError("❌ Failed to parse dependencies array in \(filePath)")
    }

    private func inferDependencyIndentation(in content: String, bodyRange: Range<String.Index>) -> String {
        let body = content[bodyRange]
        for line in body.split(separator: "\n", omittingEmptySubsequences: false) {
            let trimmed = String(line).trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { continue }
            let indent = line.prefix { $0 == " " || $0 == "\t" }
            if !indent.isEmpty {
                return String(indent)
            }
        }

        return "            "
    }
}
