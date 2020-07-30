/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

public struct AppAnalyzer {
    @discardableResult
    public static func getInfo(from file: File) throws -> [OutputGroup] {
        let workspace = try Workspace()
        try workspace.writeFile(file, to: .input, decompress: true)

        let appFolders = workspace.inputFolder.findSubfolders(withExtension: [".app"])
        
        let plistFile = try! appFolders.first!.file(named: "Info.plist")
        let infoPlist = try InfoPlist.parse(from: plistFile)
        var info: [String] = []

        info.append("App Name: \(infoPlist.bundleName)")
        info.append("Bundle ID: \(infoPlist.bundleIdentifier)")
        info.append("Bundle Version: \(infoPlist.bundleVersionShort).\(infoPlist.bundleVersion)")
        info.append("Min OS Version: \(infoPlist.minOSVersion)")
        info.append("Platform Version: \(infoPlist.platformVersion)")

        let appGroup = OutputGroup(lines: info, header: "App Info", separator: ":")
        
        let signInfo = try getSignInfo(from: appFolders.first!.path)
        let signGroup = OutputGroup(lines: signInfo, header: "App Signature", 
                                    separator: ":", overrideMaxCount: appGroup.maxCount)
        
        return [appGroup, signGroup]
    }

    private static func getSignInfo(from appPath: String) throws -> [String] {
        let processOutput = Process().execute("/usr/bin/codesign", arguments: ["--display","--verbose=4","-d", appPath])
        let signInfo = processOutput.output.components(separatedBy: "\n")

        // get the signing identity and team id
        var info: [String] = []
        if let index = signInfo.firstIndex(where: { $0.contains("Authority=") }) {
            let fullString = signInfo[index]
            let split = fullString.components(separatedBy: "=")
            info.append("Authority: \(split.last!)")
        }

        if let index = signInfo.firstIndex(where: { $0.contains("TeamIdentifier=") }) {
            let fullString = signInfo[index]
            let split = fullString.components(separatedBy: "=")
            info.append("Team Identifier: \(split.last!)")
        }

        return info
    }
}