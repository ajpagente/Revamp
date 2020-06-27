/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public struct SystemCommand {
    public static func FileInfo(of filePath: String, with arguments: [String:String] = ["":""]) -> CommandOutput {
        var appName     = ""

        let tempDirectoryURL  = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        var tempExtractionURL: URL?

        let fileManager = FileManager.default

        let ipaURL = URL(fileURLWithPath: filePath, isDirectory: false)

        do {
            tempExtractionURL = try fileManager.createTemporaryDirectory(atPath: "ipa-extract")

            let unzipOutput = Process().execute("/usr/bin/unzip", arguments: ["-q",ipaURL.path,"-d",tempExtractionURL!.path])
            // TODO: Error handling

            let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
            let directoryEnumerator = fileManager.enumerator(at: tempExtractionURL!, includingPropertiesForKeys: Array(resourceKeys), options: .skipsHiddenFiles)!
            
            for case let fileURL as URL in directoryEnumerator {
                guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
                    let isDirectory = resourceValues.isDirectory,
                    let name = resourceValues.name
                    else {
                        continue
                }
                
                if isDirectory {
                    if name.contains(".app") { 
                        appName = name    
                        break 
                    }
                }
            }
        } catch {
            print("Failed extraction")
            return CommandOutput(simple: [""], verbose: [""])
        }

        if let tempExtractionURL = tempExtractionURL {
            let tempPayloadURL = tempExtractionURL.appendingPathComponent("Payload")
            let tempAppURL     = tempPayloadURL.appendingPathComponent(appName)

            let simpleOutput = Process().execute("/usr/bin/codesign", arguments: ["--display","--verbose=2","-d",tempAppURL.path])

            let verboseOutput = Process().execute("/usr/bin/codesign", arguments: ["--display","--verbose=4","-d",tempAppURL.path])

            return CommandOutput(simple: [simpleOutput.output], verbose: [verboseOutput.output])
        } 

        return CommandOutput(simple: [""], verbose: [""])
    }
}