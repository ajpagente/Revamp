import XCTest
import Library


final class CommandEngineTests: XCTestCase {
  private var handler1: CommandHandler!
  private var handler2: CommandHandler!
  private var handler3: CommandHandler!

  override func setUp() {
    super.setUp()
    handler1 = CommandHandler(commandType: TestCommand1.self)
    handler2 = CommandHandler(commandType: TestCommand.self)
    handler3 = CommandHandler(commandType: TestCommand3.self)
  }

  func testEngineOneHandler() throws {
    let engine = CommandEngine(handler: handler1)
    let input = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])
    let actual = engine.execute("first", input: input)

    let expected = CommandOutput(message: ["first executed"])
    XCTAssertEqual(actual.message, expected.message)
  }

  func testEngineOneHandlerUnknownCommand() throws {
    let engine = CommandEngine(handler: handler1)
    let input = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])
    let actual = engine.execute("abcd", input: input)

    let expected = CommandOutput(errorCode: .unknownCommand, message: ["Unknown command"])
    XCTAssertEqual(actual.message, expected.message)
  }

  func testEngineTwoHandlers() throws {
    handler1.next = handler2
    let engine = CommandEngine(handler: handler1)
    let input = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])

    var actual = engine.execute("first", input: input)
    var expected = CommandOutput(message: ["first executed"])
    XCTAssertEqual(actual.message, expected.message)

    actual = engine.execute("second", input: input)
    expected = CommandOutput(message: ["second executed"])
    XCTAssertEqual(actual.message, expected.message)
  }

  func testEngineTwoHandlersUnknownCommand() throws {
    handler1.next = handler2
    let engine = CommandEngine(handler: handler1)
    let input = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])

    let actual = engine.execute("xyz", input: input)
    let expected = CommandOutput(errorCode: .unknownCommand, message: ["Unknown command"])
    XCTAssertEqual(actual.message, expected.message)
  }

  func testEngineThreeHandlers() throws {
    handler1.next = handler2
    handler2.next = handler3
    let engine = CommandEngine(handler: handler1)
    let input = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])

    var actual = engine.execute("first", input: input)
    var expected = CommandOutput(message: ["first executed"])
    XCTAssertEqual(actual.message, expected.message)

    actual = engine.execute("second", input: input)
    expected = CommandOutput(message: ["second executed"])
    XCTAssertEqual(actual.message, expected.message)

    actual = engine.execute("third", input: input)
    expected = CommandOutput(message: ["third executed"])
    XCTAssertEqual(actual.message, expected.message)
  }

  func testEngineThreeHandlersUnknownCommand() throws {
    handler1.next = handler2
    handler2.next = handler3
    let engine = CommandEngine(handler: handler1)
    let input = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])

    let actual = engine.execute("xyz", input: input)
    let expected = CommandOutput(errorCode: .unknownCommand, message: ["Unknown command"])
    XCTAssertEqual(actual.message, expected.message)
  }

  static var allTests = [
    ("testEngineOneHandler", testEngineOneHandler),
    ("testEngineOneHandlerUnknownCommand", testEngineOneHandlerUnknownCommand),
    ("testEngineTwoHandlers", testEngineTwoHandlers),
    ("testEngineTwoHandlersUnknownCommand", testEngineTwoHandlersUnknownCommand),
    ("testEngineThreeHandlers", testEngineThreeHandlers),
    ("testEngineThreeHandlersUnknownCommand", testEngineThreeHandlersUnknownCommand),
  ]
}

public class TestCommand1: Command {
  override public class var assignedName: String {
    return "first"
  }

  override public func execute() -> CommandOutput {
    return CommandOutput(message: ["first executed"])
  }
}

public class TestCommand: Command {
  override public class var assignedName: String {
    return "second"
  }

  override public func execute() -> CommandOutput {
    return CommandOutput(message: ["second executed"])
  }
}

public class TestCommand3: Command {
  override public class var assignedName: String {
    return "third"
  }

  override public func execute() -> CommandOutput {
    return CommandOutput(message: ["third executed"])
  }
}
