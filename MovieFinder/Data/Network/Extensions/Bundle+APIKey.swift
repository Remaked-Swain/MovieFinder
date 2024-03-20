import Foundation

extension Bundle {
    // MARK: Nested Types
    private enum TraversalError: Error, CustomDebugStringConvertible {
        case fileNotFound, keyNotFound
        
        var debugDescription: String {
            switch self {
            case .fileNotFound: "번들에서 파일을 찾을 수 없음"
            case .keyNotFound: "번들에서 키를 찾을 수 없음"
            }
        }
    }
    
    // MARK: Properties
    var koficAPIKey: String {
        switch traversalKey() {
        case .success(let key): 
            return key
        case .failure(let error):
            print(error.debugDescription)
            return String()
        }
    }
    
    // MARK: Private Methods
    private func traversalKey() -> Result<String, TraversalError> {
        guard let fileURL = Self.main.url(forResource: EndpointType.propertyListFileName, withExtension: "plist") else {
            return .failure(TraversalError.fileNotFound)
        }
        
        guard let plist = NSDictionary(contentsOf: fileURL),
              let value = plist.object(forKey: EndpointType.keyName) as? String
        else {
            return .failure(TraversalError.keyNotFound)
        }
        
        return .success(value)
    }
}
