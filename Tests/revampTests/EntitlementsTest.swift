import XCTest

import Library

final class EntitlementsTest: XCTestCase {
    func testFiltered() throws {
        let testData  = getTestData()
        let entitlements = Entitlements(testData)

        let keys = ["get-task-allow", "com.apple.developer.nfc.readersession.formats",
                    "aps-environment", ]
        let expected = ["Push Notification": "development",
                        "Debuggable": "true",
                        "NFC": "TAG, NDEF"]

        let result = entitlements.filterDisplayableEntitlements(with: keys)

        XCTAssertEqual(result.count, expected.count)
        XCTAssertEqual(result["Push Notification"], "development")
        XCTAssertEqual(result["Debuggable"], "true")
        XCTAssertEqual(result["NFC"], "NDEF, TAG")
    }

    func getTestData() -> [String: PropertyListDictionaryValue] {
        return ["com.apple.developer.healthkit": Library.PropertyListDictionaryValue.bool(true), 
         "com.apple.developer.pass-type-identifiers": 
           Library.PropertyListDictionaryValue.array([Library.PropertyListDictionaryValue.string("6ABCDEFGH6.*")]), 
         "com.apple.developer.icloud-container-identifiers": Library.PropertyListDictionaryValue.array([]), 
         "com.apple.developer.homekit": Library.PropertyListDictionaryValue.bool(true), 
         "com.apple.developer.authentication-services.autofill-credential-provider": 
           Library.PropertyListDictionaryValue.bool(true), 
         "inter-app-audio": Library.PropertyListDictionaryValue.bool(true), 
         "com.apple.developer.icloud-container-development-container-identifiers": 
           Library.PropertyListDictionaryValue.array([]), 
         "com.apple.developer.default-data-protection": 
           Library.PropertyListDictionaryValue.string("NSFileProtectionComplete"), 
         "com.apple.developer.associated-domains": Library.PropertyListDictionaryValue.string("*"), 
         "com.apple.developer.coremedia.hls.low-latency": Library.PropertyListDictionaryValue.bool(true), 
         "com.apple.developer.user-fonts": 
           Library.PropertyListDictionaryValue.array([Library.PropertyListDictionaryValue.string("app-usage"), 
                Library.PropertyListDictionaryValue.string("system-installation")]), 
         "com.apple.developer.siri": Library.PropertyListDictionaryValue.bool(true), 
         "com.apple.security.application-groups": Library.PropertyListDictionaryValue.array([]), 
         "com.apple.developer.ubiquity-kvstore-identifier": Library.PropertyListDictionaryValue.string("6ABCDEFGH6.*"), 
         "com.apple.developer.in-app-payments": Library.PropertyListDictionaryValue.array([]), 
         "com.apple.developer.associated-domains.mdm-managed": Library.PropertyListDictionaryValue.bool(true), 
         "com.apple.developer.devicecheck.appattest-environment": 
           Library.PropertyListDictionaryValue.array([Library.PropertyListDictionaryValue.string("development"), 
                Library.PropertyListDictionaryValue.string("production")]),
         "keychain-access-groups": 
           Library.PropertyListDictionaryValue.array([Library.PropertyListDictionaryValue.string("6ABCDEFGH6.*"), 
                Library.PropertyListDictionaryValue.string("com.apple.token")]), 
         "com.apple.developer.networking.HotspotConfiguration": Library.PropertyListDictionaryValue.bool(true), 
         "com.apple.developer.team-identifier": Library.PropertyListDictionaryValue.string("6ABCDEFGH6"), 
         "com.apple.developer.nfc.readersession.formats": 
           Library.PropertyListDictionaryValue.array([Library.PropertyListDictionaryValue.string("TAG"), 
                Library.PropertyListDictionaryValue.string("NDEF")]), 
         "com.apple.developer.networking.wifi-info": Library.PropertyListDictionaryValue.bool(true), 
         "com.apple.developer.networking.multipath": Library.PropertyListDictionaryValue.bool(true), 
         "com.apple.developer.networking.networkextension": 
           Library.PropertyListDictionaryValue.array([Library.PropertyListDictionaryValue.string("app-proxy-provider"), 
                Library.PropertyListDictionaryValue.string("content-filter-provider"), 
                Library.PropertyListDictionaryValue.string("packet-tunnel-provider"), 
                Library.PropertyListDictionaryValue.string("dns-proxy"), 
                Library.PropertyListDictionaryValue.string("dns-settings")]), 
          "get-task-allow": Library.PropertyListDictionaryValue.bool(true), 
          "com.apple.developer.kernel.extended-virtual-addressing": Library.PropertyListDictionaryValue.bool(true), 
          "com.apple.developer.ubiquity-container-identifiers": Library.PropertyListDictionaryValue.array([]), 
          "com.apple.developer.healthkit.access": 
            Library.PropertyListDictionaryValue.array([Library.PropertyListDictionaryValue.string("health-records")]), 
          "com.apple.developer.networking.vpn.api": 
            Library.PropertyListDictionaryValue.array([Library.PropertyListDictionaryValue.string("allow-vpn")]), 
          "com.apple.developer.icloud-services": Library.PropertyListDictionaryValue.string("*"), 
          "com.apple.external-accessory.wireless-configuration": Library.PropertyListDictionaryValue.bool(true), 
          "aps-environment": Library.PropertyListDictionaryValue.string("development"), 
          "com.apple.developer.ClassKit-environment": 
            Library.PropertyListDictionaryValue.array([Library.PropertyListDictionaryValue.string("production"), 
                 Library.PropertyListDictionaryValue.string("development")]), 
          "application-identifier": Library.PropertyListDictionaryValue.string("6ABCDEFGH6.some.app.identifier")]
    } 
    static var allTests = [
        ("testFiltered", testFiltered),
    ]
}

