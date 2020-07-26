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
        
        return """
        Profile name: \(name)
        UUID: \(UUID)
        App ID name: \(appIDName)
        Team name: \(teamName)
        Expiry: \(dateFormatter.string(from: expirationDate))
        """

    }

}