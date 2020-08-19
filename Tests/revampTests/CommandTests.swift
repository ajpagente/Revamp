import XCTest
import Library


final class CommandTests: XCTestCase {
  func testCommand() throws {
    let input   = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])
    let command  = Command(input: input)
    let output  = command.execute()
    XCTAssertEqual(command.name, "unknown")
    XCTAssertEqual(output.status, .fail)
    XCTAssertEqual(output.errorCode, .unknownCommand)
    XCTAssertEqual(output.message, ["Unknown command"])
  }

  static var allTests = [
    ("testCommand", testCommand),
  ]
}