//
//  EnvironmentTests.swift
//  EnvironmentTests
//
//  Created by Will Lisac on 7/23/19.
//

import Environment
import XCTest

// swiftlint:disable:next type_body_length
class EnvironmentTests: XCTestCase {
    override func setUp() {
        super.setUp()
        resetEnvironment()
    }
    
    private func resetEnvironment() {
        ProcessInfo.processInfo.environment.keys.forEach { unsetenv($0) }
        
        XCTAssert(ProcessInfo.processInfo.environment.isEmpty)
    }
    
    func testSubscripts() {
        let env = Environment.environment
        
        env["HOST"] = "example.com"
        env["PORT"] = 80
        
        XCTAssertEqual(env["HOST"], "example.com")
        
        XCTAssertEqual(env["PORT"], Int(80))
        XCTAssertEqual(env["PORT"], Float(80))
        XCTAssertEqual(env["PORT"], "80")
        
        env["HOST"] = nil
        XCTAssertNil(env["HOST"])
    }
    
    func testDynamicMemberSubscripts() {
        let env = Environment.environment
        
        env.HOST = "example.com"
        env.PORT = 80
        
        XCTAssertEqual(env.HOST, "example.com")
        
        XCTAssertEqual(env.PORT, Int(80))
        XCTAssertEqual(env.PORT, Float(80))
        XCTAssertEqual(env.PORT, "80")
        
        env.HOST = nil
        XCTAssertNil(env.HOST)
    }
    
    func testStaticSubscripts() {
        #if swift(>=5.1)
        Environment["HOST"] = "example.com"
        Environment["PORT"] = 80
        
        XCTAssertEqual(Environment["HOST"], "example.com")
        
        XCTAssertEqual(Environment["PORT"], Int(80))
        XCTAssertEqual(Environment["PORT"], Float(80))
        XCTAssertEqual(Environment["PORT"], "80")
        
        Environment["HOST"] = nil
        XCTAssertNil(Environment["HOST"])
        #endif
    }
    
    func testStaticDynamicMemberSubscripts() {
        #if swift(>=5.1)
        Environment.HOST = "example.com"
        Environment.PORT = 80
        
        XCTAssertEqual(Environment.HOST, "example.com")
        
        XCTAssertEqual(Environment.PORT, Int(80))
        XCTAssertEqual(Environment.PORT, Float(80))
        XCTAssertEqual(Environment.PORT, "80")
        
        Environment.HOST = nil
        XCTAssertNil(Environment.HOST)
        #endif
    }
    
    func testStandardLibraryTypes() {
        let env = Environment.environment
        
        env.INT = "1"
        env.FLOAT = "1.0"
        env.STRING = "string"
        
        XCTAssertEqual(env.INT, Int(1))
        XCTAssertEqual(env.INT, Float(1))
        
        XCTAssertEqual(env.FLOAT, Float(1.0))
        XCTAssertEqual(env.FLOAT, Double(1.0))
        
        XCTAssertEqual(env.STRING, "string")
        
        env.INT = 10
        env.FLOAT = 10.0
        
        XCTAssertEqual(env.INT, Int(10))
        XCTAssertEqual(env.FLOAT, Float(10.0))
        XCTAssertEqual(env.FLOAT, Double(10.0))
        
        XCTAssertEqual(env.INT, "10")
        XCTAssertEqual(env.FLOAT, "10.0")
    }
    
    func testURLConformance() {
        let env = Environment.environment
        
        // swiftlint:disable:next force_unwrapping
        let url = URL(string: "https://example.com")!
        
        env.URL = url.absoluteString
        
        XCTAssertEqual(env.URL, url)
        XCTAssertEqual(env.URL, url.absoluteString)
        
        env.URL = url
        
        XCTAssertEqual(env.URL, url)
        XCTAssertEqual(env.URL, url.absoluteString)
        
        env.URL = nil
        
        XCTAssertNil(env.URL)
    }
    
