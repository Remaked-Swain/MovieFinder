import Foundation

enum NetworkError: Error {
    case requestFailed(statusCode: Int)
    case taskingError
    case corruptedData
    case invalidURL
}
