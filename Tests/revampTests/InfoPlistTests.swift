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

        resourcesFolder = try! Folder(path: FileManager.default.currentDirectoryPath).subfolder(at: "Tests/Resources/ex-tiny/Payload/XCConfig Signing.app")
        testPlistFile = try! resourcesFolder.file(named: "Info.plist")
    }

    override func tearDown() {
        try? folder.delete()
        super.tearDown()
    }

    func testParse() throws {
        let infoPlist = try InfoPlist.parse(from: testPlistFile)

        XCTAssertEqual(infoPlist.bundleName, "XCConfig Signing")
        XCTAssertEqual(infoPlist.bundleVersionShort, "1.0")
        XCTAssertEqual(infoPlist.bundleVersion, "1")
        XCTAssertEqual(infoPlist.minOSVersion, "13.2")
        XCTAssertEqual(infoPlist.getBuildType(), "")

        XCTAssertEqual(infoPlist.xcodeVersion, "1130")
        XCTAssertEqual(infoPlist.xcodeBuild, "11C504")
        XCTAssertEqual(infoPlist.buildSDK, "17B102")
        XCTAssertEqual(infoPlist.buildMachineOSBuild, "18G3020")

        XCTAssertEqual(infoPlist.platformVersion, "13.2")
        XCTAssertEqual(infoPlist.sdkName, "iphoneos13.2")
        XCTAssertEqual(infoPlist.supportedPlatforms.count, 1)
        XCTAssertEqual(infoPlist.supportedPlatforms[0], "iPhoneOS")
    }

    static var allTests = [
        ("testParse"      , testParse),
    ]
}