/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files


public class ListCommand: Command {
    public override class var assignedName: String {
        return "list"
    }

    public override func execute() -> CommandOutput {
        let subCommand = input.subCommand

        switch subCommand {
            case "profile":
                return listProfiles()
            default:
                return CommandOutput(errorCode: .unknownCommand, basic: ["Unknown command"])
        }
    }

    private func listProfiles() -> CommandOutput {
        var basicOutput: [String] = []
        let verbose   = input.flags.contains("verbose")
        let colorize  = input.flags.contains("colorize")

        do {
            var profileFolder: Folder
            if let path = input.options["path"] {
                profileFolder = try Folder(path: path)
            } else {
                profileFolder = try Folder.home.subfolder(at: "Library/MobileDevice/Provisioning Profiles")
            }
        
            let files = profileFolder.files

            for file in files {
                if file.extension == "mobileprovision" {
                    if verbose {
                        let infoGroup = try ProfileAnalyzer.getProfileInfo(from: file, colorize: colorize)
                        basicOutput.append(contentsOf: formatOutput(infoGroup))
                        basicOutput.append("\n")
                    } else {
                        let nameUUID = try ProfileAnalyzer.getNameUUID(from: file)
                        basicOutput.append(nameUUID)
                    }                    
                }
            }
        } catch {
            return CommandOutput(errorCode: .profileParsingError, basic: ["Error when parsing provisioning profiles."])
        }

        return CommandOutput(basic: basicOutput)
    }

    private func formatOutput(_ group: OutputGroup) -> [String] {
        var formatted:[String] = []
        let formatter = OutputFormatter()
        return formatter.strings(from: group)
    }
}
