//
//  Injected.swift
//  ActorDI
//
//  Created by OpenAI's assistant on 2025-04-23.
//

import Foundation
import Dispatch

/// A property wrapper that automatically resolves a dependency from the shared `DIContainer`.
///
/// Usage:
/// ```swift
/// await DIContainer.shared.register(Service.self) { ServiceImpl() }
/// @Injected var service: Service
/// service.greet()
/// ```
///
/// - Note: The wrapped value is resolved synchronously at initialization time. Accessing
///   a dependency that has not been registered will result in a runtime crash.
@propertyWrapper
public struct Injected<T: Sendable> {
    private let value: T

    public init() {
        var resolved: T?
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            resolved = try? await DIContainer.shared.resolve(T.self)
            semaphore.signal()
        }
        semaphore.wait()
        guard let value = resolved else {
            fatalError("Dependency of type \(T.self) not found in the container.")
        }
        self.value = value
    }

    public var wrappedValue: T { value }
}

