/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Library

public struct ListCommand: Command {
    public var errorReason: CommandErrorReason?
    public var successInfo: CommandSuccessInfo?
    public var arguments:   [String: String]
    public var path:        URL?  // TODO: make this a getter only

    public func isArgumentValid() -> Bool {
        return false
    }

    public func isSuccessful() -> Bool {
        return false
    }

    public mutating func execute() -> Bool {
        
        var currentSuccessInfo = CommandSuccessInfo()
        do {
            guard let profileURL = path else {
                return false
            }

            let fileManager = FileManager.default
            let urls = try fileManager.contentsOfDirectory(at: profileURL, 
                                                           includingPropertiesForKeys: [],
                                                           options: [ .skipsSubdirectoryDescendants,
                                                                      .skipsHiddenFiles ] )

            for url in urls {
                if let data = try? Data(contentsOf: url) {
                    if let profile = try ProvisioningProfile.parse(from: data) {
                        currentSuccessInfo.simpleOutput.append(profile.UUID)
                        // print(profile.UUID)     
                     }
                }  
            }
        } catch {
            return false
        }
        
        successInfo = currentSuccessInfo
        return true
        
    }
}