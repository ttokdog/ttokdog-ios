import Foundation

/// tuist scaffold 대신 직접 디렉토리와 placeholder 파일을 생성한다.
/// Feature 레이어는 TCA(Feature + View) 보일러플레이트를 생성한다.
final class ModuleScaffoldRunner {
    private let fileManager: FileManager
    private let currentPath: String

    init(fileManager: FileManager, currentPath: String) {
        self.fileManager = fileManager
        self.currentPath = currentPath
    }

    func run(request: GenerateModuleRequest) {
        let rootURL = URL(fileURLWithPath: currentPath, isDirectory: true)
        let moduleURL = rootURL
            .appendingPathComponent("Projects", isDirectory: true)
            .appendingPathComponent(request.layer.rawValue, isDirectory: true)
            .appendingPathComponent(request.moduleName, isDirectory: true)

        let fullModuleName = request.layer.rawValue + request.moduleName
        let sourcesURL = moduleURL.appendingPathComponent("Sources", isDirectory: true)

        // Sources
        if request.layer == .feature {
            createFeatureSources(at: sourcesURL, moduleName: request.moduleName, fullModuleName: fullModuleName)
        } else {
            createFile(
                at: sourcesURL,
                fileName: "\(request.moduleName).swift",
                content: makeSourceHeader(fullModuleName: fullModuleName, layer: request.layer, moduleName: request.moduleName)
            )
        }

        // Tests
        if request.hasUnitTests {
            createFile(
                at: moduleURL.appendingPathComponent("Tests/Sources", isDirectory: true),
                fileName: "\(request.moduleName)Tests.swift",
                content: makeTestHeader(fullModuleName: fullModuleName, moduleName: request.moduleName)
            )
        }

        // Example
        if request.hasExample {
            createFile(
                at: moduleURL.appendingPathComponent("Example/Sources", isDirectory: true),
                fileName: "\(request.moduleName)ExampleApp.swift",
                content: makeExampleHeader(fullModuleName: fullModuleName, moduleName: request.moduleName)
            )
        }
    }

    // MARK: - Feature (TCA)

    private func createFeatureSources(at sourcesURL: URL, moduleName: String, fullModuleName: String) {
        fileManager.makeDirectory(path: sourcesURL.path)

        // Feature (Reducer)
        let featurePath = sourcesURL.appendingPathComponent("\(moduleName)Feature.swift", isDirectory: false).path
        if !fileManager.fileExists(atPath: featurePath) {
            fileManager.writeContentInFile(path: featurePath, content: makeFeatureReducer(moduleName: moduleName))
        }

        // View
        let viewPath = sourcesURL.appendingPathComponent("\(moduleName)View.swift", isDirectory: false).path
        if !fileManager.fileExists(atPath: viewPath) {
            fileManager.writeContentInFile(path: viewPath, content: makeFeatureView(moduleName: moduleName))
        }
    }

    private func makeFeatureReducer(moduleName: String) -> String {
        """
        import Foundation
        import ComposableArchitecture

        @Reducer
        public struct \(moduleName)Feature: Reducer {

            @ObservableState
            public struct State: Equatable {
                public init() {}
            }

            public init() {}

            public enum Action {
                case onAppear
            }

            public var body: some ReducerOf<Self> {
                Reduce { state, action in
                    switch action {
                    case .onAppear:
                        return .none
                    }
                }
            }
        }

        """
    }

    private func makeFeatureView(moduleName: String) -> String {
        """
        import SwiftUI
        import ComposableArchitecture

        public struct \(moduleName)View: View {
            @Bindable public var store: StoreOf<\(moduleName)Feature>

            public init(store: StoreOf<\(moduleName)Feature>) {
                self.store = store
            }

            public var body: some View {
                Text("\(moduleName)")
                    .onAppear {
                        store.send(.onAppear)
                    }
            }
        }

        #Preview {
            \(moduleName)View(
                store: .init(
                    initialState: \(moduleName)Feature.State(),
                    reducer: {
                        \(moduleName)Feature()
                    }
                )
            )
        }

        """
    }

    // MARK: - Generic (Non-Feature)

    private func createFile(at directoryURL: URL, fileName: String, content: String) {
        fileManager.makeDirectory(path: directoryURL.path)
        let filePath = directoryURL.appendingPathComponent(fileName, isDirectory: false).path
        if !fileManager.fileExists(atPath: filePath) {
            fileManager.writeContentInFile(path: filePath, content: content)
        }
    }

    private func makeSourceHeader(fullModuleName: String, layer: LayerType, moduleName: String) -> String {
        """
        // \(fullModuleName)
        // \(layerDescription(layer)) - \(moduleName) 모듈.

        import Foundation

        """
    }

    private func makeTestHeader(fullModuleName: String, moduleName: String) -> String {
        """
        import Testing
        @testable import \(fullModuleName)

        struct \(moduleName)Tests {
            @Test func example() {
                #expect(true)
            }
        }

        """
    }

    private func makeExampleHeader(fullModuleName: String, moduleName: String) -> String {
        """
        import SwiftUI
        import \(fullModuleName)

        struct \(moduleName)ExampleView: View {
            var body: some View {
                Text("\(moduleName) Example")
            }
        }

        #Preview {
            \(moduleName)ExampleView()
        }

        """
    }

    private func layerDescription(_ layer: LayerType) -> String {
        switch layer {
        case .feature: return "Feature 레이어"
        case .domain: return "Domain 레이어"
        case .core: return "Core 레이어"
        case .shared: return "Shared 레이어"
        }
    }
}
