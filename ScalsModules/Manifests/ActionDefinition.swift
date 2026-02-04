//
//  ActionBundleDefinition.swift
//  ScalsModules
//
//  Groups resolver and handler for an action type.
//

import SCALS

/// Factory type for creating resolvers that need the registry.
/// Used by actions like `sequence` that need recursive resolution.
public typealias ResolverFactory = @Sendable (ActionResolverRegistry) -> any ActionResolving

/// Groups resolver and handler for an action type.
///
/// For most actions, provide a resolver directly:
/// ```swift
/// ActionBundleDefinition(
///     kind: .setState,
///     resolver: SetStateResolver(),
///     handler: SetStateHandler()
/// )
/// ```
///
/// For actions that need the registry (like sequence), use a factory:
/// ```swift
/// ActionBundleDefinition(
///     kind: .sequence,
///     resolverFactory: { registry in SequenceResolver(registry: registry) },
///     handler: SequenceHandler()
/// )
/// ```
public struct ActionBundleDefinition: Sendable {
    /// The action kind this definition handles
    public let kind: Document.ActionKind

    /// The resolver (either pre-created or factory-based)
    private let _resolver: ResolverStorage

    /// The handler that executes the resolved action
    public let handler: any ActionHandler

    /// Initialize with a pre-created resolver.
    public init(
        kind: Document.ActionKind,
        resolver: any ActionResolving,
        handler: any ActionHandler
    ) {
        self.kind = kind
        self._resolver = .direct(resolver)
        self.handler = handler
    }

    /// Initialize with a factory for resolvers that need the registry.
    public init(
        kind: Document.ActionKind,
        resolverFactory: @escaping ResolverFactory,
        handler: any ActionHandler
    ) {
        self.kind = kind
        self._resolver = .factory(resolverFactory)
        self.handler = handler
    }

    /// Creates the resolver, using the registry if needed.
    public func makeResolver(registry: ActionResolverRegistry) -> any ActionResolving {
        switch _resolver {
        case .direct(let resolver):
            return resolver
        case .factory(let factory):
            return factory(registry)
        }
    }
}

/// Internal storage for resolver (direct instance or factory).
private enum ResolverStorage: Sendable {
    case direct(any ActionResolving)
    case factory(ResolverFactory)
}
