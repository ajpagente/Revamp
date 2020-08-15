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
        let data        = try Data(contentsOf: profileURL)
        let profile     = try ProvisioningProfile.parse(from: data)
 
        groups.append(try getProfileInfo(from: profile!, colorize: colorize))
        groups.append(try getEntitlements(from: profile!, colorize: colorize))
        groups.append(try getCertificates(from: profile!, colorize: colorize))
        groups.append(try getProvisionedDevices(from: profile!, colorize: colorize, translationFile: translationFile))

        let outputGroups = OutputGroups(groups)
        return outputGroups.groups
    }

    private static func getProfileInfo(from profile: ProvisioningProfile, colorize: Bool = false) throws -> OutputGroup {
        var info: [String] = []
        info.append("Profile Name: \(profile.name)")
        info.append("Profile UUID: \(profile.UUID)")
        info.append("App ID Name: \(profile.appIDName)")
        info.append("Team Name: \(profile.teamName)")
        info.append("Profile Expiry: \(formatDate(profile.expirationDate, colorizeIfExpired: colorize))")
        return OutputGroup(lines: info, header: "Profile Info", separator: ":")
    }

    private static func getEntitlements(from profile: ProvisioningProfile, colorize: Bool = false) throws -> OutputGroup {
        let entitlements = Entitlements(profile.entitlements)
        let keys = ["get-task-allow", "com.apple.developer.nfc.readersession.formats",
                    "aps-environment", ]
        let filtered = entitlements.filterDisplayableEntitlements(with: keys)
        let info = filtered.map { "\($0.key): \($0.value)" }
        return OutputGroup(lines: info, header: "Entitlements", separator: ":")
    }

    private static func getCertificates(from profile: ProvisioningProfile, colorize: Bool = false) throws -> OutputGroup {
        var certificateInfo: [String] = []
        for (n, certificate) in profile.developerCertificates.enumerated() {
            certificateInfo.append("Certificate #: \(n+1)")
            certificateInfo.append("Common Name: \(certificate.certificate!.commonName!)")
            certificateInfo.append("Team Identifier: \(certificate.certificate!.orgUnit)")      
            certificateInfo.append("Serial Number: \(certificate.certificate!.serialNumber)")
            certificateInfo.append("SHA-1: \(certificate.certificate!.fingerprints["SHA-1"]!)")
            certificateInfo.append("Expiry: \(formatDate(certificate.certificate!.notValidAfter, colorizeIfExpired: colorize))")
        }
        return OutputGroup(lines: certificateInfo, header: "Developer Certificates", separator: ":")
    }

    private static func getProvisionedDevices(from profile: ProvisioningProfile, colorize: Bool, translationFile: File?) throws -> OutputGroup {
        var provisionedDevices: [String] = []
        var printDevices: [String] = []
        if let file = translationFile {
            provisionedDevices = try profile.getTranslatedDevices(using: file)
        } else {
            if let devices = profile.provisionedDevices { provisionedDevices = devices }
        }

        let count = provisionedDevices.count
        for (n, device) in provisionedDevices.enumerated() {
            printDevices.append("Device \(n+1) of \(count): \(device)")
        }

        return OutputGroup(lines: printDevices, header: "Provisioned Devices", separator: ":")
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