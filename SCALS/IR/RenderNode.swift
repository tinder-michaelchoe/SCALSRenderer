//
//  RenderNode.swift
//  SCALS
//
//  Dynamic render node container.
//  This struct wraps any RenderNodeData conforming type,
//  enabling a fully extensible node system.
//

import Foundation

// MARK: - Render Node

/// A node in the render tree.
///
/// `RenderNode` is a type-erased container for any `RenderNodeData` conforming type.
/// This enables a fully dynamic, protocol-based architecture where new node types
/// can be added without modifying the core SCALS framework.
///
/// ## Creating Nodes
///
/// ```swift
/// let textNode = RenderNode(TextNode(content: "Hello"))
/// let buttonNode = RenderNode(ButtonNode(label: "Click Me"))
/// ```
///
/// ## Extracting Typed Data
///
/// ```swift
/// if let text = node.data(TextNode.self) {
///     print(text.content)
/// }
/// ```
///
/// ## Kind-Based Dispatch
///
/// ```swift
/// switch node.kind {
/// case .text: // render text
/// case .button: // render button
/// default: // handle unknown
/// }
/// ```
public struct RenderNode: Sendable {
    /// The kind identifier for this node
    public let kind: RenderNodeKind

    /// The underlying node data (type-erased)
    public let nodeData: any RenderNodeData

    /// Creates a RenderNode wrapping the given node data.
    ///
    /// - Parameter data: The node data to wrap
    public init<T: RenderNodeData>(_ data: T) {
        self.kind = T.nodeKind
        self.nodeData = data
    }

    /// Extracts the node data as a specific type.
    ///
    /// - Parameter type: The expected node data type
    /// - Returns: The node data cast to the specified type, or nil if the type doesn't match
    public func data<T: RenderNodeData>(_ type: T.Type) -> T? {
        nodeData as? T
    }

    /// The optional ID of the underlying node
    public var id: String? {
        nodeData.id
    }

    /// The optional styleId of the underlying node
    public var styleId: String? {
        nodeData.styleId
    }
}
