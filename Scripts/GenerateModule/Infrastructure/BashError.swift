import Foundation

enum BashError: Error {
    case commandNotFound(name: String)
    case commandFailed(name: String, code: Int32, output: String)
}
