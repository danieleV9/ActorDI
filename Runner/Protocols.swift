//
//  Protocols.swift
//  Runner
//
//  Created by Daniele Valentino on 23/04/25.
//

import Foundation

protocol Service {
    func greet() -> String
}

protocol Clock {
    func currentTime() -> String
}

class HelloService: Service {
    func greet() -> String {
        return "Hello World"
    }
}

class CiaoService: Service {
    func greet() -> String {
        return "Ciao Mondo"
    }
}
