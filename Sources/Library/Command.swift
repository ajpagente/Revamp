/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public struct CommandInput { 
    let arguments: [String]      = []
    let options: [String:String] = [:]
    let flags: [String]          = []
    // let arguments: [String:String]
    public init() {}
}

public enum CommmandError: Error {
    case unknownCommand
    case argumentError
} 

public enum CommandOutputType {
    case simple
    case verbose
}

public struct CommandOutput {
    public var simple: [String]
    public var verbose: [String]
}

public struct CommandOutput2 {
    public let simple: [String]
    public let verbose: [String]

    public init(simple: [String], verbose: [String]) {
        self.simple  = simple
        self.verbose = verbose
    }

    public init() {
        self.init(simple: ["Unknown command"],
                  verbose: ["Unknown command"])
    }
}

public struct CommandErrorReason {
    var simple: [String] = []
}

public protocol Command {
    func getOutput(_ type: CommandOutputType) -> [String]
    func getError() -> [String]
    mutating func execute() -> Bool
}

public struct UnknownCommand: Command {
    public func getOutput(_ type: CommandOutputType) -> [String] { return ["Unknown command"] }
    public func getError() -> [String] { return ["Unknown command"] }
    public mutating func execute() -> Bool { return false }
}