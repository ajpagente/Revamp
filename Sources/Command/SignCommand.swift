/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Library

public struct SignCommand: Command {
    private var errorReason = CommandErrorReason(simple: [])
    private var output      = CommandOutput(simple: [], verbose: [])
    private var arguments: [String:String] = [:]  
    private var appName     = ""

    public init(with arguments: [String:String]) {
        self.arguments = arguments
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
        let tempDirectoryURL  = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        var tempExtractionURL: URL?

        let file = arguments["file"]!
        let fileManager = FileManager.default

        let ipaURL = URL(fileURLWithPath: file, isDirectory: false)

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
            return false
        }

        if let tempExtractionURL = tempExtractionURL {
            let tempPayloadURL = tempExtractionURL.appendingPathComponent("Payload")
            let tempAppURL     = tempPayloadURL.appendingPathComponent(appName)

            let simpleOutput = Process().execute("/usr/bin/codesign", arguments: ["--display","--verbose=2","-d",tempAppURL.path])
            self.output.simple.append(simpleOutput.output)

            let verboseOutput = Process().execute("/usr/bin/codesign", arguments: ["--display","--verbose=4","-d",tempAppURL.path])
            self.output.verbose.append(verboseOutput.output)

            return true
        } 

        return false
    }
}