//
//  ActionResolving.swift
//  ScalsRendererFramework
//
//  Protocol for action resolvers that convert Document.Action → IR.ActionDefinition.
//

import Foundation

// MARK: - Action Resolving Protocol

/// Protocol for action resolvers that convert Document actions to IR action definitions.
///
/// Implement this protocol to create custom action resolvers.
///
/// Example:
/// ```swift
/// struct SetStateActionResolver: ActionResolving {
///     static let actionKind = Document.ActionKind.setState
///
///     func resolve(_ action: Document.Action, context: ResolutionContext) throws -> IR.ActionDefinition {
///         guard let path = action.parameters["path"]?.stringValue else {
///             throw ActionResolutionError.invalidParameters("setState requires 'path'")
///         }
///         guard let valueParam = action.parameters["value"] else {
///             throw ActionResolutionError.invalidParameters("setState requires 'value'")
///         }
///
///         var executionData: [String: AnySendable] = ["path": AnySendable(path)]
///
///         // Check if value is an expression or literal
///         if let dict = valueParam.objectValue, let expr = dict["$expr"]?.stringValue {
///             // Expression: store for evaluation at execution time
///             executionData["expression"] = AnySendable(expr)
///         } else {
///             // Literal: unwrap and store directly
///             executionData["value"] = AnySendable(StateValueConverter.unwrap(valueParam))
///         }
///
///         return IR.ActionDefinition(kind: .setState, executionData: executionData)
///     }
/// }
/// ```
public protocol ActionResolving {
    /// The action kind this resolver handles (e.g., .setState, .dismiss)
    static var actionKind: Document.ActionKind { get }

    /// Resolve a Document action into an IR action definition
    /// - Parameters:
    ///   - action: The document action with type and parameters
    ///   - context: Resolution context providing state store and document access
    /// - Returns: The fully resolved IR action definition
    /// - Throws: ActionResolutionError if resolution fails
    func resolve(
        _ action: Document.Action,
        context: ResolutionContext
    ) throws -> IR.ActionDefinition
}

// MARK: - Action Resolution Error

/// Errors that can occur during action resolution (Document → IR).
public enum ActionResolutionError: Error, CustomStringConvertible {
    /// No resolver is registered for the given action kind
    case noResolverFound(Document.ActionKind)

    /// Action parameters are invalid or missing required fields
    case invalidParameters(String)

    /// Resolution failed with an underlying error
    case resolutionFailed(String, underlyingError: Error)

    public var description: String {
        switch self {
        case .noResolverFound(let kind):
            return "No resolver registered for action kind '\(kind.rawValue)'"
        case .invalidParameters(let message):
            return "Invalid action parameters: \(message)"
        case .resolutionFailed(let kind, let error):
            return "Action resolution failed for '\(kind)': \(error.localizedDescription)"
        }
    }
}
