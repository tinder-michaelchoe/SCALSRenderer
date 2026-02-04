//
//  RenderNodeData.swift
//  SCALS
//
//  Protocol for render node data types.
//  All concrete node implementations (TextNode, ButtonNode, etc.)
//  must conform to this protocol.
//

import Foundation

// MARK: - Render Node Data Protocol

/// Protocol for render node data types.
///
/// All render node structs (TextNode, ButtonNode, ContainerNode, etc.)
/// must conform to this protocol to be usable with the dynamic `RenderNode` system.
///
/// This enables a fully dynamic, protocol-based architecture where new node types
/// can be added without modifying the core SCALS framework.
///
/// ## Conformance Example
///
/// ```swift
/// struct TextNode: RenderNodeData {
///     public static let nodeKind = RenderNodeKind.text
///
///     public let id: String?
///     public let styleId: String?
///     public let content: String
///     // ... other properties
/// }
/// ```
///
/// ## Usage with RenderNode
///
/// ```swift
/// // Creating a RenderNode
/// let node = RenderNode(TextNode(content: "Hello"))
///
/// // Extracting typed data
/// if let textNode = node.data(TextNode.self) {
///     print(textNode.content)
/// }
/// ```
public protocol RenderNodeData: Sendable {
    /// The kind identifier for this node type.
    ///
    /// Each node type must have a unique kind identifier.
    /// This is used by renderers to dispatch to the appropriate renderer.
    static var nodeKind: RenderNodeKind { get }

    /// Optional identifier for this specific node instance.
    ///
    /// Used for tracking, debugging, and state management.
    var id: String? { get }

    /// Optional style identifier for design system integration.
    ///
    /// When set, design system providers can intercept rendering
    /// to apply custom styling.
    var styleId: String? { get }
}

// MARK: - Default Implementations

extension RenderNodeData {
    /// Default implementation returns nil for nodes without an ID
    public var id: String? { nil }

    /// Default implementation returns nil for nodes without a styleId
    public var styleId: String? { nil }
}
