import Foundation

fileprivate typealias ContainerProtocol = DataResolvable & DataStorable

final class APIKeyContainer {
    typealias Input = String
    typealias Output = String
    
    private var keys: [String: String] = [:]
    
    init() {
        let key = EndpointType.keyName
        let value = Bundle.main.koficAPIKey
        
        do {
            try store(key, data: value)
        } catch {
            print("Unknown Error Occured On Database: APIKeyContainer")
        }
    }
}

// MARK: ContainerProtocol Confirmation
extension APIKeyContainer: ContainerProtocol {
    func resolve(_ input: String) throws -> String {
        guard let key = keys[input] else {
            throw DatabaseError.notFoundData
        }
        return key
    }
    
    func store(_ input: String, data: String) throws {
        keys[input] = data
    }
}
