# 🌳 Environment

![swift](https://img.shields.io/badge/Swift-5.0%20%7C%205.1-orange.svg)
![platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20Linux%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg)
![version](https://img.shields.io/badge/version-0.11.1-blue.svg)
[![twitter](https://img.shields.io/badge/twitter-@wlisac-blue.svg)](https://twitter.com/wlisac)
<br>
[![build](https://travis-ci.com/wlisac/environment.svg?branch=master)](https://travis-ci.com/wlisac/environment)
[![jazzy](https://raw.githubusercontent.com/wlisac/environment/gh-pages/badge.svg?sanitize=true)](https://wlisac.github.io/environment/Structs/Environment.html)
[![codecov](https://img.shields.io/codecov/c/github/wlisac/environment)](https://codecov.io/gh/wlisac/environment)

Welcome to **Environment** – a nicer, type-safe way of working with environment variables in Swift.

## Usage

### Access Environment Variables

The `Environment` struct provides a type-safe API to get and set environment variables.

```swift
import Environment

let environment = Environment.environment

// Get "HOST" as String value
let host = environment["HOST"]

// Set "PORT" to String value of "8000"
environment["PORT"] = "8000"
```

Environment variables are accessed as `String` values by default, but can be [converted](#type-safe-variables) to any type that conforms to `EnvironmentStringConvertible`.

```swift
// Get "HOST" as URL value
let host: URL? = environment["HOST"]

// Get "PORT" as Int value
let port: Int? = environment["PORT"]

// Set "PORT" to Int value of 8000
environment["PORT"] = 8000

// Get "APP_ID" as UUID value or use a default UUID if "APP_ID" is not set
let appID = environment["APP_ID"] ?? UUID()
```

### Dynamic Member Lookup

The `Environment` struct also supports accessing environment variables using `@dynamicMemberLookup`.

```swift
// Get "HOST" as URL value using dynamic member lookup
let host: URL? = environment.HOST

// Set "PORT" to Int value of 8000 using dynamic member lookup
environment.PORT = 8000
```

### Static Subscripts

The `Environment` struct supports [static subscript](https://github.com/apple/swift-evolution/blob/master/proposals/0254-static-subscripts.md) access to environment variables in Swift 5.1.

```swift
import Environment
import Foundation

// Get "HOST" as URL value using static subscript
let host: URL? = Environment["HOST"]

// Set "PORT" to Int value of 8000 using static subscript
Environment["PORT"] = 8000
```

`@dynamicMemberLookup` also works with static subscripts.

```swift
// Get "HOST" as URL value using static dynamic member lookup
let host: URL? = Environment.HOST

// Set "PORT" to Int value of 8000 using static dynamic member lookup
Environment.PORT = 8000
```

### Property Wrappers

The `EnvironmentVariable` [property wrapper](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md) enables properties to be backed by environment variables in Swift 5.1.

The following example shows how to use the `EnvironmentVariable` property wrapper to expose static properties backed by enviornment variables (`"HOST"` and `"PORT"`).

```swift
enum ServerSettings {
    @EnvironmentVariable(name: "HOST")
    static var host: URL?
    
    @EnvironmentVariable(name: "PORT", defaultValue: 8000)
    static var port: Int
}
```

### Type-Safe Variables

Environment variables can be converted from a `String` representation to any type that conforms to the `EnvironmentStringConvertible` protocol.

Standard Library and Foundation types like `Int`, `Float`, `Double`, `Bool`, `URL`, `UUID`, `Data`, and more are already extended to conform to `EnvironmentStringConvertible`. Collection types like  `Array`, `Set`, and `Dictionary` are also extended with conditional conformance.

You can add conformance to other classes, structures, or enumerations to enable additional types to be used as environment variables.

**Custom `EnvironmentStringConvertible` Conformance**

```swift
enum Beverage {
    case coffee
    case tea
}

extension Beverage: EnvironmentStringConvertible {
    init?(environmentString: String) {
        switch environmentString {
        case "coffee":
            self = .coffee
        case "tea":
            self = .tea
        default:
            return nil
        }
    }
    
    var environmentString: String {
        switch self {
        case .coffee:
            return "coffee"
        case .tea:
            return "tea"
        }
    }
}

let beverage: Beverage? = environment["DEFAULT_BEVERAGE"]
```

**Default `EnvironmentStringConvertible` Conformance**

A default implementation of `EnvironmentStringConvertible` is provided for types that already conform to `LosslessStringConvertible` or `RawRepresentable`.

For example, `String`-backed enums are `RawRepresentable` and may use the default implementation for `EnvironmentStringConvertible` conformance.

```swift
enum CompassPoint: String {
    case north
    case south
    case east
    case west
}

extension CompassPoint: EnvironmentStringConvertible { }

let defaultDirection: CompassPoint? = environment["DEFAULT_DIRECTION"]
```

## API Documentation

Visit the [online API reference](https://wlisac.github.io/environment/Structs/Environment.html) for full documentation of the public API.

## Installation

Environment requires Xcode 10 or a Swift 5 toolchain with the Swift Package Manager. 

### Swift Package Manager

Add the Environment package as a dependency to your `Package.swift` file.

```swift
.package(url: "https://github.com/wlisac/environment.git", from: "0.11.1")
```

Add Environment to your target's dependencies.

```swift
.target(name: "Example", dependencies: ["Environment"])
```
