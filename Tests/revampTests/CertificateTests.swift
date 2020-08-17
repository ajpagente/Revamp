import XCTest
import Foundation
import Library


final class CertificateTests: XCTestCase {
  func testInvalidInput() throws {
    var invalidInput: [CFString: Any] = [:]
    invalidInput["1.234" as CFString] = "{label = \"Issuer Name\";}"

    let commonName = "Some name" as CFString

    var thrownError: Error?
    XCTAssertThrowsError(try Certificate(results: invalidInput, commonName: commonName as String)) {
      thrownError = $0
    }

    XCTAssertTrue(
      thrownError is Certificate.InitError,
      "Unexpected error type: \(type(of: thrownError))"
    )

    XCTAssertEqual(thrownError as? Certificate.InitError, .failedToFindValue(key: "2.16.840.1.113741.2.1.1.1.6"))
  }


  static var allTests = [
    ("testInvalidInput", testInvalidInput),
  ]
}

