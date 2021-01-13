import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SwiftyInAppMessagingTests.allTests),
    ]
}
#endif
