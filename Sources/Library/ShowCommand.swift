/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files


// public struct ShowProfileInfoCommand: Command {
//     public func getError() -> [String] {
//         return errorReason.simple
//     }

//     public func getOutput(_ type: CommandOutputType) -> [String] {
//         switch type {
//             case .simple:
//                 return output.simple
//             case .verbose:
//                 return output.verbose
//         } 
//     }

//     public mutating func execute() -> Bool {

//     }
// }

public class ShowCommand: Command2 {
    public override class var assignedName: String {
        return "show"
    }

    public override func execute() -> CommandOutput2 {
        let subCommand = input.subCommand

        switch subCommand {
            case "info":
                return dispatch()
            default:
                return CommandOutput2(errorCode: .unknownCommand, basic: ["Unknown command"])
        }
    }

    private func dispatch() -> CommandOutput2 {
        let file = try! File(path: input.arguments.first!)    

        switch file.extension {
            case "ipa":
                return getIpaInfo()
            default:
                return CommandOutput2(errorCode: .invalidArgument, basic: ["File type not supported."])
        }
    }

    private func getIpaInfo() -> CommandOutput2 {
        var basicOutput: [String] = []

        do {
            let appFile = try File(path: input.arguments.first!)
            let groups  = try AppAnalyzer.getInfo(from: appFile)

            var combiInfo:[String] = []
            let formatter = OutputFormatter()
            for group in groups {
                combiInfo.append(contentsOf: formatter.strings(from: group))
            }
            basicOutput = combiInfo
        } catch {
            return CommandOutput2(errorCode: .ipaParsingError, basic: ["Error when parsing ipa."])
        }

        return CommandOutput2(basic: basicOutput)
    }
}