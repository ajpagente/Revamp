/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public struct CommandInput {
    let subCommand: String
    let arguments:  [String]
    let options:    [String:String]
    let flags:      [String]

    public init(subCommand: String, arguments: [String], 
                options: [String:String], flags: [String]) {
        self.subCommand = subCommand
        self.arguments  = arguments
        self.options    = options
        self.flags      = flags 
    }
}

public enum CommmandError: Error {
    case unknownCommand
    case argumentError
} 

public enum CommandOutputType {
    case simple
    case verbose
}

public enum CommandStatus {
    case success
    case fail
}

public enum CommandErrorCode {
    case fileNotFound
    case invalidArgument
    case ipaParsingError
    case profileParsingError
    case unknownCommand
    case unknownError
    case noError
}

public struct CommandOutput {
    public var status: CommandStatus
    public var errorCode: CommandErrorCode
    public var basic  = [""]
    public var detail = [""]

    public init(basic: [String]) {
        self.status    = .success
        self.errorCode = .noError
        self.basic     = basic
    }

    public init(errorCode: CommandErrorCode, basic: [String]) {
        self.status    = .fail
        self.errorCode = errorCode
        self.basic     = basic
    }
}

public struct CommandErrorReason {
    var simple: [String] = []
}

open class Command2 {
    open class var assignedName: String {
        return "unknown"
    }

    public final let name: String
    public final let input: CommandInput

    public required init(input: CommandInput) {
        self.name = type(of: self).assignedName
        self.input = input
    }

    public convenience init() {
        let input = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])
        self.init(input: input)
    }

    open func execute() -> CommandOutput {
        return CommandOutput(errorCode: .unknownCommand, basic: ["Unknown command"])
    }
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