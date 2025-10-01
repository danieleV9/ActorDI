//
//  ActorDITests.swift
//  ActorDITests
//
//  Created by Daniele Valentino on 23/04/25.
//

import Testing
@testable import ActorDI

@Suite(.serialized)
struct ActorDITests {
    
    let container = DIContainer.shared
    
    init() async {
        await DIContainer.shared.resetAll()
    }
    
    @Test
    func testSuccessfulResolutionForSingletion() async throws {
        
        await container.register(Service.self, scope: .singleton) {
            HelloService()
        }
        
        @Inject var service: Service
        #expect(service.greet() == "Hello World")
    }
    
    @Test
    func testSuccessfulResolutionForTransient() async throws {
        
        await container.register(Service.self, scope: .transient) {
            HelloService()
        }

        @Inject var service: Service
        #expect(service.greet() == "Hello World")
    }
    
    @Test
    func testResolutionForDoubleTransientRegistration() async throws {
        
        await container.register(Service.self, scope: .transient) {
            HelloService()
        }

        @Inject var service1: Service
        #expect(service1.greet() == "Hello World")
        
        await container.register(Service.self, scope: .transient) {
            CiaoService()
        }

        @Inject var service2: Service
        #expect(service2.greet() == "Ciao Mondo")
    }
    
    @Test
    func testResolutionForDoubleSingletonRegistration() async throws {
        
        await container.register(Service.self, scope: .singleton) {
            HelloService()
        }

        @Inject var service1: Service
        #expect(service1.greet() == "Hello World")
        
        await container.register(Service.self, scope: .singleton) {
            CiaoService()
        }

        #expect(service1.greet() == "Hello World")
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

