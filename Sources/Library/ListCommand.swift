/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

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
        var verbose = false
        var colorize  = false
        if input.flags.contains("verbose") { verbose = true }
        if input.flags.contains("colorize") { colorize = true }

        var profileURL: URL
        if let path = input.options["path"] {
            profileURL      = URL(fileURLWithPath: path)
        } else {
            let userHomeURL = URL(fileURLWithPath: NSHomeDirectory())
            profileURL      = userHomeURL.appendingPathComponent("Library/MobileDevice/Provisioning Profiles", isDirectory: true)            
        }
        
        do {
            let urls = try getProfileUrls(at: profileURL)

            for url in urls {
                if let data = try? Data(contentsOf: url) {
                    if var profile = try ProvisioningProfile.parse(from: data) {
                        profile.colorize = colorize
                        if verbose {
                            basicOutput.append(profile.verboseOutput)
                            basicOutput.append("\n")
                        } else {
                            basicOutput.append(profile.simpleOutput)
                        }
                     }
                }  
            }
        } catch {
            return CommandOutput(errorCode: .profileParsingError, basic: ["Error when parsing provisioning profiles."])
        }

        return CommandOutput(basic: basicOutput)
    }

    private func getProfileUrls(at: URL) throws -> [URL] {
        let fileManager = FileManager.default
        let urls = try fileManager.contentsOfDirectory(at: at, 
                                                        includingPropertiesForKeys: [],
                                                        options: [ .skipsSubdirectoryDescendants,
                                                                    .skipsHiddenFiles ] )
        var profileURLs: [URL] = []
        for url in urls {
            if url.pathExtension == "mobileprovision" {
                profileURLs.append(url)
            }
        }

        return profileURLs
    }
}
