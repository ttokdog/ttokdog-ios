import Foundation

final class GenerateModuleViewController {
    private let outputView = GenerateModuleOutputView()
    private let inputView = GenerateModuleInputView()
    private let generateModuleService: GenerateModuleService

    init(generateModuleService: GenerateModuleService) {
        self.generateModuleService = generateModuleService
    }

    func render() {
        let request = getModuleRequest()
        generateModuleService.generate(request: request)

        outputView.showModuleCreationResult(
            moduleName: request.moduleName,
            layer: request.layer,
            hasUnitTests: request.hasUnitTests,
            hasExample: request.hasExample
        )
    }

    private func getModuleRequest() -> GenerateModuleRequest {
        outputView.showInputLayerNameRequest()
        let layer = inputView.layerInput()

        outputView.showInputModuleNameRequest()
        let moduleName = inputView.moduleInput()

        let testsDefaultYes = (layer != .shared)
        outputView.showInputUnitTestsTargetRequest(defaultYes: testsDefaultYes)
        let hasUnitTests = inputView.unitTestRequiredInput(defaultYes: testsDefaultYes)

        var hasExample = false
        if layer == .feature || layer == .shared {
            outputView.showInputExampleTargetRequest()
            hasExample = inputView.exampleTargetRequiredInput()
        }

        return GenerateModuleRequest(
            layer: layer,
            moduleName: moduleName,
            hasUnitTests: hasUnitTests,
            hasExample: hasExample
        )
    }
}
