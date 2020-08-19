/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation


open class Command {
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
    return CommandOutput(errorCode: .unknownCommand, message: ["Unknown command"])
  }
}

public struct CommandInput {
  let subCommand: String
  let arguments:  [String]
  let options:    [String:String]
  let flags:      [String]

  public init(subCommand: String, 
              arguments: [String], 
              options: [String:String], 
              flags: [String]) {
    self.subCommand = subCommand
    self.arguments  = arguments
    self.options    = options
    self.flags      = flags 
  }
}

public struct CommandOutput {
  public let status: CommandStatus
  public let errorCode: CommandErrorCode
  public let message: [String]

  public init(message: [String]) {
    self.status    = .success
    self.errorCode = .noError
    self.message   = message
  }

  public init(errorCode: CommandErrorCode, message: [String]) {
    self.status    = .fail
    self.errorCode = errorCode
    self.message   = message
  }
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