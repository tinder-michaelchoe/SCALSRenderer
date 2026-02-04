//
//  SpacerNode.swift
//  SCALS
//
//  Spacer node for flexible spacing in layouts.
//

import Foundation

// MARK: - Spacer Node

/// A spacer component with optional sizing properties.
///
/// Spacers are used to create flexible space in layouts.
/// They can have minimum length constraints or fixed dimensions.
public struct SpacerNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.spacer

    // Note: SpacerNode has no id or styleId properties
    public var id: String? { nil }
    public var styleId: String? { nil }

    /// Minimum length in points (flexible - can grow)
    public let minLength: CGFloat?

    /// Fixed width in points (exact size)
    public let width: CGFloat?

    /// Fixed height in points (exact size)
    public let height: CGFloat?

    public init(minLength: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.minLength = minLength
        self.width = width
        self.height = height
    }
}

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Spacer node
    public static let spacer = RenderNodeKind(rawValue: "spacer")
}
