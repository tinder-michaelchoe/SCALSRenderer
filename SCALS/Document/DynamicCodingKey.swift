//
//  DynamicCodingKey.swift
//  ScalsRendererFramework
//
//  A coding key that can be constructed from any string value.
//  Used for dynamic JSON decoding where the set of keys is not known at compile time.
//

import Foundation

/// A coding key that can be constructed from any string value.
///
/// Used for dynamic JSON decoding where the set of keys is not known at compile time.
/// This is particularly useful when decoding action parameters where different action
/// types have different parameter names.
///
/// Example usage:
/// ```swift
/// let container = try decoder.container(keyedBy: DynamicCodingKey.self)
/// for key in container.allKeys {
///     let value = try container.decode(StateValue.self, forKey: key)
///     parameters[key.stringValue] = value
/// }
/// ```
public struct DynamicCodingKey: CodingKey {
    public var stringValue: String
    public var intValue: Int?

    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    public init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}
