import XCTest

import revampTests

var tests = [XCTestCaseEntry]()
tests += revampTests.allTests()
XCTMain(tests)
