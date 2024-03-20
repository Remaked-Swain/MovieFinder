import Foundation

protocol DataStorable {
    associatedtype Input
    associatedtype Output
    
    func store(_ input: Input, data: Output) throws
}
