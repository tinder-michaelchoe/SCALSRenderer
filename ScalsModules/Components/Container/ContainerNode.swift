//
//  ContainerNode.swift
//  ScalsModules
//
//  Container layout node for VStack, HStack, ZStack.
//

import Foundation
import SCALS

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Container layout node (VStack, HStack, ZStack)
    public static let container = RenderNodeKind(rawValue: "container")
}

// MARK: - Container Node

/// A layout container (VStack, HStack, ZStack).
///
/// Containers arrange their children according to the specified layout type.
public struct ContainerNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.container

    public let id: String?
    public var styleId: String? { nil }

    /// The type of layout
    public let layoutType: LayoutType

    /// Alignment of children within the container
    public let alignment: IR.Alignment

    /// Spacing between children
    public let spacing: CGFloat

    /// Child nodes
    public let children: [RenderNode]

    // MARK: - Flattened Style Properties (fully resolved)

    /// Padding around the container content
    public let padding: IR.EdgeInsets

    /// Background color (nil means no background applied)
    public let backgroundColor: IR.Color?

    /// Corner radius for rounded corners
    public let cornerRadius: CGFloat

    /// Shadow effect (nil if no shadow)
    public let shadow: IR.Shadow?

    /// Border effect (nil if no border)
    public let border: IR.Border?

    // MARK: - Sizing

    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?
    public let minWidth: IR.DimensionValue?
    public let minHeight: IR.DimensionValue?
    public let maxWidth: IR.DimensionValue?
    public let maxHeight: IR.DimensionValue?

    public init(
        id: String? = nil,
        layoutType: LayoutType = .vstack,
        alignment: IR.Alignment = .center,
        spacing: CGFloat = 0,
        children: [RenderNode] = [],
        padding: IR.EdgeInsets = .zero,
        backgroundColor: IR.Color? = nil,
        cornerRadius: CGFloat = 0,
        shadow: IR.Shadow? = nil,
        border: IR.Border? = nil,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil,
        minWidth: IR.DimensionValue? = nil,
        minHeight: IR.DimensionValue? = nil,
        maxWidth: IR.DimensionValue? = nil,
        maxHeight: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.layoutType = layoutType
        self.alignment = alignment
        self.spacing = spacing
        self.children = children
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.border = border
        self.width = width
        self.height = height
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
}
