import ArgumentParser
import Foundation
import Library

struct Revamp: ParsableCommand {
    @Argument() var files: [String]

    mutating func run() throws {
        
        // guard #available(macOS 10.12, *) else {
        //     print("This application requires macOS 10.12 or newer")
        //     return
        // }

        let fileManager = FileManager.default
        let userHomeURL = URL(fileURLWithPath: NSHomeDirectory())
        let profileURL  = userHomeURL.appendingPathComponent("Library/MobileDevice/Provisioning Profiles", isDirectory: true)
        
        let urls = try fileManager.contentsOfDirectory(at: profileURL, 
                                                           includingPropertiesForKeys: [],
                                                           options: [ .skipsSubdirectoryDescendants,
                                                                      .skipsHiddenFiles ] )

        for url in urls {
            if let data = try? Data(contentsOf: url) {
                let profile = try ProvisioningProfile.parse(from: data)
                print(profile!.UUID)     
            }  
        }
    }
}

Revamp.main()
