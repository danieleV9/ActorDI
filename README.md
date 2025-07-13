# ActorDI

ActorDI is an actor-based Dependency Injection (DI) container for Swift, designed to leverage the concurrency safety of actors for dependency registration and resolution.

## Features
- **Simple registration** of dependencies as singletons or transients
- **Type-safe resolution** of dependencies
- **Swift Concurrency compatibility** via actors
- **`@Inject` property wrapper** for automatic injection

## Installation

Add ActorDI to your `Package.swift`:
```swift
.package(url: "https://github.com/danieleV9/ActorDI", from: "1.0.0")
