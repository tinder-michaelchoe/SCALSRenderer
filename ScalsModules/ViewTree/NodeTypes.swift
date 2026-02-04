//
//  NodeTypes.swift
//  ScalsModules
//
//  Shared types used by render nodes and ViewNode data structures.
//  Moved from SCALS to ScalsModules as part of renderer-specific types.
//

import Foundation
import SCALS

// MARK: - Layout Type

/// Layout type for container nodes (VStack, HStack, ZStack)
@frozen
public enum LayoutType: Sendable {
    case vstack
    case hstack
    case zstack
}

// MARK: - Image Source

/// Image source type for ImageNode
@frozen
public enum ImageSource: Sendable {
    case sfsymbol(name: String)
    case asset(name: String)
    case url(URL)
    /// Dynamic URL from state - supports templates like "${artwork.primaryImage}"
    case statePath(String)
    /// Activity indicator / loading spinner
    case activityIndicator
}

// MARK: - Gradient Types

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

/// Gradient type
@frozen
public enum GradientType: Sendable {
    case linear
    case radial
}

/// A color stop in a gradient
public struct GradientColorStop: Sendable {
    public let color: GradientColor
    public let location: CGFloat  // 0.0 to 1.0

    public init(color: GradientColor, location: CGFloat) {
        self.color = color
        self.location = location
    }
}

// MARK: - Shape Type

/// Shape type with associated values for parameters like cornerRadius
@frozen
public enum ShapeType: Hashable, Sendable {
    case rectangle
    case circle
    case roundedRectangle(cornerRadius: CGFloat)
    case capsule
    case ellipse
}

// MARK: - Button Types

/// Image placement relative to text in buttons
@frozen
public enum ButtonImagePlacement: String, Codable, Sendable {
    case leading
    case trailing
    case top
    case bottom
}

/// Button shape affecting corner radius
@frozen
public enum ButtonShape: String, Codable, Sendable {
    case circle        // cornerRadius = min(width, height) / 2
    case capsule       // cornerRadius = height / 2
    case roundedSquare // cornerRadius = fixed (10px)
}
