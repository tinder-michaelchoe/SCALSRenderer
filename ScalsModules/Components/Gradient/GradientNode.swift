//
//  GradientNode.swift
//  ScalsModules
//
//  Gradient component node for gradient overlays.
//

import Foundation
import SCALS

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Gradient node
    public static let gradient = RenderNodeKind(rawValue: "gradient")
}

// MARK: - Gradient Node

/// A gradient overlay component.
///
/// Supports linear and radial gradients with configurable color stops.
public struct GradientNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.gradient

    /// Type aliases for compatibility - use standalone types from SCALS
    public typealias ColorStop = GradientColorStop

    public let id: String?
    public var styleId: String? { nil }

    /// Type of gradient (linear or radial)
    public let gradientType: GradientType

    /// Color stops defining the gradient
    public let colors: [GradientColorStop]

    /// Start point for the gradient (0,0 to 1,1)
    public let startPoint: IR.UnitPoint

    /// End point for the gradient (0,0 to 1,1)
    public let endPoint: IR.UnitPoint

    // MARK: - Flattened Style Properties

    public let cornerRadius: CGFloat
    public let padding: IR.EdgeInsets
    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?

    public init(
        id: String? = nil,
        gradientType: GradientType = .linear,
        colors: [GradientColorStop],
        startPoint: IR.UnitPoint = .bottom,
        endPoint: IR.UnitPoint = .top,
        cornerRadius: CGFloat = 0,
        padding: IR.EdgeInsets = .zero,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.gradientType = gradientType
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.width = width
        self.height = height
    }
}
