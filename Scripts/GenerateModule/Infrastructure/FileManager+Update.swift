import Foundation

extension FileManager {
    func updateFileContent(
        filePath: String,
        finding findingString: String,
        inserting insertString: String
    ) {
        let fileURL = URL(fileURLWithPath: filePath)

        guard let readHandle = try? FileHandle(forReadingFrom: fileURL) else {
            fatalError("❌ Failed to find \(filePath)")
        }

        guard let readData = try? readHandle.readToEnd() else {
            fatalError("❌ Failed to read \(filePath)")
        }

        try? readHandle.close()

        guard var fileString = String(data: readData, encoding: .utf8) else {
            fatalError("❌ Failed to decode \(filePath)")
        }

        fileString.insert(
            contentsOf: insertString,
            at: fileString.range(of: findingString)?.upperBound ?? fileString.endIndex
        )

        guard let writeHandle = try? FileHandle(forWritingTo: fileURL) else {
            fatalError("❌ Failed to open for writing \(filePath)")
        }

        writeHandle.seek(toFileOffset: 0)
        try? writeHandle.write(contentsOf: Data(fileString.utf8))
        try? writeHandle.close()
    }
}
