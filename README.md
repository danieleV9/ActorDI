# ActorDI

**ActorDI** è un framework per la dependency injection in Swift, progettato per essere semplice da usare in contesti asincroni e modulari.

## 🚀 Features

- Supporto a `@propertyWrapper` per injection semplice (`Inject<T>`)
- Scope configurabili (singleton, transient, ecc.)
- `async/await` compatibile

## 🛠 Esempio di utilizzo

```swift
let container = DIContainer()

await container.register(Service.self, scope: .singleton) {
    HelloService()
}

var serviceWrapper = Inject<Service>()
try await serviceWrapper.resolve(from: container)

print(serviceWrapper.wrappedValue.greet()) // "Hello World"
