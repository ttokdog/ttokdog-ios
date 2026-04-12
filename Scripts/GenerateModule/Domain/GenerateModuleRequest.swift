import Foundation

struct GenerateModuleRequest {
    let layer: LayerType
    let moduleName: String
    let hasUnitTests: Bool
    let hasExample: Bool

    init(layer: LayerType, moduleName: String, hasUnitTests: Bool, hasExample: Bool) {
        let trimmedModuleName = moduleName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedModuleName.isEmpty else {
            fatalError("Module name is required.")
        }

        self.layer = layer
        self.moduleName = trimmedModuleName
        self.hasUnitTests = hasUnitTests
        self.hasExample = (layer == .feature || layer == .shared) ? hasExample : false
    }
}
