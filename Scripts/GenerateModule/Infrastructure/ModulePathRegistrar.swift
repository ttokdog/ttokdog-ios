import Foundation

final class ModulePathRegistrar {
    private let fileManager: FileManager
    private let rootURL: URL

    init(fileManager: FileManager, currentPath: String) {
        self.fileManager = fileManager
        self.rootURL = URL(fileURLWithPath: currentPath, isDirectory: true).standardizedFileURL
    }

    func register(layer: LayerType, moduleName: String) {
        let moduleFileURL = resolveModuleFileURL()
        let moduleFilePath = moduleFileURL.path
        let enumCase = "case \(moduleName)"

        guard let moduleFileContent = try? String(contentsOfFile: moduleFilePath, encoding: .utf8) else {
            fatalError("❌ Failed to read \(moduleFilePath)")
        }

        let enumBodyRange = findEnumBodyRange(in: moduleFileContent, layer: layer)
        let enumBody = moduleFileContent[enumBodyRange]
        if containsCase(in: enumBody, enumCase: enumCase) {
            return
        }

        var updated = moduleFileContent
        updated.insert(contentsOf: "        case \(moduleName)\n", at: enumBodyRange.upperBound)

        do {
            try updated.write(to: moduleFileURL, atomically: true, encoding: .utf8)
        } catch {
            fatalError("❌ Failed to write \(moduleFilePath): \(error)")
        }
    }

    private func containsCase(in enumBody: Substring, enumCase: String) -> Bool {
        enumBody
            .split(separator: "\n", omittingEmptySubsequences: false)
            .contains { line in
                String(line).trimmingCharacters(in: .whitespacesAndNewlines) == enumCase
            }
    }

    private func findEnumBodyRange(in content: String, layer: LayerType) -> Range<String.Index> {
        let enumSignature = "enum \(layer.rawValue): String, CaseIterable"
        guard let enumDeclarationRange = content.range(of: enumSignature) else {
            fatalError("❌ Failed to find enum signature: \(enumSignature)")
        }

        guard let openingBraceIndex = content[enumDeclarationRange.upperBound...].firstIndex(of: "{") else {
            fatalError("❌ Failed to find opening brace for enum \(layer.rawValue)")
        }

        var depth = 0
        var index = openingBraceIndex
        while index < content.endIndex {
            let character = content[index]
            if character == "{" {
                depth += 1
            } else if character == "}" {
                depth -= 1
                if depth == 0 {
                    return content.index(after: openingBraceIndex)..<index
                }
            }
            index = content.index(after: index)
        }

        fatalError("❌ Failed to parse enum body for: \(enumSignature)")
    }

    private func resolveModuleFileURL() -> URL {
        let candidatePaths: [[String]] = [
            ["Plugins", "DependencyPlugin", "ProjectDescriptionHelpers", "Module.swift"],
            ["DependencyPlugin", "ProjectDescriptionHelpers", "Module.swift"],
            ["DependencyPlugin", "ProjectDescriptionHelpers", "Modules.swift"]
        ]

        for candidate in candidatePaths {
            let pathURL = candidate.reduce(rootURL) { url, component in
                url.appendingPathComponent(component, isDirectory: false)
            }
            if fileManager.fileExists(atPath: pathURL.path) {
                return pathURL
            }
        }

        fatalError("❌ Failed to find Module.swift/Modules.swift in DependencyPlugin")
    }
}
