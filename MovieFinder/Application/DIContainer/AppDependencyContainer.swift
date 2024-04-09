//
//  AppDependencyContainer.swift
//  MovieFinder
//
//  Created by Swain Yun on 4/5/24.
//

import Foundation

protocol Resolver {
    func resolve<T>(for type: T.Type) -> T?
}

protocol AppDependencyContainer {
    func register<T>(_ instance: T)
    func register<T>(for type: T.Type, _ handler: @escaping (Resolver) -> T)
    
    func resolve<T>(for type: T.Type) -> T?
}

final class DefaultDependencyContainer {
    // MARK: Properties
    private var dependencies: [String: Any] = [:]
}

// MARK: AppDependencyContainer Confirmation
extension DefaultDependencyContainer: AppDependencyContainer {
    func register<T>(_ instance: T) {
        let key = String(describing: instance.self)
        dependencies[key] = instance
    }
    
    func register<T>(for type: T.Type, _ handler: @escaping (Resolver) -> T) {
        let key =  String(describing: type)
        dependencies[key] = handler
    }
    
    func resolve<T>(for type: T.Type) -> T? {
        let key = String(describing: type)
        
        guard let value = dependencies[key] as? T else { return nil }
        return value
    }
}
