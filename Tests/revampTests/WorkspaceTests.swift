import XCTest

import Command
import Files

final class WorkspaceTests: XCTestCase {
    private var folder: Folder!
    private var resourcesFolder: Folder!
    private var payloadFolder: Folder!

    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        folder = try! Folder.home.createSubfolderIfNeeded(withName: ".workspaceTest")
        try! folder.empty()

        resourcesFolder = try! Folder(path: FileManager.default.currentDirectoryPath).subfolder(at: "Tests/Resources")
        payloadFolder = try! Folder(path: FileManager.default.currentDirectoryPath).subfolder(at: "Tests/Resources/ex-tiny")
    }

    override func tearDown() {
        try? folder.delete()
        super.tearDown()
    }
    
    // MARK: - Tests

    func testCreate() throws {
        let workspace = try Workspace()
        XCTAssertEqual(workspace.outputFolder.name, "out")
        XCTAssertEqual(workspace.inputFolder.name, "in")
        XCTAssertEqual(workspace.tempFolder.name, "tmp")
    }

    func testWrite() throws {
        let workspace = try Workspace()

        let file = try folder.createFile(named: "test.txt")
        try file.write("content")

        try workspace.writeFile(file, to: .input)
        XCTAssertTrue(workspace.inputFolder.containsFile(named: "test.txt"))

        try workspace.writeFile(file, to: .output)
        XCTAssertTrue(workspace.outputFolder.containsFile(named: "test.txt"))

        try workspace.writeFile(file, to: .temporary)
        XCTAssertTrue(workspace.tempFolder.containsFile(named: "test.txt"))
    }

    func testCompressFolder() throws {
        let workspace = try Workspace()

        try workspace.compressFolder(payloadFolder, to: .input, with: "tiny.ipa")
        XCTAssertTrue(workspace.inputFolder.containsFile(named: "tiny.ipa"))

        try workspace.compressFolder(payloadFolder, to: .output, with: "tiny.ipa")
        XCTAssertTrue(workspace.outputFolder.containsFile(named: "tiny.ipa"))
        
        try workspace.compressFolder(payloadFolder, to: .temporary, with: "tiny.ipa")
        XCTAssertTrue(workspace.tempFolder.containsFile(named: "tiny.ipa"))

        try workspace.emptyFolders()
    }

    func testWriteWithDecompress() throws {
        let zipFile   = try resourcesFolder.file(named: "tiny.ipa")
        let workspace = try Workspace()

        try workspace.writeFile(zipFile, to: .input, decompress: true)
        XCTAssertTrue(workspace.inputFolder.containsSubfolder(named: "Payload"))

        try workspace.writeFile(zipFile, to: .output, decompress: true)
        XCTAssertTrue(workspace.outputFolder.containsSubfolder(named: "Payload"))

        try workspace.writeFile(zipFile, to: .temporary, decompress: true)
        XCTAssertTrue(workspace.tempFolder.containsSubfolder(named: "Payload"))

        try workspace.emptyFolders()
    }

    func testCopyFile() throws {
        let workspace = try Workspace()

        let file = try folder.createFile(named: "test.txt")
        try file.write("content")
        try workspace.writeFile(file, to: .output)

        let destinationFolder = try folder.createSubfolder(named: "target")
        try workspace.copyFileFromOutput(named: "test.txt", to: destinationFolder)
        XCTAssertTrue(destinationFolder.containsFile(named: "test.txt"))
    }

    func testEmptyFolders() throws {
        let workspace = try Workspace()

        let file = try folder.createFile(named: "test.txt")
        try file.write("content")

        try workspace.writeFile(file, to: .input)
        try workspace.writeFile(file, to: .output)
        try workspace.writeFile(file, to: .temporary)

        XCTAssertTrue(workspace.inputFolder.containsFile(named: "test.txt"))
        XCTAssertTrue(workspace.outputFolder.containsFile(named: "test.txt"))
        XCTAssertTrue(workspace.tempFolder.containsFile(named: "test.txt"))

        try workspace.emptyFolders()

        XCTAssertFalse(workspace.inputFolder.containsFile(named: "test.txt"))
        XCTAssertFalse(workspace.outputFolder.containsFile(named: "test.txt"))
        XCTAssertFalse(workspace.tempFolder.containsFile(named: "test.txt"))
    }

    static var allTests = [
        ("testCreate"      , testCreate),
        ("testWrite"       , testWrite),
        ("testCompressFolder", testCompressFolder),
        ("testWriteWithDecompress", testWriteWithDecompress),
        ("testCopyFile"    , testCopyFile),
        ("testEmptyFolders", testEmptyFolders),
    ]
}