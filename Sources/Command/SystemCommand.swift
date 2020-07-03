/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files
import ZIPFoundation

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
    public static func codesign(_ filePath: String, with certificate: String) -> Bool {
        //TODO: Check for ipa or app extension
        //TODO: Check that ipa is a zip
        //TODO: Check that app is a folder
        

        let tempExtractionURL = extractToTemporaryDirectory(filePath)
        let foldersToSign     = findDirectories(withExtension: [".app", "*.appex", ".framework"], in: tempExtractionURL!.path)

        let appFolder = getAppFolder(from: tempExtractionURL!)
        let embeddedProvisionFile = appFolder.path + "embedded.mobileprovision"

        let entitlementsPlistFile = extractEntitlements(from: embeddedProvisionFile)
        print(entitlementsPlistFile!)

        // Start the signing process
        for folder in foldersToSign {
            let out = Process().execute("/usr/bin/codesign", arguments: ["--continue", "-f", "-s", certificate, 
                                                                         "--entitlements", entitlementsPlistFile!.path, folder.path])
            
        }

        do {
            let outputFolder = try Folder.temporary.createSubfolder(named: "output")
            let resignedFile = outputFolder.path + "/revamped.ipa"

            let destinationURL = URL(fileURLWithPath: resignedFile)

            let fileManager = FileManager()
            try fileManager.zipItem(at: tempExtractionURL!, to: destinationURL, shouldKeepParent: false)

        } catch { return false }
                                                         
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

        // print(matchedFolders)
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
    static func getAppName(from extractionURL: URL) -> String {
        let appFolder = findDirectories(withExtension: [".app"], in: extractionURL.path)
        return appFolder[0].name
    }

    static func getAppFolder(from extractionURL: URL) -> Folder {
        let appFolder = findDirectories(withExtension: [".app"], in: extractionURL.path)
        return appFolder.first!
    }

    // Get the entitlement from the provisioning profile and save it to a file
    static func extractEntitlements(from profile: String) -> File? {
        let out = Process().execute("/usr/bin/security", arguments: ["cms", "-D", "-i", profile])

        do {
            let profilePlist = try Folder.temporary.createFile(at: "work/profile.plist", contents: out.output.data(using: .utf8))
            let entitlementContent = Process().execute("/usr/libexec/PlistBuddy", arguments: ["-x", "-c", "Print:Entitlements", profilePlist.path])
            let entitlementsPlist = try Folder.temporary.createFile(at: "work/entitlements.plist", contents: entitlementContent.output.data(using: .utf8))

            return entitlementsPlist
         } catch { }

        return nil 
    }
    
}