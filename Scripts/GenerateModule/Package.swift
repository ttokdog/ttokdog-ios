// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GenerateModule",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "generate-module", targets: ["GenerateModule"]),
        .executable(name: "clean-generated-module-changes", targets: ["CleanGeneratedModuleChanges"])
    ],
    targets: [
        .executableTarget(
            name: "GenerateModule",
            path: ".",
            exclude: ["Package.swift", "CleanGeneratedModuleChanges"]
        ),
        .executableTarget(
            name: "CleanGeneratedModuleChanges",
            path: "CleanGeneratedModuleChanges"
        )
    ]
)
