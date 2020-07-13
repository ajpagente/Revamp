/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Command
import Files

public protocol SigningEngine {
    var certificate: String { get  }
    var entitlementsPlist: File { get set }
    func sign() throws -> Bool
}

public struct Signer {
    @discardableResult
    public static func sign(_ file: File, using engine: SigningEngine) throws -> Bool {
        let workspace = try Workspace()
        try workspace.writeFile(file, to: .input, decompress: true)

        let foldersToSign = workspace.inputFolder.findSubfolders(withExtension: [".app", "*.appex", ".framework"])
        let appFolder = getAppFolder(from: workspace.inputFolder)
        let entitlementsPlist = try createEntitlementsPlist(named: "entitlements.plist",
                                                       from: appFolder,
                                                       to: workspace.tempFolder)
        // engine.entitlementsPlist = entitlementsPlist
        // for folder in foldersToSign {
        //     let _ = try engine.sign()
        // }

        let resignedFileName    = "rv_\(file.name)"
        try workspace.compressFolder(workspace.inputFolder, to: .output, with: resignedFileName)
        try workspace.copyFileFromOutput(named: resignedFileName, to: file.parent!)
        return true
    }
}

private extension Signer {
    static func getAppFolder(from folder: Folder) -> Folder {
        let appFolder = folder.findSubfolders(withExtension: [".app"])
        return appFolder.first!
    }

    static func createEntitlementsPlist(named name: String, from appFolder: Folder, 
                                        to destinationFolder: Folder) throws -> File {
        let embeddedMobileProvision = appFolder.path + "embedded.mobileprovision"
        let out = Process().execute("/usr/bin/security", arguments: ["cms", "-D", "-i", embeddedMobileProvision])

        let profilePlist = try destinationFolder.createFile(at: "profile.plist", contents: out.output.data(using: .utf8))
        let entitlementContent = Process().execute("/usr/libexec/PlistBuddy", arguments: ["-x", "-c", "Print:Entitlements", profilePlist.path])
        let entitlementsPlist = try destinationFolder.createFile(named: name, contents: entitlementContent.output.data(using: .utf8))

        return entitlementsPlist
    }
}