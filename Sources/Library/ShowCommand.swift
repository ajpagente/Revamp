/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

public struct ShowCommand: Command {
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
        case info
        // case entitlement
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
        switch subCommand {
            case .info:
                self.output = CommandOutput(simple:  ["Info is not implemented yet!!!"], 
                                            verbose: ["Info is not implemented yet!!!"])
            // case .entitlement:               
       
        }
        
        return true
    }

    private func getEntitlements(from ipaFile: File) throws -> File {
        let workspace = try Workspace()
        try workspace.writeFile(ipaFile, to: .input, decompress: true)

        let appFolder = workspace.inputFolder.findSubfolders(withExtension: [".app"])
        let embeddedProfileFile = try appFolder.first!.file(named: "embedded.mobileprovision")

        let data = try Data(contentsOf: embeddedProfileFile.url)
        let profile = try ProvisioningProfile.parse(from: data)

        let entitlementsPlistPath = workspace.outputFolder.path + "entitlements.plist"
        try profile!.writeEntitlementsPlist(to: entitlementsPlistPath)
        return try File(path: entitlementsPlistPath)
    }
}