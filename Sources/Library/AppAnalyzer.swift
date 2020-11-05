/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files


public struct AppAnalyzer {
    public static func getLimitedInfo(from file: File, colorize: Bool = false) throws -> [OutputGroup] {
        let groups = try getInfo(from: file, colorize: colorize, translationFile: nil)
        return Array(groups.prefix(3))
    }

    public static func getAllInfo(from file: File, colorize: Bool = false, translateWith translationFile: File? = nil) throws -> [OutputGroup] {
        return try getInfo(from: file, colorize: colorize, translationFile: translationFile)
    }

    private static func getInfo(from file: File, colorize: Bool, translationFile: File?) throws -> [OutputGroup] {
        let workspace = try Workspace()
        try workspace.writeFile(file, to: .input, decompress: true)

        let appFolders = workspace.inputFolder.findSubfolders(withExtension: [".app"])
        
        let plistFile = try! appFolders.first!.file(named: "Info.plist")
        let appGroup = try getPlistInfo(from: plistFile, colorize: colorize)  

        let profileFile = try! Folder(path: appFolders.first!.path).file(named: "embedded.mobileprovision")
        let profileGroup = try getProfileInfo(from: profileFile, colorize: colorize, translationFile: translationFile)

        let outputGroups = OutputGroups([appGroup] + profileGroup)
        return outputGroups.groups
    }

    private static func getPlistInfo(from file: File, colorize: Bool = false) throws -> OutputGroup {
        let infoPlist = try InfoPlist.parse(from: file)
        var info: [String] = []

        info.append("App Name: \(infoPlist.bundleName)")
        info.append("Bundle ID: \(infoPlist.bundleIdentifier)")
        info.append("Bundle Short Version: \(infoPlist.bundleVersionShort)")
        info.append("Bundle Version: \(infoPlist.bundleVersion)")
        info.append("Min OS Version: \(infoPlist.minOSVersion)")
        info.append("Platform Version: \(infoPlist.platformVersion)")

        // Build information
        let xcodeVersion = XcodeBuildTranslator.translate(infoPlist.xcodeBuild)
        info.append("XCode Version: \(xcodeVersion) (\(infoPlist.xcodeBuild))")
        let macOSVersion = MacOSBuildTranslator.translate(infoPlist.buildMachineOSBuild)
        info.append("macOS Version: \(macOSVersion) (\(infoPlist.buildMachineOSBuild))")

        return OutputGroup(lines: info, header: "App Info", separator: ":")   
    }

    private static func getProfileInfo(from file: File, colorize: Bool = false, translationFile: File?) throws -> [OutputGroup] {
        return try ProfileAnalyzer.getAllInfo(from: file, colorize: colorize, translateWith: translationFile)
    }
}