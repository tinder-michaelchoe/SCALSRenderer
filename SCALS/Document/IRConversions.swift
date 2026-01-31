//
//  IRConversions.swift
//  ScalsRendererFramework
//
//  Extensions implementing Document→IR conversion via protocol conformance.
//  Document layer remains pure - no dependencies on IR.Style or resolution logic.
//
//  **Important**: This file should remain platform-agnostic. Do NOT import
//  SwiftUI or UIKit here. Platform-specific conversions belong in the
//  renderer layer (see `Renderers/SwiftUI/IRTypeConversions.swift`).
//

import Foundation

// MARK: - Padding Conversion

extension Document.Padding: IRConvertible {
    public typealias IRType = IR.EdgeInsets

    /// Converts Document.Padding to IR.EdgeInsets.
    ///
    /// Resolves shorthand values (horizontal/vertical) to specific edges:
    /// - `top` overrides `vertical`
    /// - `leading` overrides `horizontal`
    /// - Defaults to 0 if no value specified
    ///
    /// Note: This is pure conversion. For merging with styles, use
    /// `IR.EdgeInsets(from:mergingTop:...)` initializer.
    public func toIR() -> IR.EdgeInsets {
        return IR.EdgeInsets(
            top: resolvedTop,
            leading: resolvedLeading,
            bottom: resolvedBottom,
            trailing: resolvedTrailing
        )
    }
}

// MARK: - Horizontal Alignment Conversion

extension Document.HorizontalAlignment: IRConvertible {
    public typealias IRType = IR.HorizontalAlignment

    /// Converts Document.HorizontalAlignment to IR.HorizontalAlignment.
    public func toIR() -> IR.HorizontalAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
}

// MARK: - Vertical Alignment Conversion

extension Document.VerticalAlignment: IRConvertible {
    public typealias IRType = IR.VerticalAlignment

    /// Converts Document.VerticalAlignment to IR.VerticalAlignment.
    public func toIR() -> IR.VerticalAlignment {
        switch self {
        case .top: return .top
        case .center: return .center
        case .bottom: return .bottom
        }
    }
}

// MARK: - 2D Alignment Conversion

extension Document.Alignment: IRConvertible {
    public typealias IRType = IR.Alignment

    /// Converts Document.Alignment to IR.Alignment.
    ///
    /// Resolves optional horizontal/vertical to center if not specified.
    public func toIR() -> IR.Alignment {
        let h: IR.HorizontalAlignment = horizontal?.toIR() ?? .center
        let v: IR.VerticalAlignment = vertical?.toIR() ?? .center
        return IR.Alignment(horizontal: h, vertical: v)
    }
}

// MARK: - DimensionValue Conversion

extension Document.DimensionValue: IRConvertible {
    public typealias IRType = IR.DimensionValue

    /// Converts Document.DimensionValue to IR.DimensionValue.
    public func toIR() -> IR.DimensionValue {
        switch self {
        case .absolute(let value):
            return .absolute(value)
        case .fractional(let fraction):
            return .fractional(fraction)
        }
    }
}
