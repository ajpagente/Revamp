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
                return CommandOutput(errorCode: .unknownCommand, message: ["Unknown command"])
        }
    }

    private func listProfiles() -> CommandOutput {
        var basicOutput: [String] = []
        let verbose   = input.flags.contains("verbose")
        let colorize  = input.flags.contains("colorize")
        var hasPath = false

        do {
            var profileFolder: Folder
            if let path = input.options["path"] {
                profileFolder = try Folder(path: path)
                hasPath = true
            } else {
                profileFolder = try Folder.home.subfolder(at: "Library/MobileDevice/Provisioning Profiles")
            }
        
            let files = profileFolder.files

            for file in files {
                if file.extension == "mobileprovision" {
                    if verbose {
                        let groups = try ProfileAnalyzer.getProfileInfo(from: file, colorize: colorize)
                        let outputGroups = OutputGroups(groups)
                        basicOutput.append(contentsOf: formatOutput(outputGroups.groups))
                        basicOutput.append("\n")
                    } else {
                        var profileInfo: String
                        
                        if hasPath {
                            profileInfo = try ProfileAnalyzer.getFileNameUUID(from: file)
                        } else {
                            profileInfo = try ProfileAnalyzer.getNameUUID(from: file)
                        }
                        basicOutput.append(profileInfo)
                    }                    
                }
            }
        } catch {
            return CommandOutput(errorCode: .profileParsingError, message: ["Error when parsing provisioning profiles."])
        }

        return CommandOutput(message: basicOutput)
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
