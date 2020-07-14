/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public struct ListCommand: Command {
    private var errorReason = CommandErrorReason(simple: [])
    private var output      = CommandOutput(simple: [], verbose: [])
    private var path:        URL  

    public init(path: URL) {
        self.path = path
    }
    
    public func getError() -> [String] {
        return errorReason.simple
    }

    public func getOutput(_ type: CommandOutputType) -> [String] {
        switch type {
            case .simple:
                return output.simple
            case .verbose:
                return output.verbose
        } 
    }

    public mutating func execute() -> Bool {
        
        do {
            let fileManager = FileManager.default
            let urls = try fileManager.contentsOfDirectory(at: path, 
                                                           includingPropertiesForKeys: [],
                                                           options: [ .skipsSubdirectoryDescendants,
                                                                      .skipsHiddenFiles ] )

            for url in urls {
                if let data = try? Data(contentsOf: url) {
                    if let profile = try ProvisioningProfile.parse(from: data) {
                        output.simple.append(profile.simpleOutput)
                        output.verbose.append(profile.verboseOutput)
                     }
                }  
            }
        } catch {
            return false
        }
        
        return true
    }
}