//
//  SwiftUIRendererConfiguration.swift
//  ScalsModules
//
//  Configuration struct for SwiftUI renderer initialization.
//

import SCALS

/// Configuration for ScalsRendererView (SwiftUI).
///
/// Encapsulates all registries and settings needed to render a document.
/// Supports both explicit registry configuration and convenience initialization
/// using CoreManifest defaults.
///
/// Example usage:
/// ```swift
/// // Simplest usage - CoreManifest defaults
/// let config = SwiftUIRendererConfiguration()
/// ScalsRendererView(document: doc, configuration: config)
///
/// // With customizations
/// let config = SwiftUIRendererConfiguration(
///     customActions: ["refresh": { _, _ in await refresh() }],
///     customComponents: [MyComponent.self],
///     designSystemProvider: myDesignSystem,
///     debugMode: true
/// )
///
/// // With explicit registries (advanced)
/// let config = SwiftUIRendererConfiguration(
///     actionRegistry: customActionRegistry,
///     actionResolverRegistry: customResolverRegistry,
///     componentRegistry: customComponentRegistry,
///     rendererRegistry: customSwiftUIRegistry
/// )
/// ```
public struct SwiftUIRendererConfiguration {
    // MARK: - Registries

    /// Registry for action handlers
    public let actionRegistry: ActionRegistry

    /// Registry for action resolvers
    public let actionResolverRegistry: ActionResolverRegistry

    /// Registry for component resolvers
    public let componentRegistry: ComponentResolverRegistry

    /// Registry for SwiftUI node renderers
    public let rendererRegistry: SwiftUINodeRendererRegistry

    // MARK: - Custom Extensions

    /// Custom component types to register
    public let customComponents: [any CustomComponent.Type]

    // MARK: - Action Delegate

    /// Delegate for handling custom actions
    public weak var actionDelegate: ScalsActionDelegate?

    // MARK: - Design System

    /// Design system provider for style resolution and native components
    public let designSystemProvider: (any DesignSystemProvider)?

    // MARK: - Debug

    /// Enable debug output
    public let debugMode: Bool

    // MARK: - Initialization

    /// Initialize with explicit registries.
    ///
    /// Use this initializer when you need full control over registry configuration.
    ///
    /// - Parameters:
    ///   - actionRegistry: Registry for action handlers
    ///   - actionResolverRegistry: Registry for action resolvers
    ///   - componentRegistry: Registry for component resolvers
    ///   - rendererRegistry: Registry for SwiftUI node renderers
    ///   - customComponents: Custom component types to register
    ///   - actionDelegate: Delegate for handling custom actions
    ///   - designSystemProvider: Optional design system provider
    ///   - debugMode: Enable debug output
    public init(
        actionRegistry: ActionRegistry,
        actionResolverRegistry: ActionResolverRegistry,
        componentRegistry: ComponentResolverRegistry,
        rendererRegistry: SwiftUINodeRendererRegistry,
        customComponents: [any CustomComponent.Type] = [],
        actionDelegate: ScalsActionDelegate? = nil,
        designSystemProvider: (any DesignSystemProvider)? = nil,
        debugMode: Bool = false
    ) {
        self.actionRegistry = actionRegistry
        self.actionResolverRegistry = actionResolverRegistry
        self.componentRegistry = componentRegistry
        self.rendererRegistry = rendererRegistry
        self.customComponents = customComponents
        self.actionDelegate = actionDelegate
        self.designSystemProvider = designSystemProvider
        self.debugMode = debugMode
    }

    /// Initialize with CoreManifest defaults.
    ///
    /// This is the recommended initializer for most use cases.
    ///
    /// - Parameters:
    ///   - customActions: View-specific action closures, keyed by action ID
    ///   - customComponents: Custom component types to register
    ///   - actionDelegate: Delegate for handling custom actions
    ///   - designSystemProvider: Optional design system provider
    ///   - debugMode: Enable debug output
    public init(
        customActions: [String: ActionClosure] = [:],
        customComponents: [any CustomComponent.Type] = [],
        actionDelegate: ScalsActionDelegate? = nil,
        designSystemProvider: (any DesignSystemProvider)? = nil,
        debugMode: Bool = false
    ) {
        // Create registries from CoreManifest internally
        let registries = CoreManifest.createRegistries()

        // Merge custom actions into the registry
        self.actionRegistry = registries.actionRegistry.merging(customActions: customActions)
        self.actionResolverRegistry = registries.actionResolverRegistry
        self.componentRegistry = registries.componentRegistry
        self.rendererRegistry = registries.swiftUIRegistry
        self.customComponents = customComponents
        self.actionDelegate = actionDelegate
        self.designSystemProvider = designSystemProvider
        self.debugMode = debugMode
    }
}
