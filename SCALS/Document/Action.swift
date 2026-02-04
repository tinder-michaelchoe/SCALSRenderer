//
//  Action.swift
//  ScalsRendererFramework
//
//  Schema types for action definitions. These are decoded directly from JSON.
//

import Foundation

// MARK: - Action Kind

extension Document {
    /// Type-safe action kind identifier.
    ///
    /// Uses struct with static constants for compile-time safety while remaining extensible.
    /// External modules can add new action kinds without modifying core code.
    ///
    /// Built-in kinds are provided by ScalsModules:
    /// ```swift
    /// Document.ActionKind.dismiss
    /// Document.ActionKind.setState
    /// ```
    ///
    /// External modules can extend with new kinds:
    /// ```swift
    /// extension Document.ActionKind {
    ///     public static let analytics = ActionKind(rawValue: "analytics")
    /// }
    /// ```
    public struct ActionKind: Hashable, Codable, Sendable, RawRepresentable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - Action

extension Document {
    /// An action definition from JSON.
    ///
    /// Actions are decoded from the `actions` dictionary in a Document:
    /// ```json
    /// {
    ///   "actions": {
    ///     "myAction": { "type": "dismiss" },
    ///     "updateState": { "type": "setState", "path": "counter", "value": 10 }
    ///   }
    /// }
    /// ```
    ///
    /// The `type` field determines which action kind is used.
    /// All other fields are stored as parameters for resolution.
    public struct Action: Codable, Sendable {
        /// The action kind (e.g., "dismiss", "setState")
        public let type: ActionKind

        /// Dynamic parameters (all JSON fields except "type")
        public let parameters: [String: StateValue]

        public init(type: ActionKind, parameters: [String: StateValue] = [:]) {
            self.type = type
            self.parameters = parameters
        }

        // MARK: - Codable

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DynamicCodingKey.self)

            // Extract "type" field
            guard let typeKey = DynamicCodingKey(stringValue: "type"),
                  let typeString = try? container.decode(String.self, forKey: typeKey) else {
                let context = DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Action must have a 'type' field"
                )
                throw DecodingError.keyNotFound(DynamicCodingKey(stringValue: "type")!, context)
            }
            self.type = ActionKind(rawValue: typeString)

            // Extract all other fields as parameters
            var params: [String: StateValue] = [:]
            for key in container.allKeys where key.stringValue != "type" {
                if let value = try? container.decode(StateValue.self, forKey: key) {
                    params[key.stringValue] = value
                }
            }
            self.parameters = params
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: DynamicCodingKey.self)

            // Encode type field
            try container.encode(type.rawValue, forKey: DynamicCodingKey(stringValue: "type")!)

            // Encode all parameters
            for (key, value) in parameters {
                try container.encode(value, forKey: DynamicCodingKey(stringValue: key)!)
            }
        }
    }
}
