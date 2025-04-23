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

        var serviceWrapper = Inject<Service>()

        do {
            try await serviceWrapper.resolve(from: container)
            print(serviceWrapper.wrappedValue.greet())  // Output: Hello World
        } catch let error as DIContainerError {
            print("Errore DIContainer: \(error.description)")
        } catch {
            print("Errore generico: \(error)")
        }

        // Caso di errore: CiaoService non è registrato
        var unknownWrapper = Inject<CiaoService>()
        do {
            try await unknownWrapper.resolve(from: container)
            print(unknownWrapper.wrappedValue.greet())
        } catch let error as DIContainerError {
            print("Errore DIContainer: \(error.description)")
        } catch {
            print("Errore generico: \(error)")
        }
    }
}
