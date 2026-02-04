//
//  ScalsManifest.swift
//  ScalsModules
//
//  Protocol declaring all components, actions, and layouts provided by a module.
//

import SCALS

/// Declares all components, actions, and layouts provided by a module.
///
/// This is the single source of truth for what's registered in SCALS.
/// Opening a manifest file shows all registered functionality at a glance.
///
/// Example:
/// ```swift
/// public struct CoreManifest: ScalsManifest {
///     public static let components: [any ComponentBundle.Type] = [
///         ButtonBundle.self,
///         TextBundle.self,
///         // ...
///     ]
///
///     public static let layouts: [any LayoutBundle.Type] = [
///         ContainerBundle.self,
///         SpacerBundle.self,
///         // ...
///     ]
///
///     public static let actions: [ActionBundleDefinition] = [
///         ActionBundleDefinition(kind: .setState, resolver: SetStateResolver(), handler: SetStateHandler()),
///         // ...
///     ]
///
///     public static let sectionLayouts: [any SectionLayoutConfigResolving.Type] = [
///         GridLayoutConfigResolver.self,
///         // ...
///     ]
///
///     public static let sectionLayoutRenderers: [any SwiftUISectionLayoutRendering.Type] = [
///         GridSectionLayoutRenderer.self,
///         // ...
///     ]
/// }
/// ```
public protocol ScalsManifest {
    /// Component bundles to register (user-facing components like Button, Text, etc.)
    static var components: [any ComponentBundle.Type] { get }

    /// Layout bundles to register (Container, Spacer, SectionLayout)
    static var layouts: [any LayoutBundle.Type] { get }

    /// Action definitions to register
    static var actions: [ActionBundleDefinition] { get }

    /// Section layout resolvers to register
    static var sectionLayouts: [any SectionLayoutConfigResolving.Type] { get }

    /// Section layout renderers to register (SwiftUI)
    static var sectionLayoutRenderers: [any SwiftUISectionLayoutRendering.Type] { get }
}

// MARK: - Default Implementations

extension ScalsManifest {
    /// Default empty arrays for optional protocol requirements
    public static var layouts: [any LayoutBundle.Type] { [] }
    public static var actions: [ActionBundleDefinition] { [] }
    public static var sectionLayouts: [any SectionLayoutConfigResolving.Type] { [] }
    public static var sectionLayoutRenderers: [any SwiftUISectionLayoutRendering.Type] { [] }
}

// MARK: - Registration

extension ScalsManifest {
    /// Registers all components, actions, and layouts with the provided registries.
    ///
    /// - Parameters:
    ///   - componentRegistry: Registry for component resolvers
    ///   - swiftUIRegistry: Registry for SwiftUI node renderers
    ///   - uiKitRegistry: Registry for UIKit node renderers
    ///   - actionRegistry: Registry for action handlers
    ///   - actionResolverRegistry: Registry for action resolvers
    ///   - sectionLayoutRegistry: Registry for section layout config resolvers
    ///   - sectionLayoutRendererRegistry: Registry for SwiftUI section layout renderers
    public static func register(
        componentRegistry: ComponentResolverRegistry,
        swiftUIRegistry: SwiftUINodeRendererRegistry,
        uiKitRegistry: UIKitNodeRendererRegistry,
        actionRegistry: ActionRegistry,
        actionResolverRegistry: ActionResolverRegistry,
        sectionLayoutRegistry: SectionLayoutConfigResolverRegistry,
        sectionLayoutRendererRegistry: SwiftUISectionLayoutRendererRegistry
    ) {
        // Register components
        for bundle in components {
            componentRegistry.register(bundle.makeResolver())
            swiftUIRegistry.register(bundle.makeSwiftUIRenderer())
            uiKitRegistry.register(bundle.makeUIKitRenderer())
        }

        // Register layouts
        for bundle in layouts {
            swiftUIRegistry.register(bundle.makeSwiftUIRenderer())
            if let uiKitRenderer = bundle.makeUIKitRenderer() {
                uiKitRegistry.register(uiKitRenderer)
            }
        }

        // Register actions (use makeResolver to support factory-based resolvers like SequenceResolver)
        for action in actions {
            let resolver = action.makeResolver(registry: actionResolverRegistry)
            actionResolverRegistry.register(resolver)
            actionRegistry.register(action.handler)
        }

        // Register section layout config resolvers
        for resolverType in sectionLayouts {
            sectionLayoutRegistry.register(resolverType.init())
        }

        // Register section layout renderers
        for rendererType in sectionLayoutRenderers {
            sectionLayoutRendererRegistry.register(rendererType.init())
        }
    }

    /// Creates a set of pre-populated registries from this manifest.
    ///
    /// - Returns: A tuple containing all registries populated with the manifest's content.
    public static func createRegistries() -> (
        componentRegistry: ComponentResolverRegistry,
        swiftUIRegistry: SwiftUINodeRendererRegistry,
        uiKitRegistry: UIKitNodeRendererRegistry,
        actionRegistry: ActionRegistry,
        actionResolverRegistry: ActionResolverRegistry,
        sectionLayoutRegistry: SectionLayoutConfigResolverRegistry,
        sectionLayoutRendererRegistry: SwiftUISectionLayoutRendererRegistry
    ) {
        let componentRegistry = ComponentResolverRegistry()
        let swiftUIRegistry = SwiftUINodeRendererRegistry()
        let uiKitRegistry = UIKitNodeRendererRegistry()
        let actionRegistry = ActionRegistry()
        let actionResolverRegistry = ActionResolverRegistry()
        let sectionLayoutRegistry = SectionLayoutConfigResolverRegistry()
        let sectionLayoutRendererRegistry = SwiftUISectionLayoutRendererRegistry()

        register(
            componentRegistry: componentRegistry,
            swiftUIRegistry: swiftUIRegistry,
            uiKitRegistry: uiKitRegistry,
            actionRegistry: actionRegistry,
            actionResolverRegistry: actionResolverRegistry,
            sectionLayoutRegistry: sectionLayoutRegistry,
            sectionLayoutRendererRegistry: sectionLayoutRendererRegistry
        )

        return (
            componentRegistry,
            swiftUIRegistry,
            uiKitRegistry,
            actionRegistry,
            actionResolverRegistry,
            sectionLayoutRegistry,
            sectionLayoutRendererRegistry
        )
    }
}
