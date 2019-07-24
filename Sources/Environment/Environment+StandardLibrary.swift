//
//  Environment+StandardLibrary.swift
//  Environment
//
//  Created by Will Lisac on 7/23/19.
//

public extension EnvironmentStringConvertible where Self: LosslessStringConvertible {
    init?(environmentString: String) {
        self.init(environmentString)
    }
    
    var environmentString: String {
        return String(describing: self)
    }
}

public extension EnvironmentStringConvertible where Self: RawRepresentable, Self.RawValue: EnvironmentStringConvertible {
    init?(environmentString: String) {
        guard let rawValue = RawValue(environmentString: environmentString) else {
            return nil
        }
        self.init(rawValue: rawValue)
    }
    
    var environmentString: String {
        return rawValue.environmentString
    }
}

extension String: EnvironmentStringConvertible { }
extension Unicode.Scalar: EnvironmentStringConvertible { }

extension Float: EnvironmentStringConvertible { }
extension Double: EnvironmentStringConvertible { }

#if !os(Windows) && (arch(i386) || arch(x86_64))
extension Float80: EnvironmentStringConvertible { }
#endif

extension Int: EnvironmentStringConvertible { }
extension Int8: EnvironmentStringConvertible { }
extension Int16: EnvironmentStringConvertible { }
extension Int32: EnvironmentStringConvertible { }
extension Int64: EnvironmentStringConvertible { }

extension UInt: EnvironmentStringConvertible { }
extension UInt8: EnvironmentStringConvertible { }
extension UInt16: EnvironmentStringConvertible { }
extension UInt32: EnvironmentStringConvertible { }
extension UInt64: EnvironmentStringConvertible { }

extension Bool: EnvironmentStringConvertible { }

extension Array: EnvironmentStringConvertible where Element: EnvironmentStringConvertible {
    /// Instantiates an `Array<Element>` from an environment variable string representation
    /// where the `Element` conforms to `EnvironmentStringConvertible`.
    ///
    /// Elements must be comma (`,`) separated in the string representation.
    ///
    ///     let strings = [String](environmentString: "one,two,three")
    ///     print(strings)
    ///     // Prints "Optional(["one", "two", "three"])"
    ///
    ///     let numbers = [Int](environmentString: "1,2,3")
    ///     print(numbers)
    ///     // Prints "Optional([1, 2, 3])"
    ///
    /// This enables setting and getting an array using the `Environment`.
    ///
    ///     Environment.environment.NAMES = ["bob", "billy"]
    ///     // Sets a string value of "bob,billy"
    ///
    ///     let names: [String]? = Environment.environment.NAMES
    ///     // Gets an array of ["bob", "billy"]
    ///
    /// - Parameter environmentString: The string representation of the environment variable.
    public init?(environmentString: String) {
        var elements = [Element]()

        for string in environmentString.components(separatedBy: ",") {
            guard let element = Element(environmentString: String(string)) else {
                return nil
            }
            elements.append(element)
        }

        self = elements
    }
    
    /// The environment variable string representation.
    ///
    /// Elements are comma (`,`) separated.
    ///
    ///     let numbers = [1,2,3]
    ///     print(numbers.environmentString)
    ///     // Prints "1,2,3"
    ///
    public var environmentString: String {
        return map { $0.environmentString }.joined(separator: ",")
    }
}

extension Set: EnvironmentStringConvertible where Element: EnvironmentStringConvertible {
    /// Instantiates a `Set<Element>` from an environment variable string representation
    /// where the `Element` conforms to `EnvironmentStringConvertible`.
    ///
    /// Elements must be comma (`,`) separated in the string representation.
    ///
    ///     let strings = Set<String>(environmentString: "one,one,two,three")
    ///     print(strings)
    ///     // Prints "Optional(Set(["three", "two", "one"]))"
    ///
    ///     let numbers = Set<Int>(environmentString: "1,1,2,3")
    ///     print(numbers)
    ///     // Prints "Optional(Set([1, 3, 2]))"
    ///
    /// This enables setting and getting a set using the `Environment`.
    ///
    ///     Environment.environment.NAMES = Set<String>(["bob", "billy"])
    ///     // Sets a string value of "bob,billy"
    ///
    ///     let names: Set<String>? = Environment.environment.NAMES
    ///     // Gets a set of Set(["bob", "billy"])
    ///
    /// - Parameter environmentString: The string representation of the environment variable.
    public init?(environmentString: String) {
        guard let array = [Element](environmentString: environmentString) else { return nil }
        self = Set(array)
    }
    /// The environment variable string representation.
    ///
    /// Elements are comma (`,`) separated.
    ///
    ///     let numbers = Set([1,2,3])
    ///     print(numbers.environmentString)
    ///     // Prints "1,2,3"
    ///
    public var environmentString: String {
        return Array(self).environmentString
    }
}

extension Dictionary: EnvironmentStringConvertible where Key: EnvironmentStringConvertible, Value: EnvironmentStringConvertible {
    /// Instantiates a `Dictionary<Key, Value>` from an environment variable string representation
    /// where the `Key` and `Value` conform to `EnvironmentStringConvertible`.
    ///
    /// Elements must be comma (`,`) separated and key/value pairs must be colon (`:`) separated in the string representation.
    ///
    ///     let numbers = [String : Int](environmentString: "one:1,two:2,three:3")
    ///     print(numbers)
    ///     // Prints "Optional(["one": 1, "three": 3, "two": 2])"
    ///
    /// This enables setting and getting a dictionary using the `Environment`.
    ///
    ///     Environment.environment.NUMBERS = ["one":1,"two":2,"three":3]
    ///     // Sets a string value of "one:1,two:2,three:3"
    ///
    ///     let numbers: [String : Int]? = Environment.environment.NUMBERS
    ///     // Gets a dictionary of ["one":1,"two":2,"three":3]
    ///
    /// - Parameter environmentString: The string representation of the environment variable.
    public init?(environmentString: String) {
        var keysAndValues = [Key : Value]()
        
        for keyValueString in environmentString.components(separatedBy: ",") {
            let stringPair = keyValueString.components(separatedBy: ":")
            guard stringPair.count == 2 else {
                return nil
            }
            guard let key = Key(environmentString: stringPair[0]),
                let value = Value(environmentString: stringPair[1]) else {
                    return nil
            }
            keysAndValues[key] = value
        }
        
        self = keysAndValues
    }
    
    /// The environment variable string representation.
    ///
    /// Elements are comma (`,`) separated and key/value pairs are colon (`:`) separated.
    ///
    ///     let numbers = ["one": 1, "two": 2, "three": 3]
    ///     print(numbers.environmentString)
    ///     // Prints "one:1,two:2,three:3"
    ///
    public var environmentString: String {
        return map { key, value in
            return "\(key.environmentString):\(value.environmentString)"
        }.joined(separator: ",")
    }
}
