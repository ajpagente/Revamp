/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Library

public struct SignCommand: Command {
    private var errorReason = CommandErrorReason(simple: [])
    private var output      = CommandOutput(simple: [], verbose: [])
    private var arguments   = ["":""]  
    private var appName     = ""
    private let subCommand: SubCommand

    public init(_ subCommand: SubCommand, with arguments: [String:String]) {
        self.subCommand = subCommand
        self.arguments  = arguments
    }
    
    public enum SubCommand {
        case display
        case verify
    }

    public func getError() -> [String] {
        return errorReason.simple
    }

    public func getOutput(_ type: CommandOutputType) -> [String] {
        switch type {
            case .simple:
                return output.simple
            case .verbose:
                return output.verbose
        } 
    }

    public mutating func execute() -> Bool {
        self.output = SystemCommand.FileInfo(of: arguments["file"]!)
        return true
    }
}