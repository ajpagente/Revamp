/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public class ListCommand2: Command2 {
    public override class var assignedName: String {
        return "list"
    }

    public override func execute() -> CommandOutput2 {
        let subCommand = input.subCommand

        switch subCommand {
            case "profile":
                return listDefaultProfiles()
            default:
                return CommandOutput2(errorCode: .unknownCommand, basic: ["Unknown command"])
        }
    }

    private func listDefaultProfiles() -> CommandOutput2 {
        var basicOutput: [String] = []
        var verbose = false
        var colorize  = false
        if input.flags.contains("verbose") { verbose = true }
        if input.flags.contains("colorize") { colorize = true }

        let userHomeURL = URL(fileURLWithPath: NSHomeDirectory())
        let profileURL  = userHomeURL.appendingPathComponent("Library/MobileDevice/Provisioning Profiles", isDirectory: true)

        do {
            let fileManager = FileManager.default
            let urls = try fileManager.contentsOfDirectory(at: profileURL, 
                                                           includingPropertiesForKeys: [],
                                                           options: [ .skipsSubdirectoryDescendants,
                                                                      .skipsHiddenFiles ] )

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
            return CommandOutput2(errorCode: .profileParsingError, basic: ["Error when parsing provisioning profiles."])
        }

        return CommandOutput2(basic: basicOutput)
    }
}
