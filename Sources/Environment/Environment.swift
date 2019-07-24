//
//  Environment.swift
//  SwiftEnvironment
//
//  Created by Will Lisac on 7/23/19.
//

import Foundation

// MARK: - Environment

/// A type-safe interface to variables in the environment from which the process was launched.
@dynamicMemberLookup
public struct Environment {
    /// Returns the default environment for the current process.
    public static let environment = Environment()
    
    /// Accesses the environment variable associated with the given key for reading and writing.
    ///
    /// The following example sets an environment variable for `"HOST"` and gets
    /// the value for `"HOST"` from the environment.
    ///
    ///     Environment.environment["HOST"] = "example.com"
    ///     let host = Environment.environment["HOST"]
    ///
    /// - Parameter key: The key used to access the environment variable.
    /// - Returns: The environment variable value as a `String` for the given `key`
    ///   if `key` is in the environment; otherwise, `nil`.
    public subscript(key: String) -> String? {
        get {
            return getenv(key).map { String(cString: $0) }
        }
        nonmutating set {
            if let newValue = newValue {
                setenv(key, newValue, 1)
            } else {
                unsetenv(key)
            }
        }
    }

    /// Accesses the environment variable associated with the given member for reading and writing.
    ///
    /// The following example sets an environment variable for `"HOST"` and gets
    /// the value for `"HOST"` from the environment.
    ///
    ///     Environment.environment.HOST = "example.com"
    ///     let host = Environment.environment.HOST
    ///
    /// - Parameter dynamicMember: The member used to access the environment variable.
    /// - Returns: The environment variable value as a `String` for the given `dynamicMember`
    ///   if `dynamicMember` is in the environment; otherwise, `nil`.
    public subscript(dynamicMember member: String) -> String? {
        get {
            return self[member]
        }
        nonmutating set {
            self[member] = newValue
        }
    }
    
    #if swift(>=5.1)
    /// Accesses the environment variable associated with the given key for reading and writing.
    ///
    /// The following example sets an environment variable for `"HOST"` and gets
    /// the value for `"HOST"` from the environment.
    ///
    ///     Environment["HOST"] = "example.com"
    ///     let host = Environment["HOST"]
    ///
    /// - Parameter key: The key used to access the environment variable.
    /// - Returns: The environment variable value as a `String` for the given `key`
    ///   if `key` is in the environment; otherwise, `nil`.
    public static subscript(key: String) -> String? {
        get {
            environment[key]
        }
        set {
            environment[key] = newValue
        }
    }
    
    /// Accesses the environment variable associated with the given member for reading and writing.
    ///
    /// The following example sets an environment variable for `"HOST"` and gets
    /// the value for `"HOST"` from the environment.
    ///
    ///     Environment.HOST = "example.com"
    ///     let host = Environment.HOST
    ///
    /// - Parameter dynamicMember: The member used to access the environment variable.
    /// - Returns: The environment variable value as a `String` for the given `dynamicMember`
    ///   if `dynamicMember` is in the environment; otherwise, `nil`.
    public static subscript(dynamicMember member: String) -> String? {
        get {
            return self[member]
        }
        set {
            self[member] = newValue
        }
    }
    #endif
}

// MARK: - EnvironmentStringConvertible

/// A type that can be represented as an environment variable string.
public protocol EnvironmentStringConvertible {
    /// Instantiates an instance of the conforming type from an environment variable string representation.
    /// - Parameter environmentString: The string representation of the environment variable.
    init?(environmentString: String)
    
    /// The environment variable string representation of the conforming type.
    var environmentString: String { get }
}

