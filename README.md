# ActorDI

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.2-orange.svg" alt="Swift 6.2" />
  <img src="https://img.shields.io/badge/Platforms-iOS%2016+-blue.svg" alt="Platforms" />
  <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="SPM" />
  <img src="https://img.shields.io/badge/Concurrency-Strict-purple.svg" alt="Strict Concurrency" />
</p>

**ActorDI** is a lightweight, actor-based Dependency Injection (DI) container for Swift. It leverages Swift's modern concurrency model to make dependency **registration** and **resolution** fully concurrency-safe — no locks, no semaphores, no data races.

## Why ActorDI?

Most DI containers were designed before Swift Concurrency and rely on manual locking to stay thread-safe. ActorDI takes a different approach: the container is a Swift `actor`, so the compiler guarantees safe access under strict concurrency checking. Combine that with the `@Inject` property wrapper and you get clean, declarative dependency injection that plays nicely with `async/await`.

## Features

- 🎭 **Actor-based** — registration and resolution are isolated to an actor, so they're concurrency-safe by construction.
- 🧬 **Two lifecycles** — register dependencies as `singleton` (shared instance) or `transient` (new instance per resolution).
- 🔒 **Type-safe resolution** — dependencies are resolved by their type with full generic type safety.
- ✨ **`@Inject` property wrapper** — resolve dependencies declaratively with a single annotation.
- ⚡ **Swift Concurrency native** — built on `async/await` and `Sendable`, ready for strict concurrency.
- 🪶 **Zero dependencies** — pure Swift, nothing else to pull in.

## Requirements

| Tool  | Version |
|-------|---------|
| Swift | 6.2+    |
| iOS   | 16.0+   |

## Installation

### Swift Package Manager

Add ActorDI to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/danieleV9/ActorDI.git", from: "1.0.0")
]
```

Then add it to your target's dependencies:

```swift
.target(
    name: "YourApp",
    dependencies: ["ActorDI"]
)
```

### Xcode

In Xcode, go to **File → Add Package Dependencies…** and enter the package URL:

```
https://github.com/danieleV9/ActorDI.git
```

## Usage

### 1. Define your dependencies

Dependencies should conform to `Sendable` (a protocol-oriented design is recommended):

```swift
protocol Service: Sendable {
    func greet() -> String
}

final class HelloService: Service {
    func greet() -> String { "Hello World" }
}
```

### 2. Register your dependencies

Use the shared container to register a factory for a given type and scope:

```swift
import ActorDI

// Register as a singleton — one shared instance for the app's lifetime
await DIContainer.shared.register(Service.self, scope: .singleton) {
    HelloService()
}

// Or register as transient — a new instance on every resolution
await DIContainer.shared.register(Service.self, scope: .transient) {
    HelloService()
}
```

### 3. Resolve your dependencies

#### Using `@Inject` (recommended)

The `@Inject` property wrapper resolves and injects the dependency from `DIContainer.shared`:

```swift
@Inject var service: Service
print(service.greet()) // "Hello World"
```

#### Resolving manually

You can also resolve dependencies directly from the container:

```swift
let service = try await DIContainer.shared.resolve(Service.self)
print(service.greet()) // "Hello World"
```

If the type was never registered, `resolve(_:)` throws `DIContainerError.dependencyNotFound`:

```swift
do {
    let service = try await DIContainer.shared.resolve(Service.self)
} catch DIContainerError.dependencyNotFound(let type) {
    print("Missing dependency: \(type)")
}
```

## Scopes

| Scope        | Behavior                                                                 |
|--------------|--------------------------------------------------------------------------|
| `.singleton` | A single instance is created at registration time and shared everywhere. |
| `.transient` | A fresh instance is created from the factory on every resolution.        |

> [!NOTE]
> Registering the same type **again** as a `.singleton` is ignored (a warning is printed), so the original instance is preserved. Re-registering as `.transient` replaces the existing factory.

## API Reference

### `DIContainer`

The actor that stores and resolves dependencies. Access the default instance through `DIContainer.shared`.

| Member | Description |
|--------|-------------|
| `register(_:scope:factory:)` | Registers a factory for a type with the given scope (defaults to `.transient`). |
| `resolve(_:)` | Asynchronously resolves an instance of the requested type. Throws if not found. |
| `resetAll()` | Removes all registered singletons and factories. Useful for testing. |

### `@Inject`

A property wrapper that asynchronously resolves a dependency of type `T` from `DIContainer.shared`. The generic type must conform to `Sendable`.

> [!WARNING]
> If the dependency cannot be resolved, `@Inject` triggers a `fatalError`. Make sure the type is registered before injecting it. When you need graceful error handling, use `DIContainer.shared.resolve(_:)` directly.

### `DIScope`

An enum describing a dependency's lifetime: `.singleton` or `.transient`.

### `DIContainerError`

An error type thrown during resolution. Currently provides `.dependencyNotFound(type:)`.

## Testing

ActorDI is test-friendly. Call `resetAll()` between tests to start from a clean container:

```swift
import Testing
@testable import ActorDI

@Suite(.serialized)
struct MyServiceTests {

    init() async {
        await DIContainer.shared.resetAll()
    }

    @Test
    func resolvesRegisteredService() async throws {
        await DIContainer.shared.register(Service.self, scope: .singleton) {
            HelloService()
        }

        @Inject var service: Service
        #expect(service.greet() == "Hello World")
    }
}
```

Run the test suite with:

```bash
swift test
```

## Author

Created and maintained by [Daniele Valentino](https://github.com/danieleV9).

Contributions, issues, and feature requests are welcome!
