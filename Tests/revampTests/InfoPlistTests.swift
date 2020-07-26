import XCTest

import Library
import Files

final class InfoPlistTests: XCTestCase {
    private var folder: Folder!
    private var resourcesFolder: Folder!
    private var testPlistFile: File!

    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        folder = try! Folder.home.createSubfolderIfNeeded(withName: ".plistTest")
        try! folder.empty()

        resourcesFolder = try! Folder(path: FileManager.default.currentDirectoryPath).subfolder(at: "Tests/Resources/ex-IPMSSampleApp/Payload/IPMSSampleApp.app")
        testPlistFile = try! resourcesFolder.file(named: "Info.plist")
    }

    override func tearDown() {
        try? folder.delete()
        super.tearDown()
    }

    func testParse() throws {
        let infoPlist = try InfoPlist.parse(from: testPlistFile)

        XCTAssertEqual(infoPlist.bundleName, "IPMSSampleApp")
        XCTAssertEqual(infoPlist.bundleVersionShort, "2.0.0")
        XCTAssertEqual(infoPlist.bundleVersion, "2.0.0")
        XCTAssertEqual(infoPlist.minOSVersion, "10.0")
        XCTAssertEqual(infoPlist.getBuildType(), "development")

        XCTAssertEqual(infoPlist.platformVersion, "11.2")
        XCTAssertEqual(infoPlist.sdkName, "iphoneos11.2")
        XCTAssertEqual(infoPlist.supportedPlatforms.count, 1)
        XCTAssertEqual(infoPlist.supportedPlatforms[0], "iPhoneOS")
    }

    static var allTests = [
        ("testParse"      , testParse),
    ]
}