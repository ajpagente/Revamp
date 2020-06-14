/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public extension ProvisioningProfile {
    var simpleOutput: String {
        return "\(UUID) \(name)"
    }

    var verboseOutput: String {
        return """
        Profile name: \(name)
        UUID: \(UUID)
        App ID name: \(appIDName)
        Team name: \(teamName)
        """

        //         case appIDName                     = "AppIDName"
        // case applicationIdentifierPrefixes = "ApplicationIdentifierPrefix"
        // case creationDate                  = "CreationDate"
        // case platforms                     = "Platform"
        // // case developerCertificates         = "DeveloperCertificates"
        // // case entitlements                  = "Entitlements"
        // case expirationDate                = "ExpirationDate"
        // case name                          = "Name"
        // case provisionedDevices            = "ProvisionedDevices"
        // case teamIdentifiers               = "TeamIdentifier"
        // case teamName                      = "TeamName"
        // case timeToLive                    = "TimeToLive"
        // case UUID                          = "UUID"
        // case version                       = "Version"
    }

}