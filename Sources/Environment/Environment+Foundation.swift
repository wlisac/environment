//
//  Environment+Foundation.swift
//  Environment
//
//  Created by Will Lisac on 7/23/19.
//

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import CoreGraphics
#endif

extension URL: EnvironmentStringConvertible {
    public init?(environmentString: String) {
        self.init(string: environmentString)
    }
    
    public var environmentString: String {
        return absoluteString
    }
}

extension UUID: EnvironmentStringConvertible {
    public init?(environmentString: String) {
        self.init(uuidString: environmentString)
    }
    
    public var environmentString: String {
        return uuidString
    }
}

extension CGFloat: EnvironmentStringConvertible {
    public init?(environmentString: String) {
        guard let value = NativeType(environmentString: environmentString) else {
            return nil
        }

        self.init(value)
    }

    public var environmentString: String {
        return native.environmentString
    }
}
