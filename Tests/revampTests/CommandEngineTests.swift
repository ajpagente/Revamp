import XCTest

import Library

final class CommandEngineTests: XCTestCase {
    private var handler1: CommandHandler!
    private var handler2: CommandHandler!
    private var handler3: CommandHandler!

    override func setUp() {
        super.setUp()
        handler1 = CommandHandler(commandType: TestCommand1.self)
        handler2 = CommandHandler(commandType: TestCommand2.self)
        handler3 = CommandHandler(commandType: TestCommand3.self)
    }

    func testEngineOneHandler() throws {
        let engine  = CommandEngine(handler: handler1)
        let input   = CommandInput()
        let actual  = engine.execute("first", input: input)

        let expected = CommandOutput2(simple: ["first executed"],
                                      verbose: ["first executed"])
        XCTAssertEqual(actual.simple, expected.simple)
    }

    func testEngineOneHandlerUnknownCommand() throws {
        let engine  = CommandEngine(handler: handler1)
        let input   = CommandInput()
        let actual  = engine.execute("abcd", input: input)

        let expected = CommandOutput2(simple: ["Unknown command"],
                                      verbose: ["Unknown command"])
        XCTAssertEqual(actual.simple, expected.simple)
    }

    func testEngineTwoHandlers() throws {
        handler1.next = handler2
        let engine   = CommandEngine(handler: handler1)
        let input    = CommandInput()
        
        var actual   = engine.execute("first", input: input)
        var expected = CommandOutput2(simple: ["first executed"],
                                      verbose: ["first executed"])
        XCTAssertEqual(actual.simple, expected.simple)

        actual   = engine.execute("second", input: input)
        expected = CommandOutput2(simple: ["second executed"],
                                      verbose: ["second executed"])
        XCTAssertEqual(actual.simple, expected.simple)
    }

    func testEngineTwoHandlersUnknownCommand() throws {
        handler1.next = handler2
        let engine   = CommandEngine(handler: handler1)
        let input    = CommandInput()
        
        let actual   = engine.execute("xyz", input: input)
        let expected = CommandOutput2(simple: ["Unknown command"],
                                      verbose: ["Unknown command"])
        XCTAssertEqual(actual.simple, expected.simple)
    }

    func testEngineThreeHandlers() throws {
        handler1.next = handler2
        handler2.next = handler3
        let engine   = CommandEngine(handler: handler1)
        let input    = CommandInput()

        var actual   = engine.execute("first", input: input)
        var expected = CommandOutput2(simple: ["first executed"],
                                      verbose: ["first executed"])
        XCTAssertEqual(actual.simple, expected.simple)

        actual   = engine.execute("second", input: input)
        expected = CommandOutput2(simple: ["second executed"],
                                      verbose: ["second executed"])
        XCTAssertEqual(actual.simple, expected.simple)

        actual   = engine.execute("third", input: input)
        expected = CommandOutput2(simple: ["third executed"],
                                      verbose: ["third executed"])
        XCTAssertEqual(actual.simple, expected.simple)
    }

    func testEngineThreeHandlersUnknownCommand() throws {
        handler1.next = handler2
        handler2.next = handler3
        let engine   = CommandEngine(handler: handler1)
        let input    = CommandInput()

        let actual   = engine.execute("xyz", input: input)
        let expected = CommandOutput2(simple: ["Unknown command"],
                                      verbose: ["Unknown command"])
        XCTAssertEqual(actual.simple, expected.simple)
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

public class TestCommand1: Command2 {
    public override class var assignedName: String {
        return "first"
    }

    public override func execute() -> CommandOutput2 {
        return CommandOutput2(simple: ["first executed"],
                             verbose: ["first executed"])
    }
}

public class TestCommand2: Command2 {
    public override class var assignedName: String {
        return "second"
    }

    public override func execute() -> CommandOutput2 {
        return CommandOutput2(simple: ["second executed"],
                             verbose: ["second executed"])
    }
}

public class TestCommand3: Command2 {
    public override class var assignedName: String {
        return "third"
    }

    public override func execute() -> CommandOutput2 {
        return CommandOutput2(simple: ["third executed"],
                             verbose: ["third executed"])
    }
}