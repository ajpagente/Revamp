/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

public struct AppAnalyzer {
    public static func getLimitedInfo(from file: File) throws -> [OutputGroup] {
        let groups = try getInfo(from: file, translationFile: nil)
        return Array(groups.prefix(4))
    }

    public static func getAllInfo(from file: File, translateWith translationFile: File? = nil) throws -> [OutputGroup] {
        return try getInfo(from: file, translationFile: translationFile)
    }

    private static func getInfo(from file: File, translationFile: File?) throws -> [OutputGroup] {
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
                                    separator: ":")

        let profileInfo = try getProfileInfo(from: appFolders.first!.path)
        let profileGroup = OutputGroup(lines: profileInfo, header: "Profile Info", 
                                    separator: ":")
        
        let entitlementsInfo = try getEntitlements(from: appFolders.first!.path)
        let entitlementsGroup = OutputGroup(lines: entitlementsInfo, header: "Entitlements", 
                                    separator: ":")

        let provisionedDevices = try getProvisionedDevices(from: appFolders.first!.path, translationFile: translationFile)
        let devicesGroup = OutputGroup(lines: provisionedDevices, header: "Provisioned Devices", 
                                    separator: ":")

        let outputGroups = OutputGroups([appGroup, signGroup, profileGroup, entitlementsGroup, devicesGroup])
        return outputGroups.groups
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

    private static func getProfileInfo(from appPath: String) throws -> [String] {
        let profileFile = try! Folder(path: appPath).file(named: "embedded.mobileprovision")
        let profileURL  = URL(fileURLWithPath: profileFile.path)

        let data = try Data(contentsOf: profileURL)
        let profile = try ProvisioningProfile.parse(from: data)

        var info: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"

        info.append("Profile Name: \(profile!.name)")
        info.append("Profile UUID: \(profile!.UUID)")
        info.append("App ID Name: \(profile!.appIDName)")
        info.append("Team Name: \(profile!.teamName)")
        info.append("Profile Expiry: \(dateFormatter.string(from: profile!.expirationDate))")
        
        for (n, certificate) in profile!.developerCertificates.enumerated() {
            info.append("Certificate #: \(n+1)")
            info.append("Common Name: \(certificate.certificate!.commonName!)")
            info.append("Team Identifier: \(certificate.certificate!.orgUnit)")      
            info.append("Expiry: \(dateFormatter.string(from: certificate.certificate!.notValidAfter))")
        }
        return info
    }

    private static func getEntitlements(from appPath: String) throws -> [String] {
        let profileFile = try! Folder(path: appPath).file(named: "embedded.mobileprovision")
        let profileURL  = URL(fileURLWithPath: profileFile.path)

        let data = try Data(contentsOf: profileURL)
        let profile = try ProvisioningProfile.parse(from: data)

        let entitlements = Entitlements(profile!.entitlements)
        var info: [String] = []
        info.append("Debuggable: \(entitlements.debuggable)")
        info.append("Push Enabled: \(entitlements.pushEnabled)")
        return info
    }

    private static func getProvisionedDevices(from appPath: String, translationFile: File?) throws -> [String] {
        let profileFile = try! Folder(path: appPath).file(named: "embedded.mobileprovision")
        let profileURL  = URL(fileURLWithPath: profileFile.path)

        let data = try Data(contentsOf: profileURL)
        let profile = try ProvisioningProfile.parse(from: data)

        var provisionedDevices: [String] = []
        var printDevices: [String] = []
        if let file = translationFile {
            provisionedDevices = try profile!.getTranslatedDevices(using: file)
        } else {
            if let devices = profile!.provisionedDevices { provisionedDevices = devices }
        }

        let count = provisionedDevices.count
        for (n, device) in provisionedDevices.enumerated() {
            printDevices.append("Device \(n+1) of \(count): \(device)")
        }

        return printDevices
    }


}