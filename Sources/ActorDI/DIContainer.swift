//
//  DIContainer.swift
//  ActorDI
//
//  Created by Daniele Valentino on 23/04/25.
//

import Foundation

/// An actor-based Dependency Injection (DI) container for managing and resolving dependencies.
///
/// `DIContainer` allows you to register dependencies with different lifecycles (singleton or transient)
/// and resolve them in a type-safe manner. Registration and resolution are concurrency-safe
/// due to the use of Swift actors.
///
/// Example usage:
/// ```swift
/// let container = DIContainer()
/// await container.register(ServiceA.self, scope: .singleton) { ServiceA() }
/// let service = try await container.resolve(ServiceA.self)
/// ```
///
/// - Important: `DIContainer` uses `ObjectIdentifier` to uniquely identify types.
///   Registering the same type multiple times as a singleton will print a warning and ignore
///   the subsequent registration.
/// - Warning: Registering or resolving types that are not reference types or that don't conform
///   to expected protocols may result in type erasure at runtime. Always prefer using protocols or classes.
///
/// Thread Safety:
/// - All interactions are protected by the actor's concurrency model.
/// - Registered singletons are stored internally and reused across resolutions.
/// - Transient registrations provide a new instance for each resolution.
///
/// See Also:
/// - `DIScope` for available registration lifecycles.
/// - `DIContainerError` for error scenarios.
public actor DIContainer {
    /// Shared global container used by the `@Injected` property wrapper.
    public static var shared = DIContainer()
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

        if let instance = singletons[key] as? T {
            return instance
        }

        if let factory = factories[key], let instance = factory() as? T {
            return instance
        }

        throw DIContainerError.dependencyNotFound(type: "\(type)")
    }
}

/// Errors that can occur during dependency resolution in `DIContainer`.
///
/// `DIContainerError` describes the possible failure scenarios when interacting with a `DIContainer`,
/// such as failing to find a registered dependency of a specified type.
///
/// - `dependencyNotFound(type:)`: Thrown when attempting to resolve a dependency that has not been registered
///    in the container. The associated value provides a string representation of the missing type.
///
/// Example usage:
/// ```swift
/// do {
///     let resolved: ServiceA = try await container.resolve(ServiceA.self)
/// } catch DIContainerError.dependencyNotFound(let type) {
///     print("Dependency for \(type) not found.")
/// }
/// ```
///
/// Conforms to:
/// - `Error`: Enables use with Swift error handling.
/// - `CustomStringConvertible`: Provides a human-readable description of the error.
///
/// See Also:
/// - `DIContainer.resolve(_: )`
/// - `DIContainer`
public enum DIContainerError: Error, CustomStringConvertible {
    case dependencyNotFound(type: String)

    public var description: String {
        switch self {
        case .dependencyNotFound(let type):
            return "Dependency of type \(type) not found in the container."
        }
    }
}
