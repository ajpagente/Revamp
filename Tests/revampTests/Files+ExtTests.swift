import XCTest
import Library
import Files

final class FilesExtTests: XCTestCase {
    private var resourcesFolder: Folder!

    override func setUp() {
        super.setUp()
        resourcesFolder = try! Folder(path: FileManager.default.currentDirectoryPath).subfolder(at: "Tests/Resources")
    }

    func testFindFolders() throws {
        let workspace = try Workspace()
        let ipa   = try resourcesFolder.file(named: "tiny.ipa")
        try workspace.writeFile(ipa, to: .input, decompress: true)

        let inputFolder = workspace.inputFolder
        let foldersFound = inputFolder.findSubfolders(withExtension: [".app"])

        XCTAssertEqual(foldersFound.count, 1)
        XCTAssertEqual(foldersFound[0].name, "XCConfig Signing.app")

        try workspace.emptyFolders()
    }

    static var allTests = [
        ("testFindFolders"      , testFindFolders),
    ]
}