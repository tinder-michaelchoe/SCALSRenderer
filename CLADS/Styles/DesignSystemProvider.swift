//
//  DesignSystemProvider.swift
//  CLADS
//
//  Protocol for design system integration.
//  Enables external design systems to provide both style tokens and native components.
//

import Foundation
import SwiftUI

// MARK: - Design System Provider Protocol

/// Combined protocol for design system style resolution and component rendering.
///
/// A `DesignSystemProvider` can:
/// 1. Resolve `@`-prefixed style references to `IR.Style` tokens for fallback rendering
/// 2. Render native design system components with full fidelity (animations, states, behaviors)
///
/// Design system components should be pure SwiftUI (no CLADS dependency) and handle
/// dark mode internally using `@Environment(\.colorScheme)`.
///
/// Example implementation:
/// ```swift
/// struct LightspeedProvider: DesignSystemProvider {
///     static let identifier = "lightspeed"
///
///     func resolveStyle(_ reference: String) -> IR.Style? {
///         // Map "button.primary" -> IR.Style with colors, padding, etc.
///     }
///
///     func canRender(_ node: RenderNode, styleId: String?) -> Bool {
///         guard let styleId, styleId.hasPrefix("@") else { return false }
///         return node.kind == .button && styleId.contains("button.")
///     }
///
///     func render(_ node: RenderNode, styleId: String?, context: SwiftUIRenderContext) -> AnyView? {
///         // Return native LightspeedButton wrapped with action handling
///     }
/// }
/// ```
public protocol DesignSystemProvider {
    /// Unique identifier for this design system (e.g., "lightspeed", "obsidian")
    static var identifier: String { get }

    // MARK: - Style Token Resolution

    /// Resolve a style reference to `IR.Style` for fallback rendering.
    ///
    /// Called when a component has an `@`-prefixed styleId but the provider
    /// cannot (or chooses not to) render a native component.
    ///
    /// - Parameter reference: Style path without "@" prefix (e.g., "button.primary")
    /// - Returns: Resolved `IR.Style` or nil if not found
    func resolveStyle(_ reference: String) -> IR.Style?

    // MARK: - Full Component Rendering

    /// Check if this provider can render the given node with native components.
    ///
    /// Return `true` to have `render(_:styleId:context:)` called for this node.
    /// Return `false` to fall back to standard CLADS rendering with style tokens.
    ///
    /// - Parameters:
    ///   - node: The render node to check
    ///   - styleId: The style ID (expected to have "@" prefix for design system references)
    /// - Returns: `true` if this provider has a native component for this node+style
    func canRender(_ node: RenderNode, styleId: String?) -> Bool

    /// Render a node using native design system components.
    ///
    /// Called when `canRender` returns `true`. The returned view should:
    /// - Be a pure SwiftUI component (no CLADS dependency)
    /// - Handle dark mode internally using `@Environment(\.colorScheme)`
    /// - Wire up action handling via the provided context
    ///
    /// - Parameters:
    ///   - node: The render node to render
    ///   - styleId: The style ID for component variant selection
    ///   - context: CLADS render context with StateStore, ActionContext, etc.
    /// - Returns: SwiftUI view, or nil to fall back to default rendering
    @MainActor
    func render(_ node: RenderNode, styleId: String?, context: SwiftUIRenderContext) -> AnyView?
}

// MARK: - Default Implementations

public extension DesignSystemProvider {
    /// Default: can't render any nodes (fall back to style tokens only)
    func canRender(_ node: RenderNode, styleId: String?) -> Bool {
        return false
    }

    /// Default: return nil (fall back to standard rendering)
    @MainActor
    func render(_ node: RenderNode, styleId: String?, context: SwiftUIRenderContext) -> AnyView? {
        return nil
    }
}

// MARK: - RenderNode StyleId Extension

public extension RenderNode {
    /// The styleId for this render node, if applicable.
    ///
    /// Used by renderers to check for design system style references.
    var styleId: String? {
        switch self {
        case .button(let n): return n.styleId
        case .text(let n): return n.styleId
        case .image(let n): return n.styleId
        case .textField(let n): return n.styleId
        case .toggle(let n): return n.styleId
        case .slider(let n): return n.styleId
        case .container, .sectionLayout, .gradient, .spacer, .divider, .custom:
            return nil
        }
    }
}
