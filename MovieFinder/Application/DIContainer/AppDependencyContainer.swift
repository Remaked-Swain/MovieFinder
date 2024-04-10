//
//  AppDependencyContainer.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/5/24.
//

import Foundation

protocol DependencyResolvable {
    func resolve<T>(for type: T.Type) -> T
}

protocol DependencyRegistrable {
    func register<T>(for key: T.Type, instance: T)
    func register<T>(for type: T.Type, _ handler: @escaping (DependencyResolvable) -> T)
}

typealias AppDependencyContainer = DependencyResolvable & DependencyRegistrable

final class DefaultDependencyContainer {
    // MARK: Properties
    private var dependencies: [String: Any] = [:]
}

// MARK: AppDependencyContainer Confirmation
extension DefaultDependencyContainer: AppDependencyContainer {
    func register<T>(for key: T.Type, instance: T) {
        let key = String(describing: key)
        dependencies[key] = instance
    }
    
    func register<T>(for type: T.Type, _ handler: @escaping (DependencyResolvable) -> T) {
        let key =  String(describing: type)
        dependencies[key] = handler
    }
    
    func resolve<T>(for type: T.Type) -> T {
        let key = String(describing: type)
        
        if let resolver = dependencies[key] as? (DependencyResolvable) -> T {
            return resolver(self)
        } else if let value = dependencies[key] as? T {
            return value
        } else {
            fatalError("의존성 객체 없음: \(type)")
        }
    }
}
