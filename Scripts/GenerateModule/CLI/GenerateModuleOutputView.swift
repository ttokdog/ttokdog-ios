import Foundation

struct GenerateModuleOutputView {
    func showInputLayerNameRequest() {
        print("Enter layer name\n(Feature | Domain | Core | Shared)", terminator: " : ")
    }

    func showInputModuleNameRequest() {
        print("Enter module name", terminator: " : ")
    }

    func showInputUnitTestsTargetRequest(defaultYes: Bool) {
        let defaultLabel = defaultYes ? "default = y" : "default = n"
        print("This module has a 'Tests' Target? (y/n, \(defaultLabel))", terminator: " : ")
    }

    func showInputExampleTargetRequest() {
        print("This module has a 'Example' Target? (y/n, default = n)", terminator: " : ")
    }

    func showModuleCreationResult(moduleName: String, layer: LayerType, hasUnitTests: Bool, hasExample: Bool) {
        print("")
        print("------------------------------------------------------------------------------------------------------------------------")
        print("Layer: \(layer.rawValue)")
        print("Module name: \(moduleName)")
        print("unitTests: \(hasUnitTests), example: \(hasExample)")
        print("------------------------------------------------------------------------------------------------------------------------")
        print("✅ Module is created successfully!")
    }
}
