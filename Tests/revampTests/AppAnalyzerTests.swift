import XCTest

import Library
import Files


final class AppAnalyzerTests: XCTestCase {
  private var folder: Folder!
  private var ipaFile: File!
  private var invalidFile: File!

  // MARK: - XCTestCase
  override func setUp() {
    super.setUp()
    folder = try! Folder.home.createSubfolderIfNeeded(withName: ".appTest")
    try! folder.empty()

    let resourcesFolder = try! Folder(path: FileManager.default.currentDirectoryPath).subfolder(at: "Tests/Resources")
    ipaFile = try! resourcesFolder.file(named: "tiny.ipa")
    try! ipaFile.copy(to: folder)
    ipaFile = try! folder.file(named: "tiny.ipa")

    invalidFile = try! folder.createFile(named: "not-an.ipa")
  }

  override func tearDown() {
    try? folder.delete()
    super.tearDown()
  }

  func testGetAllInfo() throws {
    let groups = try AppAnalyzer.getAllInfo(from: ipaFile)

    XCTAssertEqual(groups.count, 5)

    var matchedContent: [String] = findString("App Name:", in: groups[0].lines)
    XCTAssertTrue(matchedContent.count == 1)

    matchedContent = findString("Profile Name:", in: groups[1].lines)
    XCTAssertTrue(matchedContent.count == 1)

    matchedContent = findString("Debuggable:", in: groups[2].lines)
    XCTAssertTrue(matchedContent.count == 1)

    matchedContent = findString("Common Name:", in: groups[3].lines)
    XCTAssertTrue(matchedContent.count == 1)
  }

  func testGetLimitedInfo() throws {
    let groups = try AppAnalyzer.getLimitedInfo(from: ipaFile)

    XCTAssertEqual(groups.count, 3)

    var matchedContent: [String] = findString("App Name:", in: groups[0].lines)
    XCTAssertTrue(matchedContent.count == 1)

    matchedContent = findString("Profile Name:", in: groups[1].lines)
    XCTAssertTrue(matchedContent.count == 1)

    matchedContent = findString("Debuggable:", in: groups[2].lines)
    XCTAssertTrue(matchedContent.count == 1)
  }

  func testInvalidFile() throws {
    XCTAssertThrowsError(try AppAnalyzer.getLimitedInfo(from: invalidFile))
    XCTAssertThrowsError(try AppAnalyzer.getAllInfo(from: invalidFile))
  }

  private func findString(_ substring: String, in contents: [String]) -> [String] {
    let matchedContent = contents.filter( { (item: String) -> Bool in
        // anchored means the match should be from the beginning of the string
        let stringMatch = item.range(of: substring, options: .anchored) 
        return stringMatch != nil ? true : false
    })

    return matchedContent
  }

  static var allTests = [
    ("testGetAllInfo", testGetAllInfo),
    ("testGetLimitedInfo", testGetLimitedInfo),
    ("testInvalidFile", testInvalidFile),
  ]
}