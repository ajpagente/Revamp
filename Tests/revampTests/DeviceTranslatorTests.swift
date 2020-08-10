import XCTest

import Library
import Files

final class DeviceTranslatorTests: XCTestCase {
    private var folder:   Folder!
    private var jsonFile: File!

    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        folder = try! Folder.home.createSubfolderIfNeeded(withName: ".translatorTest")
        try! folder.empty()

        let JSON = """
        [{
            "name": "Test iPhone X",
            "deviceClass": "IPHONE",
            "model": "iPhone X",
            "udid": "12345678905645207cba0fae977aa7d89929d0b4"
        },
        {
            "name": "Test iPhone 6s (M)",
            "deviceClass": "IPHONE",
            "model": "iPhone 6s",
            "udid": "1234567890698c7954ad3a88e0ca56cd5d0188b4"
        }]
        """
        jsonFile = try! folder.createFile(named: "devices.json")
        let data = JSON.data(using: .utf8)!
        try! jsonFile.write(data)
    }

    override func tearDown() {
        try? folder.delete()
        super.tearDown()
    }

    func testTranslateSingle() throws {
        let translator = try DeviceTranslator(file: jsonFile)
        var translated = try translator.translate(["12345678905645207cba0fae977aa7d89929d0b4"])
        XCTAssertEqual(translated[0], "Test iPhone X")

        translated = try translator.translate(["1234567890698c7954ad3a88e0ca56cd5d0188b4"])
        XCTAssertEqual(translated[0], "Test iPhone 6s (M)")
    }

    func testTranslateMultiple() throws {
        let translator = try DeviceTranslator(file: jsonFile)
        var devices = ["12345678905645207cba0fae977aa7d89929d0b4",
                       "1234567890698c7954ad3a88e0ca56cd5d0188b4"]
        var expected = ["Test iPhone X",
                       "Test iPhone 6s (M)"]
        var translated = try translator.translate(devices)
        XCTAssertEqual(translated, expected)

        devices = ["1234567890698c7954ad3a88e0ca56cd5d0188b4",
                   "12345678905645207cba0fae977aa7d89929d0b4"]
        expected = ["Test iPhone 6s (M)",
                    "Test iPhone X"]
        translated = try translator.translate(devices)
        XCTAssertEqual(translated, expected)
    }    

    func testTranslateNoMatch() throws {
        let translator = try DeviceTranslator(file: jsonFile)
        let devices = ["1234567890deadbeef",
                       "2345678901deadbeef"]
        let translated = try translator.translate(devices)
        XCTAssertEqual(translated, devices)
    }    

    func testTranslatePartialMatch() throws {
        let translator = try DeviceTranslator(file: jsonFile)
        let devices = ["1234567890deadbeef",
                       "12345678905645207cba0fae977aa7d89929d0b4"]
        let expected = ["1234567890deadbeef",
                        "Test iPhone X"]
        let translated = try translator.translate(devices)
        XCTAssertEqual(translated, expected)
    }  

    static var allTests = [
        ("testTranslateSingle"       , testTranslateSingle),
        ("testTranslateMultiple"     , testTranslateMultiple),
        ("testTranslateNoMatch"      , testTranslateNoMatch),
        ("testTranslatePartialMatch" , testTranslatePartialMatch)
    ]
}