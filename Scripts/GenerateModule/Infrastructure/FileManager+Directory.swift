import Foundation

extension FileManager {
    func makeDirectory(path: String) {
        var isDirectory = ObjCBool(false)
        if fileExists(atPath: path, isDirectory: &isDirectory) {
            guard isDirectory.boolValue else {
                fatalError("❌ path exists but is not a directory: \(path)")
            }
            return
        }

        do {
            try createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            fatalError("❌ failed to create directory: \(path)\n\(error)")
        }
    }
}
