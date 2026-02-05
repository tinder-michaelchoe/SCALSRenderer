//
//  UIKitNodeRendering.swift
//  ScalsRendererFramework
//
//  Protocol and context for UIKit node rendering.
//

import SCALS
import UIKit

// MARK: - Render Context

/// Context for UIKit node rendering, providing shared dependencies
public final class UIKitRenderContext: @unchecked Sendable {
    public let tree: RenderTree
    public let actionContext: ActionContext
    public let stateStore: StateStore
    public let colorScheme: IR.ColorScheme

    private let registry: UIKitNodeRendererRegistry

    public init(
        tree: RenderTree,
        actionContext: ActionContext,
        stateStore: StateStore,
        colorScheme: IR.ColorScheme,
        registry: UIKitNodeRendererRegistry
    ) {
        self.tree = tree
        self.actionContext = actionContext
        self.stateStore = stateStore
        self.colorScheme = colorScheme
        self.registry = registry
    }

    /// Convenience initializer without tree (creates empty tree)
    public convenience init(
        actionContext: ActionContext,
        stateStore: StateStore,
        colorScheme: IR.ColorScheme,
        registry: UIKitNodeRendererRegistry
    ) {
        let emptyTree = RenderTree(root: RootNode(), stateStore: stateStore, actions: [:])
        self.init(
            tree: emptyTree,
            actionContext: actionContext,
            stateStore: stateStore,
            colorScheme: colorScheme,
            registry: registry
        )
    }

    /// Render a child node (for recursive rendering)
    public func render(_ node: RenderNode) -> UIView {
        registry.render(node, context: self)
    }
}

// MARK: - Node Rendering Protocol

/// Protocol for rendering specific RenderNode types to UIKit views.
///
/// Implement this protocol to create a renderer for a specific node type.
/// Each implementation handles one `RenderNodeKind`.
///
/// Example:
/// ```swift
/// public struct TextNodeRenderer: UIKitNodeRendering {
///     public static let nodeKind: RenderNodeKind = .text
///
///     public func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
///         guard case .text(let textNode) = node else {
///             return UIView()
///         }
///         // ... render the text node
///     }
/// }
/// ```
public protocol UIKitNodeRendering {
    /// The RenderNodeKind this renderer handles
    static var nodeKind: RenderNodeKind { get }

    /// Render the node to a UIView
    /// - Parameters:
    ///   - node: The RenderNode to render (will match `nodeKind`)
    ///   - context: The rendering context with shared dependencies
    /// - Returns: The rendered UIView
    func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView
}
