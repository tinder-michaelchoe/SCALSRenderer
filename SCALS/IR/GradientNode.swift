//
//  GradientNode.swift
//  SCALS
//
//  Gradient component node for gradient overlays.
//

import Foundation

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Gradient node
    public static let gradient = RenderNodeKind(rawValue: "gradient")
}

// MARK: - Gradient Color

/// Color for gradient - can be static or adapt to color scheme
@frozen
public enum GradientColor: Sendable {
    case fixed(IR.Color)
    case adaptive(light: IR.Color, dark: IR.Color)

    /// Resolve to the appropriate color based on color scheme
    /// - Parameters:
    ///   - scheme: The IR color scheme setting
    ///   - isSystemDark: Whether the system is currently in dark mode (for .system scheme)
    /// - Returns: The resolved IR.Color
    public func resolved(for scheme: IR.ColorScheme, isSystemDark: Bool) -> IR.Color {
        switch self {
        case .fixed(let color):
            return color
        case .adaptive(let light, let dark):
            let isDark: Bool
            switch scheme {
            case .light: isDark = false
            case .dark: isDark = true
            case .system: isDark = isSystemDark
            }
            return isDark ? dark : light
        }
    }
}

// MARK: - Gradient Node

/// A gradient overlay component.
///
/// Supports linear and radial gradients with configurable color stops.
public struct GradientNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.gradient

    /// Gradient type
    @frozen
    public enum GradientType: Sendable {
        case linear
        case radial
    }

    /// A color stop in a gradient
    public struct ColorStop: Sendable {
        public let color: GradientColor
        public let location: CGFloat  // 0.0 to 1.0

        public init(color: GradientColor, location: CGFloat) {
            self.color = color
            self.location = location
        }
    }

    public let id: String?
    public var styleId: String? { nil }

    /// Type of gradient (linear or radial)
    public let gradientType: GradientType

    /// Color stops defining the gradient
    public let colors: [ColorStop]

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
        colors: [ColorStop],
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
