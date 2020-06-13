/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

public enum CommmandError: Error {
    case unknownCommand
    case argumentError
} 

public struct CommandSuccessInfo {
    var simpleOutput: String
    var verboseOuput: String 
}

public struct CommandErrorReason {
    public var errorMessage: String
}

public protocol Command {
    var errorReason: CommandErrorReason? { get }
    var successInfo: CommandSuccessInfo? { get }
    var arguments:   [String: String]    { get set }

    func isArgumentValid() -> Bool
    func isSuccessful() -> Bool
    func execute() -> Bool
}

public struct CommandDispatcher  {
    let commandTable = ["list"]
    public static func handleCommand(_ name: String, with arguments: [String: String]) -> Command? {
        let lowercaseName = name.lowercased()
        var command: Command?

        switch lowercaseName {
            case "list":
                command = ListCommand(arguments: arguments)
                if let unwrapped = command {
                    unwrapped.execute()
                }
            default:
                print("Unknown command")
        }

        return command
    }
    
}