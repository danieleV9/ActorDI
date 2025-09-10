//
//  ActorDITests.swift
//  ActorDITests
//
//  Created by Daniele Valentino on 23/04/25.
//

import Testing
@testable import ActorDI

struct ActorDITests {

    @Test
    func testAutoInjectedPropertyWrapper() async {
        DIContainer.shared = DIContainer()
        await DIContainer.shared.register(Service.self, scope: .singleton) {
            HelloService()
        }

        @Injected var service: Service

        #expect(service.greet() == "Hello World")
    }
    
    @Test
    func testResolutionFailsForUnregisteredType() async {
        let container = DIContainer()
        var wrapper = Inject<CiaoService>()

        await #expect(throws: DIContainerError.self) {
            try await wrapper.resolve(from: container)
        }
    }


}

protocol Service: Sendable {
    func greet() -> String
}

final class HelloService: Service {
    func greet() -> String {
        return "Hello World"
    }
}

final class CiaoService: Service {
    func greet() -> String {
        return "Ciao Mondo"
    }
}

