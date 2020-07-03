import XCTest
// import class Foundation.Bundle
@testable import Library

final class revampTests: XCTestCase {

    var resourcesURL: URL? = {
      let projectURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
      return projectURL.appendingPathComponent("Tests/Resources")
    }()

    func testParseProvisioningProfile() throws {
        

        let testProfile = resourcesURL!.appendingPathComponent("profile01.mobileprovision")

        if let data = try? Data(contentsOf: testProfile) {
            let profile = try ProvisioningProfile.parse(from: data)
            print(profile!.UUID)     

        }  
    }

    // func testParseAllProvisioningProfiles() throws {
    //     let fileManager = FileManager.default
    //     let urls = try fileManager.contentsOfDirectory(at: resourcesURL!, 
    //                                                        includingPropertiesForKeys: [],
    //                                                        options: [ .skipsSubdirectoryDescendants,
    //                                                                   .skipsHiddenFiles ] )

    //     for url in urls {
    //         if let data = try? Data(contentsOf: url) {
    //             let profile = try ProvisioningProfile.parse(from: data)
    //             print(profile!.UUID)     
    //         }  
    //     }

    // }

    // func testExample() throws {
    //     // This is an example of a functional test case.
    //     // Use XCTAssert and related functions to verify your tests produce the correct
    //     // results.

    //     // Some of the APIs that we use below are available in macOS 10.13 and above.
    //     guard #available(macOS 10.13, *) else {
    //         return
    //     }

    //     let fooBinary = productsDirectory.appendingPathComponent("revamp")

    //     let process = Process()
    //     process.executableURL = fooBinary

    //     let pipe = Pipe()
    //     process.standardOutput = pipe

    //     try process.run()
    //     process.waitUntilExit()

    //     let data = pipe.fileHandleForReading.readDataToEndOfFile()
    //     let output = String(data: data, encoding: .utf8)

    //     XCTAssertEqual(output, "Hello, world!\n")
    // }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testParseProvisioningProfile",     testParseProvisioningProfile),
        // ("testParseAllProvisioningProfiles", testParseAllProvisioningProfiles),
    ]
}
