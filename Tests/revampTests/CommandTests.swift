import XCTest

import Library

final class CommandTests: XCTestCase {

    func testCommand2() throws {
        let input   = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])
        let command  = Command2(input: input)
        let output  = command.execute()
        XCTAssertEqual(command.name, "unknown")
    }

    static var allTests = [
        ("testCommand2"                 , testCommand2),
    ]
}