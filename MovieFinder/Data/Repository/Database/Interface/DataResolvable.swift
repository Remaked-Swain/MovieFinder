import Foundation

protocol DataResolvable {
    associatedtype Input
    associatedtype Output
    
    func resolve(_ input: Input) throws -> Output
}