extension Environment {
    /// Accesses the environment variable associated with the given key for reading and writing
    /// and converts type `T` using the `EnvironmentStringConvertible` protocol.
    ///
    /// The following example gets environment variables of different types from the environment.
    /// Default values are provided using the nil-coalescing operator (`??`) which also enables type inference.
    ///
    ///     let url = Environment.environment["SERVER_URL"] ?? URL(string: "https://example.com")!
    ///     let port = Environment.environment["PORT"] ?? 80
    ///
    /// Types may also be specified explicitly.
    ///
    ///     let duration: TimeInterval = Environment.environment["DURATION"] ?? 1
    ///
    /// - Parameter key: The key used to access the environment variable.
    /// - Returns: The environment variable value converted to type `T` using the `EnvironmentStringConvertible` protocol
    ///   for the given `key` if `key` is in the environment; otherwise, `nil`.
    public subscript<T>(key: String) -> T? where T: EnvironmentStringConvertible {
        get {
            return self[key].flatMap { T(environmentString: $0) }
        }
        nonmutating set {
            self[key] = newValue?.environmentString
        }
    }
    
    /// Accesses the environment variable associated with the given member for reading and writing
    /// and converts type `T` using the `EnvironmentStringConvertible` protocol.
    ///
    /// The following example gets environment variables of different types from the environment.
    /// Default values are provided using the nil-coalescing operator (`??`) which also enables type inference.
    ///
    ///     let url = Environment.environment.SERVER_URL ?? URL(string: "https://example.com")!
    ///     let port = Environment.environment.PORT ?? 80
    ///
    /// Types may also be specified explicitly.
    ///
    ///     let duration: TimeInterval = Environment.environment.DURATION ?? 1
    ///
    /// - Parameter dynamicMember: The member used to access the environment variable.
    /// - Returns: The environment variable value converted to type `T` using the `EnvironmentStringConvertible` protocol
    ///   for the given `dynamicMember` if `dynamicMember` is in the environment; otherwise, `nil`.
    public subscript<T>(dynamicMember member: String) -> T? where T: EnvironmentStringConvertible {
        get {
            return self[member]
        }
        nonmutating set {
            self[member] = newValue
        }
    }
    
    #if swift(>=5.1)
    /// Accesses the environment variable associated with the given key for reading and writing
    /// and converts type `T` using the `EnvironmentStringConvertible` protocol.
    ///
    /// The following example gets environment variables of different types from the environment.
    /// Default values are provided using the nil-coalescing operator (`??`) which also enables type inference.
    ///
    ///     let url = Environment["SERVER_URL"] ?? URL(string: "https://example.com")!
    ///     let port = Environment["PORT"] ?? 80
    ///
    /// Types may also be specified explicitly.
    ///
    ///     let duration: TimeInterval = Environment["DURATION"] ?? 1
    ///
    /// - Parameter key: The key used to access the environment variable.
    /// - Returns: The environment variable value converted to type `T` using the `EnvironmentStringConvertible` protocol
    ///   for the given `key` if `key` is in the environment; otherwise, `nil`.
    public static subscript<T>(key: String) -> T? where T: EnvironmentStringConvertible {
        get {
            environment[key]
        }
        set {
            environment[key] = newValue
        }
    }
    
    /// Accesses the environment variable associated with the given member for reading and writing
    /// and converts type `T` using the `EnvironmentStringConvertible` protocol.
    ///
    /// The following example gets environment variables of different types from the environment.
    /// Default values are provided using the nil-coalescing operator (`??`) which also enables type inference.
    ///
    ///     let url = Environment.SERVER_URL ?? URL(string: "https://example.com")!
    ///     let port = Environment.PORT ?? 80
    ///
    /// Types may also be specified explicitly.
    ///
    ///     let duration: TimeInterval = Environment.DURATION ?? 1
    ///
    /// - Parameter dynamicMember: The member used to access the environment variable.
    /// - Returns: The environment variable value converted to type `T` using the `EnvironmentStringConvertible` protocol
    ///   for the given `dynamicMember` if `dynamicMember` is in the environment; otherwise, `nil`.
    public static subscript<T>(dynamicMember member: String) -> T? where T: EnvironmentStringConvertible {
        get {
            return self[member]
        }
        set {
            self[member] = newValue
        }
    }
    #endif
}
