import Foundation

struct TargetStringFactory {
    func make(from request: GenerateModuleRequest) -> String {
        let layerPath = request.layer.rawValue.lowercased()
        let sourceDependencies = sourceDependencies(for: request.layer)
            .map { "                \($0)" }
            .joined(separator: "\n")
        let sourceDependenciesBlock = sourceDependencies.isEmpty
            ? ""
            : "\n\(sourceDependencies)\n"

        var targets: [String] = [
            """
                .\(layerPath)(
                    sources: .\(request.moduleName),
                    target: .init(
                        dependencies: [\(sourceDependenciesBlock)                ]
                    )
                )
            """
        ]

        if request.hasUnitTests {
            targets.append(
                """
                    .\(layerPath)(
                        tests: .\(request.moduleName),
                        target: .init(
                            dependencies: [
                                .\(layerPath)(sources: .\(request.moduleName))
                            ]
                        )
                    )
                """
            )
        }

        if request.hasExample {
            targets.append(
                """
                    .\(layerPath)(
                        example: .\(request.moduleName),
                        target: .init(
                            dependencies: [
                                .\(layerPath)(sources: .\(request.moduleName))
                            ]
                        )
                    )
                """
            )
        }

        return """
        [
        \(targets.joined(separator: ",\n"))
            ]
        """
    }

    private func sourceDependencies(for layer: LayerType) -> [String] {
        switch layer {
        case .feature:
            // ThirdParty: TCA + NukeUI (전역)
            // 인증이 필요한 Feature는 생성 후 .shared(sources: .ThirdPartyAuth) 수동 추가
            return [
                ".domain",
                ".shared(sources: .DesignSystem)",
                ".shared(sources: .ThirdParty)",
            ]
        case .domain:
            return [".domain(sources: .Entity)"]
        case .core:
            return []
        case .shared:
            return []
        }
    }
}
