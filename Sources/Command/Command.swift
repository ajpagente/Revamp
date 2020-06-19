/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public struct CLI {
    let command:    String
    let subCommand: String?
    let arguments: [String:String]
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
    var simple: [String] = []
    var verbose: [String] = []
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