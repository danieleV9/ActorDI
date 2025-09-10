//
//  DIContainerError.swift
//  ActorDI
//
//  Created by Daniele Valentino on 11/09/25.
//


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

public enum DIContainerError: Error, CustomStringConvertible {
    case dependencyNotFound(type: String)

    public var description: String {
        switch self {
        case .dependencyNotFound(let type):
            return "Dependency of type \(type) not found in the container."
        }
    }
}
