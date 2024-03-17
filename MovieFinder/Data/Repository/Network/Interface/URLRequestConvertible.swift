import Foundation

protocol URLRequestConvertible {
    func makeURLRequest() throws -> URLRequest
}
