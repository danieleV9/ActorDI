//
//  MainNew.swift
//  Runner
//
//  Created by Daniele Valentino on 23/04/25.
//

import Foundation
import ActorDI

@main
struct MainNew {
    static func main() async {
        let container = DIContainer()

        await container.register(Service.self, scope: .singleton) {
            HelloService()
        }

        async let task1: Void = {
            var serviceWrapper = Inject<Service>()
            do {
                try await serviceWrapper.resolve(from: container)
                print("Task 1: \(serviceWrapper.wrappedValue.greet())")
            } catch let error as DIContainerError {
                print("Task 1 - DIContainer error: \(error.description)")
            } catch {
                print("Task 1 - Error: \(error)")
            }
        }()

        async let task2: Void = {
            var serviceWrapper = Inject<Service>()
            do {
                try await serviceWrapper.resolve(from: container)
                print("Task 2: \(serviceWrapper.wrappedValue.greet())")
            } catch let error as DIContainerError {
                print("Task 2 - DIContainer error: \(error.description)")
            } catch {
                print("Task 2 - Error: \(error)")
            }
        }()

        _ = await (task1, task2)

        // Try to resolve a type that hasn't been registered
        var unknownWrapper = Inject<Clock>()
        do {
            try await unknownWrapper.resolve(from: container)
            print(unknownWrapper.wrappedValue.currentTime())
        } catch let error as DIContainerError {
            print("DIContainer error: \(error.description)")
        } catch {
            print("Error: \(error)")
        }
    }
}
