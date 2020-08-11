/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files


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
            case "mobileprovision":
                return getProfileInfo()
            default:
                return CommandOutput2(errorCode: .invalidArgument, basic: ["File type not supported."])
        }
    }

    private func getIpaInfo() -> CommandOutput2 {
        var basicOutput: [String] = []
        var groups: [OutputGroup] = []
        var verbose = false
        var colorize = false
        if input.flags.contains("verbose") { verbose = true }
        if input.flags.contains("colorize") { colorize = true }
        var translationFile: File? 
        if let translationPath = input.options["translation-path"] {
            do { 
                translationFile = try File(path: translationPath)
            } catch {
                translationFile = nil
            }
        }

        do {
            let appFile = try File(path: input.arguments.first!)
            // let groups  = try AppAnalyzer.getInfo(from: appFile)
            if verbose { 
                groups  = try AppAnalyzer.getAllInfo(from: appFile, colorize: colorize, translateWith: translationFile) 
            } else {
                groups  = try AppAnalyzer.getLimitedInfo(from: appFile, colorize: colorize)
            }

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

    private func getProfileInfo() -> CommandOutput2 {
        var basicOutput: [String] = []
        var groups: [OutputGroup] = []
        var verbose  = false
        var colorize = false
        if input.flags.contains("verbose")  { verbose = true }
        if input.flags.contains("colorize") { colorize = true }
        var translationFile: File? 
        if let translationPath = input.options["translation-path"] {
            do { 
                translationFile = try File(path: translationPath)
            } catch {
                translationFile = nil
            }
        }

        do {
            let profileFile = try File(path: input.arguments.first!)
            if verbose { 
                groups  = try ProfileAnalyzer.getAllInfo(from: profileFile, colorize: colorize, translateWith: translationFile) 
            } else {
                groups  = try ProfileAnalyzer.getLimitedInfo(from: profileFile, colorize: colorize)
            }

            var combiInfo:[String] = []
            let formatter = OutputFormatter()
            for group in groups {
                combiInfo.append(contentsOf: formatter.strings(from: group))
            }
            basicOutput = combiInfo
        } catch {
            print("\(error)")
            return CommandOutput2(errorCode: .ipaParsingError, basic: ["Error when parsing profile."])
        }

        return CommandOutput2(basic: basicOutput)
    }
}