/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

public struct ShowCommandFactory {
    public func createCommand(for subcommandName: String, arguments: [String:String]) -> ShowCommand {
        let showCommand: ShowCommand

        switch subcommandName {
        case "info":
            showCommand = ShowCommand(.info, with: arguments)
        default:
            showCommand = ShowCommand(.info, with: arguments)
        }

        return showCommand
    }
}

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
                do {
                    let appFile = try File(path: arguments["file"]!)
                    let groups  = try AppAnalyzer.getInfo(from: appFile)

                    var combiInfo:[String] = []
                    let formatter = OutputFormatter()
                    for group in groups {
                        combiInfo.append(contentsOf: formatter.strings(from: group))
                    }
                    self.output = CommandOutput(simple: combiInfo, 
                                                verbose: combiInfo)
                } catch {
                    self.output = CommandOutput(simple:  ["Error getting file info!!!"], 
                                                verbose: ["Error getting file info!!!"])
                }

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