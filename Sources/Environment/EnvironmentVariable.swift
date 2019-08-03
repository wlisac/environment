//
//  EnvironmentVariable.swift
//  Environment
//
//  Created by Will Lisac on 7/27/19.
//

#if swift(>=5.1)
/// A property wrapper that uses the specified environment variable name for property access and backing storage.
///
/// The following example shows how to use the `EnvironmentVariable` property wrapper to expose
/// static properties backed by enviornment variables (`"HOST"` and `"PORT"`).
///
///     enum ServerSettings {
///         @EnvironmentVariable(name: "HOST")
///         static var host: URL?
///
///         @EnvironmentVariable(name: "PORT", defaultValue: 8000)
///         static var port: Int
///     }
///
@propertyWrapper
public struct EnvironmentVariable<T> {
    private let name: String
    private let defaultValue: T
    
    private let fromEnvironmentString: (String) -> T?
    private let toEnvironmentString: (T) -> String?

    /// The environment variable value converted to type `T` using the `EnvironmentStringConvertible` protocol
    /// for the specified environment variable `name` if `name` is in the environment; otherwise, the specified `defaultValue`.
    public var wrappedValue: T {
        get {
            Environment[name].flatMap { fromEnvironmentString($0) } ?? defaultValue
        }
        nonmutating set {
            Environment[name] = toEnvironmentString(newValue)
        }
    }
}

extension EnvironmentVariable where T: EnvironmentStringConvertible {
    /// Instantiates an `EnvironmentVariable` property wrapper for the specified environment variable name and default value.
    /// - Parameter name: The environment variable name to use for property access and backing storage.
    /// - Parameter defaultValue: The default value to use if the name does not exist in the environment or if type conversion fails.
    public init(name: String, defaultValue: T) {
        self.name = name
        self.defaultValue = defaultValue
        self.fromEnvironmentString = { T(environmentString: $0) }
        self.toEnvironmentString = { $0.environmentString }
    }
}

extension EnvironmentVariable {
    /// Instantiates an `EnvironmentVariable` property wrapper for the specified environment variable name and default value.
    /// - Parameter name: The environment variable name to use for property access and backing storage.
    /// - Parameter defaultValue: The default value to use if the name does not exist in the environment or if type conversion fails.
    public init<U: EnvironmentStringConvertible>(name: String, defaultValue: T = nil) where T == U? {
        self.name = name
        self.defaultValue = defaultValue
        self.fromEnvironmentString = { U(environmentString: $0) }
        self.toEnvironmentString = { $0?.environmentString }
    }
}
#endif
