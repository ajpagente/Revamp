/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files
import ZIPFoundation

// Workspace creates folders for a command to use for its operations.
public struct Workspace {
    public let baseFolder   : Folder
    public let outputFolder : Folder
    public let inputFolder  : Folder
    public let tempFolder  : Folder

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

    /// Write file to chosen folder. A parameter to unzip files is provided.
    public func writeFile(_ file: File, to destination: Destination, decompress: Bool = false) throws {
        if decompress == true {
            let fileManager = FileManager()
            let fileURL = URL(fileURLWithPath: file.path)
            var destinationURL: URL
            switch destination {
                case .input:
                    destinationURL = URL(fileURLWithPath: inputFolder.path)
                case .output:
                    destinationURL = URL(fileURLWithPath: outputFolder.path)
                case .temporary:
                    destinationURL = URL(fileURLWithPath: tempFolder.path)
            }

            try fileManager.unzipItem(at: fileURL, to: destinationURL)
        } else {
            switch destination {
                case .input:
                    try file.copy(to: inputFolder)
                case .output:
                    try file.copy(to: outputFolder)
                case .temporary:
                    try file.copy(to: tempFolder)
            }
        }
    } 

    /// Copies the file located in the output folder to a folder.
    public func copyFileFromOutput(named name: String, to folder: Folder) throws {
        let file = try outputFolder.file(named: name)
        try file.copy(to: folder)
    }

    /// Permanently delete the contents of all folders.
    /// The folders are not deleted so the workspace can be still be used.
    public func emptyFolders() throws {
        try inputFolder.empty(includingHidden: true)
        try outputFolder.empty(includingHidden: true)
        try tempFolder.empty(includingHidden: true)
    }
}