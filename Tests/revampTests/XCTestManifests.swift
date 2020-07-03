import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        // testCase(revampTests.allTests),
        testCase(WorkspaceTests.allTests),
    ]
}
#endif
