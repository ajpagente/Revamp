import XCTest

import Library

final class CommandTests: XCTestCase {

    func testCommand() throws {
        let input   = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])
        let command  = Command(input: input)
        let output  = command.execute()
        XCTAssertEqual(command.name, "unknown")
    }

    static var allTests = [
        ("testCommand"                 , testCommand),
    ]
}