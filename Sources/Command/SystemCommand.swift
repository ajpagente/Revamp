/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

public struct SystemCommand {
    public static func fileInfo(of filePath: String, with arguments: [String:String] = ["":""]) -> CommandOutput {
        let tempExtractionURL = extractToTemporaryDirectory(filePath)
        let appName           = getAppName(from: tempExtractionURL!)

        if let tempExtractionURL = tempExtractionURL {
            let tempPayloadURL = tempExtractionURL.appendingPathComponent("Payload")
            let tempAppURL     = tempPayloadURL.appendingPathComponent(appName)

            let simpleOutput = Process().execute("/usr/bin/codesign", arguments: ["--display","--verbose=2","-d",tempAppURL.path])

            let verboseOutput = Process().execute("/usr/bin/codesign", arguments: ["--display","--verbose=4","-d",tempAppURL.path])

            return CommandOutput(simple: [simpleOutput.output], verbose: [verboseOutput.output])
        } 

        return CommandOutput(simple: [""], verbose: [""])
    }

    @discardableResult
    public static func unzip(_ filePath: String, to extractPath: String) -> Bool {
        let _ = Process().execute("/usr/bin/unzip", arguments: ["-q", filePath, "-d", extractPath])
        return true
    }

    @discardableResult
    public static func codesign(_ filePath: String) -> Bool {
        let tempExtractionURL = extractToTemporaryDirectory(filePath)
        let foldersToSign     = findDirectories(withExtension: [".app", ".framework"], in: tempExtractionURL!.path)
        return true
    }

    public static func findDirectories(withExtension extensions: [String], in folderPath: String) -> [Folder] {
        let folder         = try! Folder(path: folderPath)
        let folders        = folder.subfolders.recursive
        var matchedFolders = [Folder]()

        for folder in folders {
            for suffix in extensions {
                if folder.name.hasSuffix(suffix) {
                    matchedFolders.append(folder)
                }
            }
        }

        print(matchedFolders)
        return matchedFolders
    }
}

private extension SystemCommand {
    static func extractToTemporaryDirectory(_ filePath: String) -> URL? {
        let fileManager = FileManager.default
        let ipaURL = URL(fileURLWithPath: filePath, isDirectory: false)

        do {
            let tempExtractionURL = try fileManager.createTemporaryDirectory(atPath: "ipa-extract")
            SystemCommand.unzip(ipaURL.path, to: tempExtractionURL.path)
            return tempExtractionURL
        } catch {
            return nil
        }
    }

    // A directory called <app name>.app is expected to be present in an ipa
    private static func getAppName(from extractionURL: URL) -> String {
        let appFolder = findDirectories(withExtension: [".app"], in: extractionURL.path)
        return appFolder[0].name
    }
    
}