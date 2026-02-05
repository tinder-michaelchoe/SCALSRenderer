//
//  CoreManifest.swift
//  ScalsModules
//
//  The default manifest containing all built-in components, actions, and layouts.
//  This is the single source of truth for what's registered in SCALS.
//

import SCALS

/// The default manifest containing all built-in components, actions, and layouts.
///
/// Opening this file shows all registered functionality at a glance:
/// - User-facing components (Button, Text, etc.)
/// - Layout constructs (Container, Spacer, SectionLayout)
/// - Actions (setState, dismiss, navigate, etc.)
/// - Section layout types (Grid, Flow, List, Horizontal)
///
/// Example usage:
/// ```swift
/// ScalsRendererView(
///     document: document,
///     manifest: CoreManifest.self
/// )
/// ```
public struct CoreManifest: ScalsManifest {

    // ═══════════════════════════════════════════════════════════════════════════
    // MARK: - Components
    // ═══════════════════════════════════════════════════════════════════════════

    /// User-facing components that can be declared in documents.
    public static let components: [any ComponentBundle.Type] = [
        // Interactive components
        ButtonBundle.self,
        TextFieldBundle.self,
        ToggleBundle.self,
        SliderBundle.self,

        // Display components
        TextBundle.self,
        ImageBundle.self,
        GradientBundle.self,
        ShapeBundle.self,
        DividerBundle.self,
        PageIndicatorBundle.self,
    ]

    // ═══════════════════════════════════════════════════════════════════════════
    // MARK: - Layout Nodes
    // ═══════════════════════════════════════════════════════════════════════════

    /// Layout constructs resolved via LayoutResolver/SectionLayoutResolver.
    public static let layouts: [any LayoutBundle.Type] = [
        ContainerBundle.self,
        SpacerBundle.self,
        SectionLayoutBundle.self,
    ]

    // ═══════════════════════════════════════════════════════════════════════════
    // MARK: - Actions
    // ═══════════════════════════════════════════════════════════════════════════

    /// Built-in actions with their resolvers and handlers.
    public static let actions: [ActionBundleDefinition] = [
        ActionBundleDefinition(
            kind: .setState,
            resolver: SetStateResolver(),
            handler: SetStateHandler()
        ),
        ActionBundleDefinition(
            kind: .toggleState,
            resolver: ToggleStateResolver(),
            handler: ToggleStateHandler()
        ),
        ActionBundleDefinition(
            kind: .dismiss,
            resolver: DismissResolver(),
            handler: DismissHandler()
        ),
        ActionBundleDefinition(
            kind: .navigate,
            resolver: NavigateResolver(),
            handler: NavigateHandler()
        ),
        ActionBundleDefinition(
            kind: .showAlert,
            resolver: ShowAlertResolver(),
            handler: ShowAlertHandler()
        ),
        ActionBundleDefinition(
            kind: .openURL,
            resolver: OpenURLResolver(),
            handler: OpenURLHandler()
        ),
        ActionBundleDefinition(
            kind: .request,
            resolver: RequestResolver(),
            handler: RequestHandler()
        ),
        ActionBundleDefinition(
            kind: .sequence,
            resolverFactory: { registry in SequenceResolver(registry: registry) },
            handler: SequenceHandler()
        ),
    ]

    // ═══════════════════════════════════════════════════════════════════════════
    // MARK: - Section Layouts
    // ═══════════════════════════════════════════════════════════════════════════

    /// Section layout config resolvers.
    public static let sectionLayouts: [any SectionLayoutConfigResolving.Type] = [
        GridLayoutConfigResolver.self,
        FlowLayoutConfigResolver.self,
        ListLayoutConfigResolver.self,
        HorizontalLayoutConfigResolver.self,
    ]

    /// Section layout SwiftUI renderers.
    public static let sectionLayoutRenderers: [any SwiftUISectionLayoutRendering.Type] = [
        GridSectionLayoutRenderer.self,
        FlowSectionLayoutRenderer.self,
        ListSectionLayoutRenderer.self,
        HorizontalSectionLayoutRenderer.self,
    ]
}
