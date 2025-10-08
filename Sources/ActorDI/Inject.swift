//
//  Inject.swift
//  ActorDI
//
//  Created by Daniele Valentino on 23/04/25.
//

import Foundation

/// A property wrapper that lazily resolves and caches a dependency from the shared dependency container.
///
/// Use `@Inject` on a stored property to automatically fetch an instance of the requested type `T`
/// from `DIContainer.shared` the first time the property is accessed. The resolved instance is cached
/// for subsequent accesses.
///
/// - Warning: If `DIContainer.shared.resolve(_:)` throws or returns `nil`, this wrapper triggers
///   a `fatalError` with a message indicating the missing dependency type.
///
/// - Note: The generic type `T` must conform to `Sendable`.
///
/// - Requires: A properly configured `DIContainer.shared` that can resolve the requested type.
///
/// Example usage:
/// ```swift
/// final class FeatureService {
///     @Inject var repository: Repository // Repository must be registered in DIContainer
///
///     func load() {
///         // On first access, `repository` is resolved and cached.
///         repository.fetch()
///     }
/// }
/// ```
///
/// Thread-safety:
/// - The initial resolution is isolated to DIContainer actor.
/// - Subsequent accesses return the cached instance without additional synchronization.
///
/// Caching behavior:
/// - The resolved instance is stored in the wrapper’s private storage and reused for the lifetime
///   of the wrapper’s owning instance.

@propertyWrapper
public struct Inject<T: Sendable> {

    public var wrappedValue: T
    
    public init() async {
        guard let instance = try? await DIContainer.shared.resolve(T.self) else {
            fatalError("Dependency not found for \(T.self)")
        }
        wrappedValue = instance
    }
    
}

