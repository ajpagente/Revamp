/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

// Workspace creates folders for a command to use for its operations.
public struct Workspace {
    public let baseFolder   : Folder
    public let outputFolder : Folder
    public let inputFolder  : Folder
    private let tempFolder  : Folder

    public enum Destination {
        case input
        case output
        case temporary
    }
    public init() throws {
        let randomFolder = UUID().uuidString
        baseFolder   = try Folder.temporary.createSubfolder(named: randomFolder)
        inputFolder  = try baseFolder.createSubfolder(named: "in")
        outputFolder = try baseFolder.createSubfolder(named: "out")
        tempFolder   = try baseFolder.createSubfolder(named: "tmp")
    }

    public func writeFile(_ file: File, to destination: Destination, decompress: Bool = false) throws {
        switch destination {
            case .input:
                try file.copy(to: inputFolder)
            case .output:
                try file.copy(to: outputFolder)
            case .temporary:
                try file.copy(to: tempFolder)
        }
    } 

    // public func moveOutput(to destination: String) {

    // }

    // public func wipe() {

    // }
}