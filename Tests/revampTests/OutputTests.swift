import XCTest

import Library

final class OutputTests: XCTestCase {
    private var lines: [String]!

    // MARK: - XCTestCase
    override func setUp() {
        lines = ["abcdef:abcdefghi",
                 "abcdefghi:abcdefghi",
                 "abcdefghijkl:abcdefghi"]
    }

    // MARK: - OutputGroup
    func testMaxCount() throws {
        var outputGroup = OutputGroup(lines: lines, header: nil, separator: ":")
        XCTAssertEqual(outputGroup.maxCount, 12)

        lines.append("1234567890123456:1")
        outputGroup = OutputGroup(lines: lines, header: nil)
        XCTAssertEqual(outputGroup.maxCount, 16)
    }

    func testMaxCountWithSpace() throws {
        lines.append("abcdefghijkl  :abc")
        let outputGroup = OutputGroup(lines: lines, header: nil, separator: ":")
        
        XCTAssertEqual(outputGroup.maxCount, 14)
    }

    func testMaxCountWithDuplicateSeparator() throws {
        lines.append("abcdefghijklmn:abc:addf")
        let outputGroup = OutputGroup(lines: lines, header: nil, separator: ":")
        
        XCTAssertEqual(outputGroup.maxCount, 14)
    }

    func testMaxCountWrongSeparator() throws {
        let outputGroup = OutputGroup(lines: lines, header: nil, separator: ";")
        
        XCTAssertEqual(outputGroup.maxCount, 0)
    }

    // MARK: - OutputFormatter
    func testFormatter() throws {
        let linesInitial = ["App ID:Test App",
                           "Bundle ID:com.thalesgroup.test",
                           "Version:2.0.0"]
        let linesExpected = ["App ID     :  Test App",
                             "Bundle ID  :  com.thalesgroup.test",
                             "Version    :  2.0.0"]

        let linesExpectedString = "App ID     :  Test App\nBundle ID  :  com.thalesgroup.test\nVersion    :  2.0.0"

        let outputGroup = OutputGroup(lines: linesInitial, header: nil, separator: ":")
        let formatter = OutputFormatter()
        let linesActual = formatter.strings(from: outputGroup)
        XCTAssertEqual(linesActual, linesExpected)

        let linesActualString = formatter.string(from: outputGroup)
        XCTAssertEqual(linesActualString, linesExpectedString)
    }

    func testFormatterWithHeader() throws {
        let linesInitial = ["App ID:Test App",
                           "Bundle ID:com.thalesgroup.test",
                           "Version:2.0.0"]
        let linesExpected = ["HEADER",
                             "   App ID     :  Test App",
                             "   Bundle ID  :  com.thalesgroup.test",
                             "   Version    :  2.0.0"]

        let outputGroup = OutputGroup(lines: linesInitial, header: "header", separator: ":")
        let formatter = OutputFormatter()
        let linesActual = formatter.strings(from: outputGroup)
        
        XCTAssertEqual(linesActual, linesExpected)
    }

    func testFormatterNewSeparator() throws {
        let linesInitial = ["App ID:Test App",
                           "Bundle ID:com.thalesgroup.test",
                           "Version:2.0.0"]
        let linesExpected = ["App ID     -  Test App",
                             "Bundle ID  -  com.thalesgroup.test",
                             "Version    -  2.0.0"]

        let outputGroup = OutputGroup(lines: linesInitial, header: nil, separator: ":")
        var formatter = OutputFormatter()
        formatter.separator = "-"
        let linesActual = formatter.strings(from: outputGroup)
        
        XCTAssertEqual(linesActual, linesExpected)
    }

    func testFormatterWrongSeparator() throws {
        let linesInitial = ["App ID:Test App",
                           "Bundle ID:com.thalesgroup.test",
                           "Version:2.0.0"]
        let linesExpected = ["App ID:Test App",
                           "Bundle ID:com.thalesgroup.test",
                           "Version:2.0.0"]

        let outputGroup = OutputGroup(lines: linesInitial, header: nil, separator: ";")
        let formatter = OutputFormatter()
        let linesActual = formatter.strings(from: outputGroup)
        
        XCTAssertEqual(linesActual, linesExpected)
    }

    static var allTests = [
        ("testMaxCount"                      , testMaxCount),
        ("testMaxCountWithSpace"             , testMaxCountWithSpace),
        ("testMaxCountWithDuplicateSeparator", testMaxCountWithDuplicateSeparator),
        ("testMaxCountWrongSeparator"        , testMaxCountWrongSeparator),
        ("testFormatter"                     , testFormatter),
        ("testFormatterWithHeader"           , testFormatterWithHeader),
        ("testFormatterNewSeparator"         , testFormatterNewSeparator),
        ("testFormatterWrongSeparator"       , testFormatterWrongSeparator),
    ]

}