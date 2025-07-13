//
//  DIScope.swift
//  ActorDI
//
//  Created by Daniele Valentino on 23/04/25.
//

import Foundation

/// Represents the lifetime scope of a dependency within the dependency injection system.
///
/// - `singleton`: The dependency is shared across the entire application lifetime. Only one instance is created and reused.
/// - `transient`: A new instance of the dependency is created every time it is requested.
public enum DIScope {
    case singleton
    case transient
}
