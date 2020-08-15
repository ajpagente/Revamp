/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files


public class ShowCommand: Command {
    private var basicOutput: [String] = []
    private var groups: [OutputGroup] = []
    private var verbose: Bool {
        return input.flags.contains("verbose")
    }
    private var colorize: Bool {
        return input.flags.contains("colorize")
    }
    private var translationFile: File? {
        if let translationPath = input.options["translation-path"] {
            do { 
                return try File(path: translationPath)
            } catch {
                return nil
            }
        } 
        return nil
    }

    public override class var assignedName: String {
        return "show"
    }

    public override func execute() -> CommandOutput {
        let subCommand = input.subCommand

        switch subCommand {
            case "info":
                return dispatch()
            default:
                return CommandOutput(errorCode: .unknownCommand, basic: ["Unknown command"])
        }
    }

    private func dispatch() -> CommandOutput {
        do {
            let file = try File(path: input.arguments.first!)
            switch file.extension {
            case "ipa":
                return getIpaInfo(file)
            case "mobileprovision":
                return getProfileInfo(file)
            default:
                return CommandOutput(errorCode: .invalidArgument, basic: ["File type not supported."])
            }
        } catch {
            return CommandOutput(errorCode: .invalidArgument, basic: ["File not found or the file is corrupt."])
        }
    }

    private func getIpaInfo(_ file: File) -> CommandOutput {
        do {
            if verbose { 
                groups  = try AppAnalyzer.getAllInfo(from: file, colorize: colorize, translateWith: translationFile) 
            } else {
                groups  = try AppAnalyzer.getLimitedInfo(from: file, colorize: colorize)
            }
            basicOutput = formatOutput(groups)
        } catch {
            print("\(error)")
            return CommandOutput(errorCode: .ipaParsingError, basic: ["Error when parsing ipa."])
        }

        return CommandOutput(basic: basicOutput)
    }

    private func getProfileInfo(_ file: File) -> CommandOutput {
        do {
            if verbose { 
                groups  = try ProfileAnalyzer.getAllInfo(from: file, colorize: colorize, translateWith: translationFile) 
            } else {
                groups  = try ProfileAnalyzer.getLimitedInfo(from: file, colorize: colorize)
            }
            basicOutput = formatOutput(groups)
        } catch {
            print("\(error)")
            return CommandOutput(errorCode: .ipaParsingError, basic: ["Error when parsing profile."])
        }

        return CommandOutput(basic: basicOutput)
    }

    private func formatOutput(_ groups: [OutputGroup]) -> [String] {
        var formatted:[String] = []
        let formatter = OutputFormatter()
        for group in groups {
            formatted.append(contentsOf: formatter.strings(from: group))
        }
        return formatted
    }
}