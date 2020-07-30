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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        
        let lines = ["Profile Name: \(name)",
                     "UUID: \(UUID)",
                     "App ID Name: \(appIDName)",
                     "Team Name: \(teamName)",
                     "Expiry: \(dateFormatter.string(from: expirationDate))"]
        
        let outputGroup = OutputGroup(lines: lines, header: nil, separator: ":")
        return OutputFormatter().string(from: outputGroup)
    }
}