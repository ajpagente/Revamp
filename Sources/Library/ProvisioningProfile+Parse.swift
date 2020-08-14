/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public extension ProvisioningProfile {

    public enum ParserError: Error {
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