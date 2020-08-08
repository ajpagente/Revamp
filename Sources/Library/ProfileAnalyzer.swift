/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

public struct ProfileAnalyzer {
    public static func getLimitedInfo(from file: File) throws -> [OutputGroup] {
        let groups = try getInfo(from: file)
        return Array(groups.prefix(3))
    }

    public static func getAllInfo(from file: File) throws -> [OutputGroup] {
        return try getInfo(from: file)
    }
    private static func getInfo(from file: File) throws -> [OutputGroup] {
        var groups: [OutputGroup] = []

        let profileURL  = URL(fileURLWithPath: file.path)
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
            certificateInfo.append("Expiry: \(dateFormatter.string(from: certificate.certificate!.notValidAfter))")
        }
        groups.append(OutputGroup(lines: certificateInfo, header: "Certificate", separator: ":"))

        var provisionedDevices: [String] = []
        if let devices = profile!.provisionedDevices {
            let count = devices.count
            for (n, device) in devices.enumerated() {
                provisionedDevices.append("Device \(n+1) of \(count): \(device)")
            }
            groups.append(OutputGroup(lines: provisionedDevices, header: "Provisioned Devices", separator: ":"))
        }

        return groups
    }
}