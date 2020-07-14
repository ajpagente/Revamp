import XCTest

import Library
import Files


final class SignerTests: XCTestCase {
    private var folder: Folder!
    private var resourcesFolder: Folder!

    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        folder = try! Folder.home.createSubfolderIfNeeded(withName: ".signerTest")
        try! folder.empty()

        resourcesFolder = try! Folder(path: FileManager.default.currentDirectoryPath).subfolder(at: "Tests/Resources")
        let ipaFile = try! resourcesFolder.file(named: "tiny.ipa")
        try! ipaFile.copy(to: folder)
        let entitlementsPlistFile = try! resourcesFolder.file(named: "entitlements.plist")
        try! entitlementsPlistFile.copy(to: folder)
    }

    override func tearDown() {
        try? folder.delete()
        super.tearDown()
    }

    func testSign() throws {
        let ipaFile = try folder.file(named: "tiny.ipa")
        let entitlementsPlistFile = try folder.file(named: "entitlements.plist")
        let signingEngine = TestSigningEngine(certificate: "123456", entitlementsPlist: entitlementsPlistFile)
        try Signer.sign(ipaFile, using: signingEngine)
        XCTAssertTrue(folder.containsFile(named: "rv_tiny.ipa"))
    }

    static var allTests = [
        ("testSign"      , testSign),
    ]

}

struct TestSigningEngine: SigningEngine {
    var certificate: String
    var entitlementsPlist: File

    func sign(folder: Folder) throws -> Bool {
        // do nothing
        return true
    }

    func sign(file: File) throws -> Bool {
        // do nothing
        return true
    }
}