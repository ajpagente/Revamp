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

    public func isArgumentValid() -> Bool {
        return false
    }

    public func isSuccessful() -> Bool {
        return false
    }

    public func execute() -> Bool {
        let fileManager = FileManager.default
        let userHomeURL = URL(fileURLWithPath: NSHomeDirectory())
        let profileURL  = userHomeURL.appendingPathComponent("Library/MobileDevice/Provisioning Profiles", isDirectory: true)
        
        do {
            let urls = try fileManager.contentsOfDirectory(at: profileURL, 
                                                           includingPropertiesForKeys: [],
                                                           options: [ .skipsSubdirectoryDescendants,
                                                                      .skipsHiddenFiles ] )

            for url in urls {
                if let data = try? Data(contentsOf: url) {
                    if let profile = try ProvisioningProfile.parse(from: data) {
                        print(profile.UUID)     
                     }
                }  
            }
        } catch {
            return false
        }
        

        return true
        
    }
}