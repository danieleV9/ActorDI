//
//  DIContainer.swift
//  ActorDI
//
//  Created by Daniele Valentino on 23/04/25.
//

import Foundation

public actor DIContainer {
    private var singletons: [ObjectIdentifier: Any] = [:]
    private var factories: [ObjectIdentifier: () -> Any] = [:]

    public init() {}

    public func register<T>(_ type: T.Type, scope: DIScope = .transient, factory: @escaping @Sendable () -> T) {
        let key = ObjectIdentifier(type)
        
        switch scope {
        case .singleton:
            if singletons[key] != nil {
                print("Warning: \(type) is already registered as singleton.")
                return
            }
            singletons[key] = factory()
            
        case .transient:
            factories[key] = factory
        }
    }

    public func resolve<T>(_ type: T.Type = T.self) async throws -> T {
        let key = ObjectIdentifier(type)

        // Controlla se esiste un singleton registrato
        if let instance = singletons[key] as? T {
            return instance
        }
        
        // Controlla se esiste una factory registrata
        if let factory = factories[key] {
            return factory() as! T
        }
        
        // Se nessuna dipendenza è trovata, solleva un errore
        throw DIContainerError.dependencyNotFound(type: "\(type)")
    }
}

public enum DIContainerError: Error, CustomStringConvertible {
    case dependencyNotFound(type: String)

    public var description: String {
        switch self {
        case .dependencyNotFound(let type):
            return "Dependency of type \(type) not found in the container."
        }
    }
}
