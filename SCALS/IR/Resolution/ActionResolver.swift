//
//  ActionResolver.swift
//  ScalsRendererFramework
//

import Foundation

/// Orchestrates action resolution using the ActionResolverRegistry.
///
/// This resolver delegates all resolution to the ActionResolverRegistry,
/// which contains registered resolvers for each action kind.
///
/// ## Usage
/// ```swift
/// let registry = ActionResolverRegistry.default
/// let resolver = ActionResolver(registry: registry)
/// let resolved = try resolver.resolve(action, context: context)
/// ```
public struct ActionResolver {

    private let registry: ActionResolverRegistry

    /// Initialize with an action resolver registry
    /// - Parameter registry: The registry containing registered action resolvers
    public init(registry: ActionResolverRegistry) {
        self.registry = registry
    }

    // MARK: - Public API

    /// Resolves all actions from the document
    /// - Parameters:
    ///   - actions: Dictionary of action ID to Action
    ///   - context: Resolution context providing state store and document access
    /// - Returns: Dictionary of action ID to resolved ActionDefinition
    /// - Throws: ActionResolutionError if any resolution fails
    public func resolveAll(
        _ actions: [String: Document.Action]?,
        context: ResolutionContext
    ) throws -> [String: IR.ActionDefinition] {
        return try registry.resolveAll(actions, context: context)
    }

    /// Resolves a single Action to ActionDefinition
    /// - Parameters:
    ///   - action: The schema Action
    ///   - context: Resolution context providing state store and document access
    /// - Returns: The resolved ActionDefinition
    /// - Throws: ActionResolutionError if resolution fails
    public func resolve(
        _ action: Document.Action,
        context: ResolutionContext
    ) throws -> IR.ActionDefinition {
        return try registry.resolve(action, context: context)
    }
}
