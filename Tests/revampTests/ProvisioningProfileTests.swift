import XCTest

import Library
import Files

final class ProvisioningProfileTests: XCTestCase {
    private var folder: Folder!
    private var resourcesFolder: Folder!
    private var testProfileURL: URL!

    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        folder = try! Folder.home.createSubfolderIfNeeded(withName: ".profileTest")
        try! folder.empty()

        resourcesFolder = try! Folder(path: FileManager.default.currentDirectoryPath).subfolder(at: "Tests/Resources")
        let testProfileFile = try! resourcesFolder.file(named: "profile01.mobileprovision")
        testProfileURL  = URL(fileURLWithPath: testProfileFile.path)
    }

    override func tearDown() {
        try? folder.delete()
        super.tearDown()
    }

    func testParse() throws {

        let data = try Data(contentsOf: testProfileURL)
        let profile = try ProvisioningProfile.parse(from: data)

        XCTAssertEqual(profile!.appIDName, "IPMS Sample App")
        XCTAssertEqual(profile!.applicationIdentifierPrefixes.count, 1)
        XCTAssertEqual(profile!.applicationIdentifierPrefixes.first, "N35W8VCJCA")
        XCTAssertEqual(profile!.platforms.count, 1)
        XCTAssertEqual(profile!.platforms.first, "iOS")
        XCTAssertEqual(profile!.name, "IPMS Sample App Store Profile")
        XCTAssertNil(profile!.provisionedDevices)
        XCTAssertEqual(profile!.teamIdentifiers.count, 1)
        XCTAssertEqual(profile!.teamIdentifiers.first, "N35W8VCJCA")
        XCTAssertEqual(profile!.teamName, "Alvin John Pagente")
        XCTAssertEqual(profile!.timeToLive, 295)
        XCTAssertEqual(profile!.UUID, "4a40cda6-3519-4be5-a118-048483656f0a")
        XCTAssertEqual(profile!.version, 1)

        // Date checks
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, year: 2020, month: 5, day: 6)
        let expectedCreationDate = calendar.date(from: dateComponents)!
        dateComponents = calendar.dateComponents([.year, .month, .day], from: profile!.creationDate)
        let actualCreationDate = calendar.date(from: dateComponents)!
        
        dateComponents = DateComponents(calendar: calendar, year: 2021, month: 2, day: 25)
        let expectedExpirationDate = calendar.date(from: dateComponents)!
        dateComponents = calendar.dateComponents([.year, .month, .day], from: profile!.expirationDate)
        let actualExpirationDate = calendar.date(from: dateComponents)!

        XCTAssertTrue(actualCreationDate == expectedCreationDate)
        XCTAssertTrue(actualExpirationDate == expectedExpirationDate)

        // Entitlement checks
        let entitlements = profile!.entitlements
        XCTAssertEqual(entitlements["beta-reports-active"]!, .bool(true))
        XCTAssertEqual(entitlements["application-identifier"]!, .string("N35W8VCJCA.com.demo.msg.ipms"))
        XCTAssertEqual(entitlements["com.apple.developer.team-identifier"]!, .string("N35W8VCJCA"))
        XCTAssertEqual(entitlements["get-task-allow"]!, .bool(false))

        let keychainAccessGroups = entitlements["keychain-access-groups"]!
        switch keychainAccessGroups  {
        case .array(let elements):
            XCTAssertEqual(elements.count, 1)
            XCTAssertEqual(elements[0], .string("N35W8VCJCA.*"))
        default:
            print("Not an array")
        }
    }

    func testCertificateParsing() throws {
        let data = try Data(contentsOf: testProfileURL)
        let profile = try ProvisioningProfile.parse(from: data)

        XCTAssertTrue(profile!.developerCertificates.count != 0) 
    }

    func testWriteEntitlementsPlist() throws {
        let data = try Data(contentsOf: testProfileURL)
        let profile = try ProvisioningProfile.parse(from: data)

        let entitlementsPlistPath = folder.path + "entitlements.plist"
        try profile!.writeEntitlementsPlist(to: entitlementsPlistPath)
        XCTAssertTrue(folder.containsFile(named: "entitlements.plist"))
    }

    private func printFileContent(of file: File) throws {
        print(try file.readAsString())
    }

    static var allTests = [
        ("testParse"      , testParse),
        ("testWriteEntitlementsPlist", testWriteEntitlementsPlist),
    ]

}