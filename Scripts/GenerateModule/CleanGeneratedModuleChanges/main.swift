import Foundation

struct CleanGeneratedModuleChanges {
    static func main() throws {
        let runner = CommandRunner()

        guard runner.canRunGit else { return }
        guard runner.isInsideGitWorkTree else { return }

        let repoRoot = try runner.gitOutput(["rev-parse", "--show-toplevel"]).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !repoRoot.isEmpty else { return }

        let cleaner = Cleaner(repoRoot: repoRoot, runner: runner)
        try cleaner.run()
    }
}

private struct Cleaner {
    let repoRoot: String
    let runner: CommandRunner

    func run() throws {
        let layers = ["App", "Feature", "Domain", "Core", "Shared"]

        var restoreCandidates = [
            "Plugins/DependencyPlugin/ProjectDescriptionHelpers/Module.swift",
            "Plugins/DependencyPlugin/ProjectDescriptionHelpers/TargetDependency+Modules.swift",
        ]

        for layer in layers {
            restoreCandidates.append("Projects/\(layer)/Project.swift")
            restoreCandidates.append("Projects/\(layer)/Sources/\(layer)Exports.swift")
        }

        var trackedRestorePaths: [String] = []
        for path in restoreCandidates {
            if runner.gitExitCode(["ls-files", "--error-unmatch", "--", path], cwd: repoRoot) == 0 {
                trackedRestorePaths.append(path)
            }
        }

        if !trackedRestorePaths.isEmpty {
            _ = try runner.gitOutput(["restore", "--staged", "--worktree", "--"] + trackedRestorePaths, cwd: repoRoot)
        }

        let fileManager = FileManager.default
        for layer in layers {
            let layerURL = URL(fileURLWithPath: repoRoot, isDirectory: true)
                .appendingPathComponent("Projects", isDirectory: true)
                .appendingPathComponent(layer, isDirectory: true)

            guard fileManager.fileExists(atPath: layerURL.path) else { continue }

            let moduleDirs = try firstLevelDirectories(in: layerURL, fileManager: fileManager)
            for moduleDir in moduleDirs {
                let manifestURL = moduleDir.appendingPathComponent("Project.swift", isDirectory: false)
                guard fileManager.fileExists(atPath: manifestURL.path) else { continue }

                let relativeModulePath = relativePath(from: repoRoot, absolutePath: moduleDir.path)
                let trackedFiles = try runner.gitOutput(["ls-files", "--", relativeModulePath], cwd: repoRoot)
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                if trackedFiles.isEmpty {
                    try fileManager.removeItem(at: moduleDir)
                }
            }
        }
    }

    private func firstLevelDirectories(in layerURL: URL, fileManager: FileManager) throws -> [URL] {
        let children = try fileManager.contentsOfDirectory(
            at: layerURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        return try children.filter { url in
            let values = try url.resourceValues(forKeys: [.isDirectoryKey])
            return values.isDirectory == true
        }
    }

    private func relativePath(from basePath: String, absolutePath: String) -> String {
        let base = basePath.hasSuffix("/") ? basePath : basePath + "/"
        if absolutePath.hasPrefix(base) {
            return String(absolutePath.dropFirst(base.count))
        }
        return absolutePath
    }
}

private struct CommandRunner {
    var canRunGit: Bool {
        exitCode(["/usr/bin/env", "git", "--version"], cwd: nil) == 0
    }

    var isInsideGitWorkTree: Bool {
        exitCode(["/usr/bin/env", "git", "rev-parse", "--is-inside-work-tree"], cwd: nil) == 0
    }

    func gitExitCode(_ arguments: [String], cwd: String? = nil) -> Int32 {
        exitCode(["/usr/bin/env", "git"] + arguments, cwd: cwd)
    }

    func gitOutput(_ arguments: [String], cwd: String? = nil) throws -> String {
        try run(["/usr/bin/env", "git"] + arguments, cwd: cwd).output
    }

    private func exitCode(_ command: [String], cwd: String?) -> Int32 {
        (try? run(command, cwd: cwd).status) ?? 1
    }

    private func run(_ command: [String], cwd: String?) throws -> (status: Int32, output: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: command[0])
        process.arguments = Array(command.dropFirst())
        if let cwd {
            process.currentDirectoryURL = URL(fileURLWithPath: cwd, isDirectory: true)
        }

        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        try process.run()
        process.waitUntilExit()

        let outData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outData, encoding: .utf8) ?? ""
        let errorOutput = String(data: errData, encoding: .utf8) ?? ""

        if process.terminationStatus != 0 {
            throw RunnerError.commandFailed(
                command: command.joined(separator: " "),
                code: process.terminationStatus,
                stderr: errorOutput
            )
        }

        return (process.terminationStatus, output)
    }
}

private enum RunnerError: Error {
    case commandFailed(command: String, code: Int32, stderr: String)
}

try CleanGeneratedModuleChanges.main()
