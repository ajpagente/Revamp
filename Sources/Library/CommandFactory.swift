/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public struct CommandFactory {
    public init() { }

    public enum CommandType {
        // case info
        case list
        case sign
    }

    public func createCommand(ofType commandType: CommandType, withSubCommand subCommandName:String = "", 
                            arguments: [String:String]) -> Command {
        let command: Command

        switch commandType {
        // case .info:
            // let signCommandFactory = SignCommandFactory()
            // command = signCommandFactory.createSignCommand(for: subCommandName, arguments: arguments)

        case .list:
            let listCommandFactory = ListCommandFactory()
            command = listCommandFactory.createListCommand(for: subCommandName, arguments: arguments)

        case .sign:
            let signCommandFactory = SignCommandFactory()
            command = signCommandFactory.createSignCommand(for: subCommandName, arguments: arguments)

        default:
            command = UnknownCommand()    
        } 

        return command
    }
}