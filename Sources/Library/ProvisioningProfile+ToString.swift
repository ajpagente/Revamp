/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Chalk

public extension ProvisioningProfile {
    var simpleOutput: String {
        var line = "\(UUID) \(name)"
        if colorize { line = formatExpired(line) }
        return line
    }

    var verboseOutput: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        
        var expiry = "\(dateFormatter.string(from: expirationDate))"
        if colorize { expiry = formatExpired(expiry) }
        let lines = ["Profile Name: \(name)",
                     "UUID: \(UUID)",
                     "App ID Name: \(appIDName)",
                     "Team Name: \(teamName)",
                     "Expiry: \(expiry)"]
        
        let outputGroup = OutputGroup(lines: lines, header: nil, separator: ":")
        return OutputFormatter().string(from: outputGroup)
    }

    private func formatExpired(_ string: String) -> String {
        if isExpired { return "\(string, color: .red)" }
        return string
    }
}