//
//  ActionDefinition.swift
//  ScalsRendererFramework
//
//  Intermediate Representation (IR) for actions.
//  These are fully resolved action definitions ready for execution.
//
//  **Important**: This file should remain platform-agnostic. Do NOT import
//  SwiftUI or UIKit here. Platform-specific conversions belong in the
//  renderer layer.
//

import Foundation

// MARK: - Typealiases for Backward Compatibility

/// Backward compatibility typealias
public typealias ActionDefinition = IR.ActionDefinition

// MARK: - IR Namespace Extension

extension IR {
    /// Fully resolved action definition ready for execution.
    ///
    /// This is a dynamic struct (not an enum) to support extensible action types.
    /// All resolution logic has been completed - this contains final, executable data.
    ///
    /// ## Thread Safety
    /// Uses `AnySendable` wrapper for `executionData` to maintain `Sendable` conformance
    /// while allowing storage of arbitrary types.
    ///
    /// ## Usage
    /// Resolvers create ActionDefinitions with primitive data:
    /// ```swift
    /// let definition = IR.ActionDefinition(
    ///     kind: .setState,
    ///     executionData: [
    ///         "path": AnySendable("user.name"),
    ///         "value": AnySendable("John")
    ///     ]
    /// )
    /// ```
    ///
    /// Handlers extract parameters using type-safe accessors:
    /// ```swift
    /// let path: String = try definition.requiredParameter("path")
    /// let value: Any = try definition.requiredParameter("value")
    /// ```
    public struct ActionDefinition: Sendable {
        /// The kind of action (e.g., .setState, .dismiss, .navigate)
        public let kind: Document.ActionKind

        /// Resolved execution data (parameter name → value)
        /// Uses AnySendable wrapper for thread safety
        public let executionData: [String: AnySendable]

        public init(kind: Document.ActionKind, executionData: [String: AnySendable] = [:]) {
            self.kind = kind
            self.executionData = executionData
        }

        // MARK: - Type-Safe Parameter Accessors

        /// Get an optional parameter with type casting
        /// - Parameter key: The parameter name
        /// - Returns: The typed value, or nil if not found or wrong type
        public func parameter<T>(_ key: String) -> T? {
            return executionData[key]?.value as? T
        }

        /// Get a required parameter with type casting
        /// - Parameter key: The parameter name
        /// - Returns: The typed value
        /// - Throws: ActionExecutionError if parameter is missing or has wrong type
        public func requiredParameter<T>(_ key: String) throws -> T {
            guard let wrapper = executionData[key] else {
                throw ActionExecutionError.missingParameter(key)
            }
            guard let typed = wrapper.value as? T else {
                throw ActionExecutionError.invalidParameterType(
                    key,
                    expected: String(describing: T.self),
                    got: String(describing: type(of: wrapper.value))
                )
            }
            return typed
        }
    }
}
