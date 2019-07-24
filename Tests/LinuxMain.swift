import XCTest

import EnvironmentTests

var tests = [XCTestCaseEntry]()
tests += EnvironmentTests.__allTests()

XCTMain(tests)
