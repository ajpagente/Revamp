/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public struct ListCommandFactory {
    public func createListCommand(for subcommandName: String, arguments: [String:String]) -> ListCommand {
        let listCommand: ListCommand

        switch subcommandName {
        case "profile":
            let userHomeURL = URL(fileURLWithPath: NSHomeDirectory())
            let profileURL  = userHomeURL.appendingPathComponent("Library/MobileDevice/Provisioning Profiles", isDirectory: true)

            listCommand = ListCommand(path: profileURL)
        default:
            listCommand = ListCommand(path: URL(fileURLWithPath: ""))
        }

        return listCommand
    }
}