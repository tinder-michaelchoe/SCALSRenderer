//
//  ShapeNode.swift
//  SCALS
//
//  Shape component node for geometric shapes.
//

import Foundation

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Shape node
    public static let shape = RenderNodeKind(rawValue: "shape")
}

// MARK: - Shape Node

/// A shape component (rectangle, circle, roundedRectangle, capsule, ellipse).
///
/// Shapes can be filled and/or stroked with configurable styling.
public struct ShapeNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.shape

    /// Shape type with associated values for parameters like cornerRadius
    @frozen
    public enum ShapeType: Hashable, Sendable {
        case rectangle
        case circle
        case roundedRectangle(cornerRadius: CGFloat)
        case capsule
        case ellipse
    }

    public let id: String?
    public var styleId: String? { nil }

    /// The type of shape to render
    public let shapeType: ShapeType

    // MARK: - Flattened Style Properties

    /// Fill color
    public let fillColor: IR.Color

    /// Stroke color (nil for no stroke)
    public let strokeColor: IR.Color?

    /// Stroke width in points
    public let strokeWidth: CGFloat

    /// Padding around the shape
    public let padding: IR.EdgeInsets

    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?

    public init(
        id: String? = nil,
        shapeType: ShapeType,
        fillColor: IR.Color = .clear,
        strokeColor: IR.Color? = nil,
        strokeWidth: CGFloat = 0,
        padding: IR.EdgeInsets = .zero,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.shapeType = shapeType
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.padding = padding
        self.width = width
        self.height = height
    }
}
