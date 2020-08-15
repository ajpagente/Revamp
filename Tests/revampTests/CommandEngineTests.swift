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
        let engine  = CommandEngine(handler: handler1)
        let input   = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])
        let actual  = engine.execute("first", input: input)

        let expected = CommandOutput(basic: ["first executed"])
        XCTAssertEqual(actual.basic, expected.basic)
    }

    func testEngineOneHandlerUnknownCommand() throws {
        let engine  = CommandEngine(handler: handler1)
        let input   = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])
        let actual  = engine.execute("abcd", input: input)

        let expected = CommandOutput(errorCode: .unknownCommand, basic: ["Unknown command"])
        XCTAssertEqual(actual.basic, expected.basic)
    }

    func testEngineTwoHandlers() throws {
        handler1.next = handler2
        let engine   = CommandEngine(handler: handler1)
        let input    = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])
        
        var actual   = engine.execute("first", input: input)
        var expected = CommandOutput(basic: ["first executed"])
        XCTAssertEqual(actual.basic, expected.basic)

        actual   = engine.execute("second", input: input)
        expected = CommandOutput(basic: ["second executed"])
        XCTAssertEqual(actual.basic, expected.basic)
    }

    func testEngineTwoHandlersUnknownCommand() throws {
        handler1.next = handler2
        let engine   = CommandEngine(handler: handler1)
        let input    = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])
        
        let actual   = engine.execute("xyz", input: input)
        let expected = CommandOutput(errorCode: .unknownCommand, basic: ["Unknown command"])
        XCTAssertEqual(actual.basic, expected.basic)
    }

    func testEngineThreeHandlers() throws {
        handler1.next = handler2
        handler2.next = handler3
        let engine   = CommandEngine(handler: handler1)
        let input    = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])

        var actual   = engine.execute("first", input: input)
        var expected = CommandOutput(basic: ["first executed"])
        XCTAssertEqual(actual.basic, expected.basic)

        actual   = engine.execute("second", input: input)
        expected = CommandOutput(basic: ["second executed"])
        XCTAssertEqual(actual.basic, expected.basic)

        actual   = engine.execute("third", input: input)
        expected = CommandOutput(basic: ["third executed"])
        XCTAssertEqual(actual.basic, expected.basic)
    }

    func testEngineThreeHandlersUnknownCommand() throws {
        handler1.next = handler2
        handler2.next = handler3
        let engine   = CommandEngine(handler: handler1)
        let input    = CommandInput(subCommand: "", arguments: [], options: [:], flags: [])

        let actual   = engine.execute("xyz", input: input)
        let expected = CommandOutput(errorCode: .unknownCommand, basic: ["Unknown command"])
        XCTAssertEqual(actual.basic, expected.basic)
    }   

    static var allTests = [
        ("testEngineOneHandler"                 , testEngineOneHandler),
        ("testEngineOneHandlerUnknownCommand"   , testEngineOneHandlerUnknownCommand),
        ("testEngineTwoHandlers"                , testEngineTwoHandlers),
        ("testEngineTwoHandlersUnknownCommand"  , testEngineTwoHandlersUnknownCommand),
        ("testEngineThreeHandlers"              , testEngineThreeHandlers),
        ("testEngineThreeHandlersUnknownCommand", testEngineThreeHandlersUnknownCommand),
    ]

}

public class TestCommand1: Command {
    public override class var assignedName: String {
        return "first"
    }

    public override func execute() -> CommandOutput {
        return CommandOutput(basic: ["first executed"])
    }
}

public class TestCommand: Command {
    public override class var assignedName: String {
        return "second"
    }

    public override func execute() -> CommandOutput {
        return CommandOutput(basic: ["second executed"])
    }
}

public class TestCommand3: Command {
    public override class var assignedName: String {
        return "third"
    }

    public override func execute() -> CommandOutput {
        return CommandOutput(basic: ["third executed"])
    }
}