    func testUUIDConformance() {
        let env = Environment.environment
        
        // swiftlint:disable:next force_unwrapping
        let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        
        env.UUID = uuid.uuidString
        
        XCTAssertEqual(env.UUID, uuid)
        XCTAssertEqual(env.UUID, uuid.uuidString)
        
        env.UUID = uuid
        
        XCTAssertEqual(env.UUID, uuid)
        XCTAssertEqual(env.UUID, uuid.uuidString)
        
        env.UUID = nil
        
        XCTAssertNil(env.UUID)
    }
    
    func testCGFloatConformance() {
        let env = Environment.environment
        
        let cgFloat = CGFloat(10.0)
        
        env.CG_FLOAT = "10.0"
        
        XCTAssertEqual(env.CG_FLOAT, cgFloat)
        XCTAssertEqual(env.CG_FLOAT, "10.0")
        
        env.CG_FLOAT = cgFloat
        
        XCTAssertEqual(env.CG_FLOAT, cgFloat)
        XCTAssertEqual(env.CG_FLOAT, "10.0")
        
        env.CG_FLOAT = "invalid"
        
        XCTAssertNil(env.CG_FLOAT as CGFloat?)
        
        env.CG_FLOAT = nil
        
        XCTAssertNil(env.CG_FLOAT)
    }
    
    func testDataConformance() {
        let env = Environment.environment
        
        let data = Data("hello".utf8)
        
        env.DATA = "hello"
        
        XCTAssertEqual(env.DATA, data)
        XCTAssertEqual(env.DATA, "hello")
        
        env.DATA = data
        
        XCTAssertEqual(env.DATA, data)
        XCTAssertEqual(env.DATA, "hello")
        
        env.DATA = nil
        
        XCTAssertNil(env.DATA)
    }
    
    func testDefaultEnumConformance() {
        // swiftlint:disable:next nesting
        enum StringEnum: String, EnvironmentStringConvertible {
            case one
            case two
        }
        
        // swiftlint:disable:next nesting
        enum IntEnum: Int, EnvironmentStringConvertible {
            case one = 1
            case two = 2
        }
        
        let env = Environment.environment
        
        env.STRING_ONE = "one"
        env.INT_TWO = "2"
        
        XCTAssertEqual(env["STRING_ONE"], StringEnum.one)
        XCTAssertEqual(env["INT_TWO"], IntEnum.two)
        
        env.STRING_ONE = StringEnum.one
        env.INT_TWO = IntEnum.two
        
        XCTAssertEqual(env["STRING_ONE"], StringEnum.one)
        XCTAssertEqual(env["INT_TWO"], IntEnum.two)
        
        env.INVALID = "invalid"
        XCTAssertNil(env.INVALID as StringEnum?)
        XCTAssertNil(env.INVALID as IntEnum?)
    }
    
    func testCustomEnumConformance() {
        // swiftlint:disable:next nesting
        enum IntEnum: Int, EnvironmentStringConvertible {
            case one = 1
            case two = 2
            
            init?(environmentString: String) {
                switch environmentString {
                case "one":
                    self = .one
                case "two":
                    self = .two
                default:
                    return nil
                }
            }
            
            var environmentString: String {
                switch self {
                case .one:
                    return "one"
                case .two:
                    return "two"
                }
            }
        }
        
        let env = Environment.environment
        
        env.CUSTOM_ENUM_ONE = "one"
        env.CUSTOM_ENUM_TWO = "two"
        
        XCTAssertEqual(env["CUSTOM_ENUM_ONE"], IntEnum.one)
        XCTAssertEqual(env["CUSTOM_ENUM_TWO"], IntEnum.two)
        
        env.customEnumOne = IntEnum.one
        env.customEnumTwo = IntEnum.two
        
        XCTAssertEqual(env["CUSTOM_ENUM_ONE"], IntEnum.one)
        XCTAssertEqual(env["CUSTOM_ENUM_TWO"], IntEnum.two)
    }
    
