//
//  AnySendable.swift
//  ScalsRendererFramework
//
//  Thread-safe wrapper for Any type.
//

import Foundation

/// Thread-safe wrapper for Any type.
///
/// This wrapper makes `Any` conforming to `Sendable` by marking it as `@unchecked Sendable`.
/// Users of this type must ensure the wrapped value is actually thread-safe.
///
/// Used primarily in `IR.ActionDefinition.executionData` where we store resolved
/// action parameters in a type-erased dictionary.
public struct AnySendable: @unchecked Sendable {
    /// The wrapped value
    public let value: Any

    /// Creates a new AnySendable wrapper
    /// - Parameter value: The value to wrap
    public init(_ value: Any) {
        self.value = value
    }
}

// MARK: - Convenience Accessors

extension AnySendable {
    /// Attempts to cast the wrapped value to a specific type
    public func `as`<T>(_ type: T.Type) -> T? {
        return value as? T
    }

    /// Attempts to cast the wrapped value to a specific type, throwing if it fails
    /// Note: ActionExecutionError is defined in ActionErrors.swift to avoid circular dependencies
    public func require<T>(_ type: T.Type, key: String) throws -> T {
        guard let typed = value as? T else {
            throw ActionExecutionError.invalidParameterType(
                key,
                expected: String(describing: T.self),
                got: String(describing: Swift.type(of: value))
            )
        }
        return typed
    }
}
