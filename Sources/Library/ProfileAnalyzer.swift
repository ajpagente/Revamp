/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

public struct ProfileAnalyzer {
    public static func getLimitedInfo(from file: File, colorize: Bool = false) throws -> [OutputGroup] {
        let groups = try getInfo(from: file, colorize: colorize, translationFile: nil)
        return Array(groups.prefix(3))
    }

    public static func getAllInfo(from file: File, colorize: Bool = false, translateWith translationFile: File? = nil) throws -> [OutputGroup] {
        return try getInfo(from: file, colorize: colorize, translationFile: translationFile)
    }
    
    private static func getInfo(from file: File, colorize: Bool, translationFile: File?) throws -> [OutputGroup] {
        var groups: [OutputGroup] = []

        let profileURL  = URL(fileURLWithPath: file.path)
        let data = try Data(contentsOf: profileURL)
        let profile = try ProvisioningProfile.parse(from: data)

        var info: [String] = []

        info.append("Profile Name: \(profile!.name)")
        info.append("Profile UUID: \(profile!.UUID)")
        info.append("App ID Name: \(profile!.appIDName)")
        info.append("Team Name: \(profile!.teamName)")
        info.append("Profile Expiry: \(formatDate(profile!.expirationDate, colorizeIfExpired: colorize))")
        groups.append(OutputGroup(lines: info, header: "Info", separator: ":"))

        var entitlementsInfo: [String] = []
        let entitlements = Entitlements(profile!.entitlements)
        entitlementsInfo.append("Debuggable: \(entitlements.debuggable)")
        entitlementsInfo.append("Push enabled: \(entitlements.pushEnabled)")
        groups.append(OutputGroup(lines: entitlementsInfo, header: "Entitlements", separator: ":"))

        var certificateInfo: [String] = []
        for (n, certificate) in profile!.developerCertificates.enumerated() {
            certificateInfo.append("Certificate #: \(n+1)")
            certificateInfo.append("Common Name: \(certificate.certificate!.commonName!)")
            certificateInfo.append("Team Identifier: \(certificate.certificate!.orgUnit)")      
            certificateInfo.append("Expiry: \(formatDate(certificate.certificate!.notValidAfter, colorizeIfExpired: colorize))")
        }
        groups.append(OutputGroup(lines: certificateInfo, header: "Certificate", separator: ":"))

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
        groups.append(OutputGroup(lines: printDevices, header: "Provisioned Devices", separator: ":"))

        let outputGroups = OutputGroups(groups)
        return outputGroups.groups
    }

    private static func formatDate(_ date: Date, colorizeIfExpired: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let dateString = dateFormatter.string(from: date)
    
        let now = Date()
        if colorizeIfExpired && date <= now { return "\(dateString, color: .red)" }
        else { return dateString }
    }

}