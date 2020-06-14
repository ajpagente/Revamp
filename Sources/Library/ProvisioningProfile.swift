/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public struct ProvisioningProfile: Codable {

    enum CodingKeys: String, CodingKey {
        case appIDName                     = "AppIDName"
        case applicationIdentifierPrefixes = "ApplicationIdentifierPrefix"
        case creationDate                  = "CreationDate"
        case platforms                     = "Platform"
        // case developerCertificates         = "DeveloperCertificates"
        // case entitlements                  = "Entitlements"
        case expirationDate                = "ExpirationDate"
        case name                          = "Name"
        case provisionedDevices            = "ProvisionedDevices"
        case teamIdentifiers               = "TeamIdentifier"
        case teamName                      = "TeamName"
        case timeToLive                    = "TimeToLive"
        case UUID                          = "UUID"
        case version                       = "Version"

        // TODO: Add isXCodeManaged?
    }

    public var appIDName:                     String
    public var applicationIdentifierPrefixes: [String]
    public var creationDate:                  Date
    public var platforms:                     [String]
    public var expirationDate:                Date
    public var name:                          String
    public var provisionedDevices:            [String]?
    public var teamIdentifiers:               [String]
    public var teamName:                      String
    public var timeToLive:                    Int
    public var UUID:                          String
    public var version:                       Int

}

struct ProvisioningProfiles {
    var profiles: [ProvisioningProfile] = []
}
