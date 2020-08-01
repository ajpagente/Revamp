import XCTest

import Library
import Files

final class AppAnalyzerTests: XCTestCase {
    private var folder: Folder!
    private var resourcesFolder: Folder!
    private var ipaFile: File!

    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        folder = try! Folder.home.createSubfolderIfNeeded(withName: ".appTest")
        try! folder.empty()

        resourcesFolder = try! Folder(path: FileManager.default.currentDirectoryPath).subfolder(at: "Tests/Resources")
        ipaFile = try! resourcesFolder.file(named: "tiny.ipa")
        try! ipaFile.copy(to: folder)
        ipaFile = try! folder.file(named: "tiny.ipa")
    }

    override func tearDown() {
        try? folder.delete()
        super.tearDown()
    }

    func testGetInfo() throws {
        let groups = try AppAnalyzer.getInfo(from: ipaFile)

        XCTAssertTrue(groups.count == 4)

        let searchString = "App Name"

        let appGroup = groups.first!
        let appInfo = appGroup.lines
        let matchingStrings = appInfo.filter( { (item: String) -> Bool in
            // anchored means the match should be from the beginning of the string
            let stringMatch = item.range(of: searchString, options: .anchored) 
            return stringMatch != nil ? true : false
        })
        
        XCTAssertTrue(matchingStrings.count == 1)
    }

    static var allTests = [
        ("testGetInfo"      , testGetInfo),
    ]

}