//
//  Inject.swift
//  ActorDI
//
//  Created by Daniele Valentino on 23/04/25.
//

import Foundation

/// A property wrapper that enables dependency injection for a given type.
///
/// The `Inject` property wrapper is intended to be used in conjunction with a dependency injection container.
/// It allows a property to be automatically resolved from the container when required, supporting asynchronous resolution.
///
/// Usage:
/// ```swift
/// @Inject var service: SomeService
/// ```
///
/// Before accessing the wrapped value, the dependency must be resolved using the provided `resolve(from:)` method:
/// ```swift
/// try await _$service.resolve(from: container)
/// ```
///
/// - Note: Accessing the wrapped value before resolving the dependency will cause a runtime error.
///
/// - Parameters:
///   - T: The type of the dependency to be injected.
@propertyWrapper
public struct Inject<T: Sendable> {
    private var value: T?

    public init() {}

    public mutating func resolve(from container: DIContainer) async throws {
        self.value = try await container.resolve(T.self)
    }

    public var wrappedValue: T {
        guard let value else {
            fatalError("Dependency not resolved.")
        }
        return value
    }
}


