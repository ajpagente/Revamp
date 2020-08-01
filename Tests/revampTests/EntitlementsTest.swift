import XCTest

import Library

final class EntitlementsTest: XCTestCase {
    private var lines: [String]!

    // MARK: - XCTestCase
    override func setUp() {
        lines = ["abcdef:abcdefghi",
                 "abcdefghi:abcdefghi",
                 "abcdefghijkl:abcdefghi"]
    }

    // MARK: - OutputGroup
    func testEntitlements01() throws {
        let entitlementsData  = ["keychain-access-groups": Library.PropertyListDictionaryValue.array([Library.PropertyListDictionaryValue.string("6ABCDEFGH6.*")]), 
            "application-identifier": Library.PropertyListDictionaryValue.string("6ABCDEFGH6.some.app.identifier"), 
            "com.apple.developer.team-identifier": Library.PropertyListDictionaryValue.string("6ABCDEFGH6"), 
            "get-task-allow": Library.PropertyListDictionaryValue.bool(true)]

        let entitlements = Entitlements(entitlementsData)
        XCTAssertTrue(entitlements.debuggable)
        XCTAssertEqual(entitlements.applicationIdentifier, "6ABCDEFGH6.some.app.identifier")
        XCTAssertEqual(entitlements.teamIdentifier, "6ABCDEFGH6")
        XCTAssertFalse(entitlements.pushEnabled)
        XCTAssertTrue(entitlements.apsEnvironment.isEmpty)
    }

    static var allTests = [
        ("testEntitlements01"                      , testEntitlements01),
    ]

}

