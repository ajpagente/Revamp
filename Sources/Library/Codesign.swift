/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

public protocol SigningEngine {
    var certificate: String { get  }
    var entitlementsPlist: File { get }
    func sign(folder: Folder) throws -> Bool
    func sign(file: File) throws -> Bool
}

public struct DefaultSigningEngine: SigningEngine {
    public var certificate: String
    public var entitlementsPlist: File

    public func sign(folder: Folder) throws -> Bool {
        let out: ProcessOutput = Process().execute("/usr/bin/codesign", arguments: ["--continue", "-f", "-s", certificate, 
                                    "--entitlements", entitlementsPlist.path, folder.path])
        if out.status == 0 { return true }
        return false
    }

    public func sign(file: File) throws -> Bool {
        let out: ProcessOutput = Process().execute("/usr/bin/codesign", arguments: ["--continue", "-f", "-s", certificate, 
                                    "--entitlements", entitlementsPlist.path, file.path])
        if out.status == 0 { return true }
        return false
    }

}

public struct Signer {
    @discardableResult
    public static func sign(_ file: File, using engine: SigningEngine) throws -> Bool {
        let workspace = try Workspace()
        try workspace.writeFile(file, to: .input, decompress: true)

        let foldersToSign = workspace.inputFolder.findSubfolders(withExtension: [".app", "*.appex", ".framework"])
        for folder in foldersToSign {
            let _ = try engine.sign(folder: folder)
        }

        let resignedFileName    = "rv_\(file.name)"
        try workspace.compressFolder(workspace.inputFolder, to: .output, with: resignedFileName)
        try workspace.copyFileFromOutput(named: resignedFileName, to: file.parent!)
        return true
    }
}