    func testArray() {
        let env = Environment.environment
        
        env.NUMBERS = "1,2,3"
        
        XCTAssertEqual(env.NUMBERS, ["1", "2", "3"])
        XCTAssertEqual(env.NUMBERS, [1, 2, 3])
        
        env.NUMBERS = ["4", "5", "6"]
        XCTAssertEqual(env.NUMBERS, "4,5,6")
        XCTAssertEqual(env.NUMBERS, ["4", "5", "6"])
        XCTAssertEqual(env.NUMBERS, [4, 5, 6])
        
        env.NUMBERS = [4, 5, 6]
        XCTAssertEqual(env.NUMBERS, "4,5,6")
        XCTAssertEqual(env.NUMBERS, ["4", "5", "6"])
        XCTAssertEqual(env.NUMBERS, [4, 5, 6])
    }
    
    func testSet() {
        let env = Environment.environment
        
        env.NUMBERS = "1,1,2"
        
        XCTAssertEqual(env.NUMBERS, Set(["1", "2"]))
        XCTAssertEqual(env.NUMBERS, Set([1, 2]))
        
        env.NUMBERS = Set(["4", "5", "6"])
        XCTAssertEqual(env.NUMBERS, Set(["4", "5", "6"]))
        XCTAssertEqual(env.NUMBERS, Set([4, 5, 6]))
        
        env.NUMBERS = Set([4, 5, 6])
        XCTAssertEqual(env.NUMBERS, Set(["4", "5", "6"]))
        XCTAssertEqual(env.NUMBERS, Set([4, 5, 6]))
    }
    
    func testDictionary() {
        let env = Environment.environment
        
        env.PAIRS = "one:1,two:2"
        
        XCTAssertEqual(env.PAIRS, ["one": "1", "two": "2"])
        XCTAssertEqual(env.PAIRS, ["one": 1, "two": 2])
        
        env.PAIRS = "1:one,2:two"
        
        XCTAssertEqual(env.PAIRS, ["1": "one", "2": "two"])
        XCTAssertEqual(env.PAIRS, [1: "one", 2: "two"])
        
        env.PAIRS = ["three": 3, "four": 4]
        XCTAssertEqual(env.PAIRS, ["three": 3, "four": 4])
    }
    
    func testEmptyStringArray() {
        let env = Environment.environment
        
        env.EMPTY_STRING = ""
        
        XCTAssertEqual(env.EMPTY_STRING, [""])
        XCTAssertNil(env.EMPTY_STRING as [Int]?)
        
        env.EMPTY_STRING_COMPONENTS = ","
        
        XCTAssertEqual(env.EMPTY_STRING_COMPONENTS, ["", ""])
        XCTAssertNil(env.EMPTY_STRING_COMPONENTS as [Int]?)
    }
    
    func testEmptyStringSet() {
        let env = Environment.environment
        
        env.EMPTY_STRING = ""
        
        XCTAssertEqual(env.EMPTY_STRING, Set([""]))
        XCTAssertNil(env.EMPTY_STRING as Set<Int>?)
        
        env.EMPTY_STRING_COMPONENTS = ","
        
        XCTAssertEqual(env.EMPTY_STRING_COMPONENTS, Set([""]))
        XCTAssertNil(env.EMPTY_STRING_COMPONENTS as Set<Int>?)
    }
    
    func testEmptyStringDictionary() {
        let env = Environment.environment
        
        env.EMPTY_STRING = ""
        
        XCTAssertNil(env.EMPTY_STRING as [String : String]?)

        env.EMPTY_STRING_COMPONENTS = ":"
        
        XCTAssertEqual(env.EMPTY_STRING_COMPONENTS, ["" : ""])
        XCTAssertNil(env.EMPTY_STRING_COMPONENTS as [String : Int]?)
    }
}
