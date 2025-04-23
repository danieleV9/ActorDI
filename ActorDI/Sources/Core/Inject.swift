//
//  Inject.swift
//  ActorDI
//
//  Created by Daniele Valentino on 23/04/25.
//

import Foundation

@propertyWrapper
public struct Inject<T> {
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


