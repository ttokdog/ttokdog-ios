import Foundation

struct GenerateModuleInputView {

    func layerInput() -> LayerType {
        guard let rawLayerInput = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
              !rawLayerInput.isEmpty
        else {
            fatalError("Layer name is required.")
        }

        let normalizedLayerInput = rawLayerInput.prefix(1).uppercased() + rawLayerInput.dropFirst().lowercased()
        guard let layer = LayerType(rawValue: normalizedLayerInput) else {
            fatalError("Invalid layer name: \(rawLayerInput)")
        }
        return layer
    }

    func moduleInput() -> String {
        guard let moduleName = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
              !moduleName.isEmpty
        else {
            fatalError("Module name is required.")
        }
        return moduleName
    }

    func unitTestRequiredInput(defaultYes: Bool) -> Bool {
        let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        if input.isEmpty { return defaultYes }
        return input == "y"
    }

    func exampleTargetRequiredInput() -> Bool {
        readLine()?.lowercased() == "y"
    }
}
