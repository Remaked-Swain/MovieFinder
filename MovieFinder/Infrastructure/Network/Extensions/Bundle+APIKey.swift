//
//  Bundle+APIKey.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/1/24.
//

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
    var koficAPIKey: String? {
        switch traverseKey() {
        case .success(let key):
            return key
        case .failure(let error):
            print(error.debugDescription)
            return nil
        }
    }
    
    // MARK: Private Methods
    private func traverseKey() -> Result<String, TraversalError> {
        guard let fileURL = Self.main.url(forResource: EndpointType.propertyListFileName, withExtension: "plist") else {
            return .failure(.fileNotFound)
        }
        
        guard let plist = NSDictionary(contentsOf: fileURL),
              let value = plist.object(forKey: EndpointType.keyName) as? String
        else {
            return .failure(.keyNotFound)
        }
        
        return .success(value)
    }
}
