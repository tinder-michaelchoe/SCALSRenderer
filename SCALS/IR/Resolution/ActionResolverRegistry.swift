//
//  ActionResolverRegistry.swift
//  ScalsRendererFramework
//
//  Registry for action resolvers that convert Document.Action → IR.ActionDefinition.
//

import Foundation
#if !arch(wasm32)
import Dispatch
#endif

// MARK: - Action Resolver Registry

/// Registry for action resolvers.
///
/// This registry stores resolvers that convert Document actions into IR action definitions.
/// Resolvers are looked up by action kind (e.g., "setState", "dismiss", "navigate").
///
/// ## Thread Safety
/// This class uses conditional locking based on the platform:
/// - **WebAssembly**: No synchronization (single-threaded)
/// - **Other platforms**: Uses DispatchQueue for thread-safe access
///
/// ## Usage
/// ```swift
/// let registry = ActionResolverRegistry()
/// registry.register(SetStateActionResolver())
/// registry.register(DismissActionResolver())
///
/// let action = Document.Action(type: .setState, parameters: ["path": "counter", "value": 1])
/// let resolved = try registry.resolve(action, context: context)
/// ```
public final class ActionResolverRegistry: @unchecked Sendable {

    private var resolvers: [String: any ActionResolving] = [:]

    #if !arch(wasm32)
    private let queue = DispatchQueue(label: "com.scals.actionresolverregistry")
    #endif

    public init() {}

    // MARK: - Registration

    /// Register an action resolver
    /// - Parameter resolver: The resolver instance to register
    public func register<T: ActionResolving>(_ resolver: T) {
        let kindString = T.actionKind.rawValue
        #if arch(wasm32)
        resolvers[kindString] = resolver
        #else
        queue.sync {
            resolvers[kindString] = resolver
        }
        #endif
    }

    /// Check if a resolver is registered for the given action kind
    /// - Parameter kind: The action kind to check
    /// - Returns: True if a resolver is registered
    public func hasResolver(for kind: Document.ActionKind) -> Bool {
        #if arch(wasm32)
        return resolvers[kind.rawValue] != nil
        #else
        return queue.sync {
            resolvers[kind.rawValue] != nil
        }
        #endif
    }

    // MARK: - Resolution

    /// Resolve a single Document action into an IR action definition
    /// - Parameters:
    ///   - action: The document action to resolve
    ///   - context: Resolution context providing state store and document access
    /// - Returns: The resolved IR action definition
    /// - Throws: ActionResolutionError if resolution fails (but NOT if no resolver is found - creates pass-through instead)
    public func resolve(
        _ action: Document.Action,
        context: ResolutionContext
    ) throws -> IR.ActionDefinition {
        let resolver: (any ActionResolving)?

        #if arch(wasm32)
        resolver = resolvers[action.type.rawValue]
        #else
        resolver = queue.sync {
            resolvers[action.type.rawValue]
        }
        #endif

        // If no resolver found, create a pass-through IR.ActionDefinition
        // This allows custom actions (registered only as handlers) to work in sequences
        guard let resolver = resolver else {
            var executionData: [String: AnySendable] = [:]
            for (key, value) in action.parameters {
                executionData[key] = AnySendable(StateValueConverter.unwrap(value))
            }
            return IR.ActionDefinition(kind: action.type, executionData: executionData)
        }

        do {
            return try resolver.resolve(action, context: context)
        } catch let error as ActionResolutionError {
            throw error
        } catch {
            throw ActionResolutionError.resolutionFailed(action.type.rawValue, underlyingError: error)
        }
    }

    /// Resolve all actions in a dictionary
    /// - Parameters:
    ///   - actions: Dictionary of action IDs to Document actions
    ///   - context: Resolution context
    /// - Returns: Dictionary of action IDs to resolved IR action definitions
    /// - Throws: ActionResolutionError if any resolution fails
    public func resolveAll(
        _ actions: [String: Document.Action]?,
        context: ResolutionContext
    ) throws -> [String: IR.ActionDefinition] {
        guard let actions = actions else {
            return [:]
        }

        var resolved: [String: IR.ActionDefinition] = [:]
        for (id, action) in actions {
            resolved[id] = try resolve(action, context: context)
        }
        return resolved
    }
}
