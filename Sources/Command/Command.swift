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

public struct CommandSuccessInfo {
    var simpleOutput: [String] = []
    var verboseOutput: [String] = []
}

public struct CommandErrorReason {
    public var errorMessage: String
}

public protocol Command {
    var errorReason: CommandErrorReason? { get }
    var successInfo: CommandSuccessInfo?  { get }
    var arguments:   [String: String]    { get set }

    func isArgumentValid() -> Bool
    func isSuccessful() -> Bool
    mutating func execute() -> Bool
}

public struct CommandDispatcher  {
    let commandTable = ["list"]
    public static func handleCommand(_ name: String, with arguments: [String: String]) -> Command? {
        let lowercaseName = name.lowercased()
        var command: Command?

        switch lowercaseName {
            case "list":
                if arguments["target"]!.lowercased() == "profile" {
                    let userHomeURL = URL(fileURLWithPath: NSHomeDirectory())
                    let profileURL  = userHomeURL.appendingPathComponent("Library/MobileDevice/Provisioning Profiles", isDirectory: true)

                    command = ListCommand(arguments: arguments, path: profileURL)
                } else {
                    command = ListCommand(arguments: arguments)
                }

                let isVerbose = Bool(arguments["verbose"]!)
                
                if var unwrapped = command {
                    let status = unwrapped.execute()
                    if status {
                        if isVerbose! {
                            for output in unwrapped.successInfo!.verboseOutput {
                                print(output + "\n")
                            }
                        } else {
                            for output in unwrapped.successInfo!.simpleOutput {
                                print(output)
                            }
                        }
                        
                        
                    }
                }
            default:
                print("Unknown command")
        }

        return command
    }
    
}