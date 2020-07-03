import XCTest

@testable import Command
import Files

final class WorkspaceTests: XCTestCase {
    private var folder: Folder!

    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        folder = try! Folder.home.createSubfolderIfNeeded(withName: ".workspaceTest")
        try! folder.empty()
    }

    override func tearDown() {
        try? folder.delete()
        super.tearDown()
    }
    
    // MARK: - Tests

    func testWorkspaceCreate() throws {
        let workspace = try Workspace()
        XCTAssertEqual(workspace.outputFolder.name, "out")
        XCTAssertEqual(workspace.inputFolder.name, "in")
    }

    func testWorkspaceWrite() throws {
        let workspace = try Workspace()
        XCTAssertEqual(workspace.outputFolder.name, "out")
        XCTAssertEqual(workspace.inputFolder.name, "in")

        let file = try folder.createFile(named: "test.txt")
        try file.write("content")

        try workspace.writeFile(file, to: .input)
        XCTAssertTrue(workspace.inputFolder.containsFile(named: "test.txt"))
    }


    static var allTests = [
        ("testWorkspaceCreate", testWorkspaceCreate),
        ("testWorkspaceWrite",  testWorkspaceWrite),
    ]
}