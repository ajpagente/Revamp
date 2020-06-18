/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

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