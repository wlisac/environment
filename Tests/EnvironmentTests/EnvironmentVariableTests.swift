//
//  EnvironmentVariableTests.swift
//  EnvironmentTests
//
//  Created by Will Lisac on 7/27/19.
//

import Environment
import XCTest

//swiftlint:disable let_var_whitespace
class EnvironmentVariableTests: XCTestCase {
    override func setUp() {
        super.setUp()
        resetEnvironment()
    }
    
    func testString() {
        #if swift(>=5.1)
        XCTAssertEqual(EnvironmentSettings.string, "hello")
        
        Environment.STRING = "string"
        XCTAssertEqual(EnvironmentSettings.string, "string")
        
        Environment.STRING = nil
        XCTAssertEqual(EnvironmentSettings.string, "hello")
        
        EnvironmentSettings.string = "custom"
        XCTAssertEqual(EnvironmentSettings.string, "custom")
        XCTAssertEqual(Environment.STRING, "custom")
        #endif
    }
    
    func testOptionalString() {
        #if swift(>=5.1)
        XCTAssertNil(EnvironmentSettings.optionalString)
        
        Environment.OPTIONAL_STRING = "string"
        XCTAssertEqual(EnvironmentSettings.optionalString, "string")
        
        Environment.OPTIONAL_STRING = nil
        XCTAssertNil(EnvironmentSettings.optionalString)
        
        EnvironmentSettings.optionalString = "custom"
        XCTAssertEqual(EnvironmentSettings.optionalString, "custom")
        XCTAssertEqual(Environment.OPTIONAL_STRING, "custom")
        
        EnvironmentSettings.optionalString = nil
        XCTAssertNil(EnvironmentSettings.optionalString)
        XCTAssertNil(Environment.OPTIONAL_STRING)
        #endif
    }
    
    func testInt() {
        #if swift(>=5.1)
        XCTAssertEqual(EnvironmentSettings.int, 10)
        
        Environment.INT = 50
        XCTAssertEqual(EnvironmentSettings.int, 50)
        
        Environment.INT = nil
        XCTAssertEqual(EnvironmentSettings.int, 10)
        
        EnvironmentSettings.int = 30
        XCTAssertEqual(EnvironmentSettings.int, 30)
        XCTAssertEqual(Environment.INT, 30)
        XCTAssertEqual(Environment.INT, "30")
        #endif
    }
    
    func testOptionalInt() {
        #if swift(>=5.1)
        XCTAssertNil(EnvironmentSettings.optionalInt)
        
        Environment.OPTIONAL_INT = 10
        XCTAssertEqual(EnvironmentSettings.optionalInt, 10)
        
        Environment.OPTIONAL_INT = nil
        XCTAssertNil(EnvironmentSettings.optionalInt)
        
        EnvironmentSettings.optionalInt = 30
        XCTAssertEqual(EnvironmentSettings.optionalInt, 30)
        XCTAssertEqual(Environment.OPTIONAL_INT, 30)
        XCTAssertEqual(Environment.OPTIONAL_INT, "30")
        
        EnvironmentSettings.optionalInt = nil
        XCTAssertNil(EnvironmentSettings.optionalInt)
        XCTAssertNil(Environment.OPTIONAL_INT)
        #endif
    }
    
    func testIntArray() {
        #if swift(>=5.1)
        XCTAssertEqual(EnvironmentSettings.intArray, [])
        
        Environment.INT_ARRAY = "1,2,3"
        XCTAssertEqual(EnvironmentSettings.intArray, [1, 2, 3])
        
        Environment.INT_ARRAY = nil
        XCTAssertEqual(EnvironmentSettings.intArray, [])
        
        EnvironmentSettings.intArray = [3, 2, 1]
        XCTAssertEqual(EnvironmentSettings.intArray, [3, 2, 1])
        XCTAssertEqual(Environment.INT_ARRAY, "3,2,1")
        #endif
    }
    
    func testOptionalIntArray() {
        #if swift(>=5.1)
        XCTAssertNil(EnvironmentSettings.optionalIntArray)
        
        Environment.OPTIONAL_INT_ARRAY = [10, 20]
        XCTAssertEqual(EnvironmentSettings.optionalIntArray, [10, 20])
        
        Environment.OPTIONAL_INT_ARRAY = nil
        XCTAssertNil(EnvironmentSettings.optionalIntArray)
        
        EnvironmentSettings.optionalIntArray = [30, 40]
        XCTAssertEqual(EnvironmentSettings.optionalIntArray, [30, 40])
        XCTAssertEqual(Environment.OPTIONAL_INT_ARRAY, [30, 40])
        XCTAssertEqual(Environment.OPTIONAL_INT_ARRAY, "30,40")
        
        EnvironmentSettings.optionalIntArray = nil
        XCTAssertNil(EnvironmentSettings.optionalIntArray)
        XCTAssertNil(Environment.OPTIONAL_INT_ARRAY)
        #endif
    }
    
    private func resetEnvironment() {
        ProcessInfo.processInfo.environment.keys.forEach { unsetenv($0) }
        
        XCTAssert(ProcessInfo.processInfo.environment.isEmpty)
    }
}

#if swift(>=5.1)
enum EnvironmentSettings {
    @EnvironmentVariable(name: "STRING", defaultValue: "hello")
    static var string: String
    
    @EnvironmentVariable(name: "OPTIONAL_STRING")
    static var optionalString: String?
    
    @EnvironmentVariable(name: "INT", defaultValue: 10)
    static var int: Int
    
    @EnvironmentVariable(name: "OPTIONAL_INT")
    static var optionalInt: Int?
    
    @EnvironmentVariable(name: "INT_ARRAY", defaultValue: [])
    static var intArray: [Int]
    
    @EnvironmentVariable(name: "OPTIONAL_INT_ARRAY")
    // swiftlint:disable:next discouraged_optional_collection
    static var optionalIntArray: [Int]?
}
#endif
