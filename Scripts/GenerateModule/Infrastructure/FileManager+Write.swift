import Foundation

extension FileManager {
    func writeContentInFile(path: String, content: String) {
        let fileURL = URL(fileURLWithPath: path)
        let data = Data(content.utf8)

        do {
            try data.write(to: fileURL)
        } catch {
            fatalError("❌ failed to write file: \(path)\n\(error)")
        }
    }
}
