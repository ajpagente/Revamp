/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

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
        let input = CommandInput()
        self.init(input: input)
    }

    open func execute() -> CommandOutput2 {
        return CommandOutput2()
    }
}

public class CommandEngine {
    public let commandHandler: CommandHandler

    public init(handler: CommandHandler) {
        self.commandHandler = handler
    }

    public func execute(_ name: String, input: CommandInput) -> CommandOutput2 {
        guard let command = commandHandler.handleCommand(name, input: input) 
            else {
                print("Unknown command")
                return CommandOutput2()
        }

        return command.execute()
    }
}

public protocol CommandHandlerProtocol {
    var next: CommandHandlerProtocol? { get }
    func handleCommand(_ name: String, input: CommandInput) -> Command2?
}

public class CommandHandler {
    public var next: CommandHandlerProtocol?
    public let commandType: Command2.Type
    public let commandName: String
    
    public init(commandType: Command2.Type) {
        self.commandType = commandType
        self.commandName = commandType.assignedName
    }
}

extension CommandHandler: CommandHandlerProtocol {
    public func handleCommand(_ name: String, input: CommandInput) -> Command2? {
        guard let command = createCommand(name, input: input) else {
            return next?.handleCommand(name, input: input)
        }
        return command
    }

    private func createCommand(_ name: String, input: CommandInput) -> Command2? {
        if commandName != name { return nil } 

        let command = commandType.init(input: input)
        return command
    }   
}