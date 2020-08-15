/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files
import Chalk

public extension ProvisioningProfile {
    enum ParserError: Error {
        case decoderCreationFailed
        case dataCreationFailed
    }

    static func parse(from data: Data) throws -> ProvisioningProfile? {
        guard let decoder = RVCMSDecoder() else {
            throw ParserError.decoderCreationFailed
        }

        decoder.updateMessage(with: data as NSData)
        decoder.finalizeMessage()

        guard let data = decoder.data else {
            throw ParserError.dataCreationFailed
        }

        var profile: ProvisioningProfile?
        do {
            profile = try PropertyListDecoder().decode(ProvisioningProfile.self, from: data)
        } catch {
            debugPrint(error)
            print(error)
            // TODO: log this error
        }

        return profile
    }
}

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

public extension ProvisioningProfile {
    func writeEntitlementsPlist(to filePath: String) throws {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let data = try encoder.encode(entitlements)
        try data.write(to: URL(fileURLWithPath: filePath))
    }

}

public extension ProvisioningProfile {
    func getTranslatedDevices(using file: File) throws -> [String] {
        let translator = try DeviceTranslator(file: file)
        if let devices = provisionedDevices {
            return try translator.translate(devices)
        }
        return []
    }
}