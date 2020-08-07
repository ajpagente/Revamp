/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

public struct ProfileAnalyzer {
    @discardableResult
    public static func getInfo(from file: File) throws -> [OutputGroup] {
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
        let infoGroup = OutputGroup(lines: info, header: "Info", separator: ":")

        var certificateInfo: [String] = []

        for (n, certificate) in profile!.developerCertificates.enumerated() {
            certificateInfo.append("Certificate #: \(n+1)")
            certificateInfo.append("Common Name: \(certificate.certificate!.commonName!)")
            certificateInfo.append("Team Identifier: \(certificate.certificate!.orgUnit)")      
            certificateInfo.append("Expiry: \(dateFormatter.string(from: certificate.certificate!.notValidAfter))")
        }
        let certificateGroup = OutputGroup(lines: certificateInfo, header: "Certificate", separator: ":")

        return [infoGroup, certificateGroup]
    }
}