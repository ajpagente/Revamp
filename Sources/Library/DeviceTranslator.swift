/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

public struct DeviceTranslator {
    private let data: Data

    public init(file: File) throws {
        self.data = try file.read()
    }

    public func translate(_ devices: [String]) throws -> [String] {
        let decoder = JSONDecoder()
        let translated = try decoder.decode([Device].self, from: data)

        var translatedDevices: [String] = []
        for udid in devices {
            var found = false
            for device in translated {
                if udid == device.udid { 
                    translatedDevices.append(device.name)
                    found = true
                }
            }
            if !found { translatedDevices.append(udid) }
        }
        return translatedDevices
    }
}

private struct Device: Codable {
    var name:        String
    var deviceClass: String
    var model:       String
    var udid:        String
}