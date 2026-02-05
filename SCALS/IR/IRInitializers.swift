//
//  IRInitializers.swift
//  ScalsRendererFramework
//
//  Initializers for IR types that handle resolution and merging.
//  Resolution logic lives in IR layer, keeping Document layer pure.
//
//  **Important**: This file should remain platform-agnostic. Do NOT import
//  SwiftUI or UIKit here. Platform-specific conversions belong in the
//  renderer layer (see `Renderers/SwiftUI/IRTypeConversions.swift`).
//

import Foundation

// MARK: - EdgeInsets Resolution

extension IR.EdgeInsets {

    /// Create EdgeInsets from Document.Padding, with fallback to style padding values.
    ///
    /// This initializer performs the full resolution with **override behavior**:
    /// 1. If a specific edge is set in the component padding (via top/bottom/leading/trailing/horizontal/vertical/all), use it
    /// 2. Otherwise, fall back to the style padding value for that edge
    /// 3. Returns fully resolved EdgeInsets
    ///
    /// Override Priority:
    /// - Component padding overrides style padding
    /// - Within component: specific (top) > axis (vertical) > all > style > 0
    ///
    /// - Parameters:
    ///   - padding: Optional node-level padding from Document
    ///   - mergingTop: Style padding for top edge (default 0)
    ///   - mergingBottom: Style padding for bottom edge (default 0)
    ///   - mergingLeading: Style padding for leading edge (default 0)
    ///   - mergingTrailing: Style padding for trailing edge (default 0)
    public init(
        from padding: Document.Padding?,
        mergingTop: CGFloat = 0,
        mergingBottom: CGFloat = 0,
        mergingLeading: CGFloat = 0,
        mergingTrailing: CGFloat = 0
    ) {
        // Check if component has any padding specified
        if let padding = padding {
            // For each edge: if component has it set (via specific/axis/all), use component value
            // Otherwise, use style value
            let hasTop = padding.top != nil || padding.vertical != nil || padding.all != nil
            let hasBottom = padding.bottom != nil || padding.vertical != nil || padding.all != nil
            let hasLeading = padding.leading != nil || padding.horizontal != nil || padding.all != nil
            let hasTrailing = padding.trailing != nil || padding.horizontal != nil || padding.all != nil

            self.init(
                top: hasTop ? padding.resolvedTop : mergingTop,
                leading: hasLeading ? padding.resolvedLeading : mergingLeading,
                bottom: hasBottom ? padding.resolvedBottom : mergingBottom,
                trailing: hasTrailing ? padding.resolvedTrailing : mergingTrailing
            )
        } else {
            // No component padding, use style padding
            self.init(
                top: mergingTop,
                leading: mergingLeading,
                bottom: mergingBottom,
                trailing: mergingTrailing
            )
        }
    }

    /// Create EdgeInsets from Document.Padding (simple conversion, no merging).
    ///
    /// - Parameter padding: Optional node-level padding from Document
    public init(from padding: Document.Padding?) {
        self = padding?.toIR() ?? .zero
    }
}

// MARK: - Shadow Resolution

extension IR.Shadow {

    /// Create Shadow from ResolvedStyle properties.
    ///
    /// Combines shadowColor, shadowRadius, shadowX, shadowY into a cohesive value.
    /// Returns nil if no shadow properties are specified.
    ///
    /// - Parameter resolvedStyle: Resolved style with potential shadow properties
    /// - Returns: Shadow instance, or nil if no shadow defined
    public init?(from resolvedStyle: ResolvedStyle) {
        // If all shadow properties are nil, no shadow is defined
        guard resolvedStyle.shadowColor != nil || resolvedStyle.shadowRadius != nil ||
              resolvedStyle.shadowX != nil || resolvedStyle.shadowY != nil else {
            return nil
        }

        self.init(
            color: resolvedStyle.shadowColor ?? .clear,
            radius: resolvedStyle.shadowRadius ?? 0,
            x: resolvedStyle.shadowX ?? 0,
            y: resolvedStyle.shadowY ?? 0
        )
    }

    /// Create Shadow from individual values with defaults.
    ///
    /// Use this when you have individual optional values from different sources.
    ///
    /// - Parameters:
    ///   - color: Shadow color (defaults to clear)
    ///   - radius: Shadow blur radius (defaults to 0)
    ///   - x: Shadow X offset (defaults to 0)
    ///   - y: Shadow Y offset (defaults to 0)
    /// - Returns: Shadow instance, or nil if all inputs are nil
    public init?(
        color: IR.Color?,
        radius: CGFloat?,
        x: CGFloat?,
        y: CGFloat?
    ) {
        // If all properties are nil, no shadow is defined
        guard color != nil || radius != nil || x != nil || y != nil else {
            return nil
        }

        self.init(
            color: color ?? .clear,
            radius: radius ?? 0,
            x: x ?? 0,
            y: y ?? 0
        )
    }
}

// MARK: - Border Resolution

extension IR.Border {

    /// Create Border from ResolvedStyle properties.
    ///
    /// Combines borderColor and borderWidth into a cohesive value.
    /// Returns nil if no complete border is defined (needs both color and width > 0).
    ///
    /// - Parameter resolvedStyle: Resolved style with potential border properties
    /// - Returns: Border instance, or nil if no complete border defined
    public init?(from resolvedStyle: ResolvedStyle) {
        // Need both color and positive width for a visible border
        guard let color = resolvedStyle.borderColor,
              let width = resolvedStyle.borderWidth,
              width > 0 else {
            return nil
        }

        self.init(color: color, width: width)
    }

    /// Create Border from individual values.
    ///
    /// - Parameters:
    ///   - color: Border color (optional)
    ///   - width: Border width (optional)
    /// - Returns: Border instance, or nil if incomplete
    public init?(color: IR.Color?, width: CGFloat?) {
        guard let color = color,
              let width = width,
              width > 0 else {
            return nil
        }

        self.init(color: color, width: width)
    }
}

// MARK: - Alignment Resolution

extension IR.Alignment {

    /// Create Alignment for VStack from horizontal alignment.
    ///
    /// - Parameter horizontalAlignment: Optional horizontal alignment (defaults to center)
    public init(forVStack horizontalAlignment: Document.HorizontalAlignment?) {
        let h = horizontalAlignment?.toIR() ?? .center
        self.init(horizontal: h, vertical: .center)
    }

    /// Create Alignment for HStack from vertical alignment.
    ///
    /// - Parameter verticalAlignment: Optional vertical alignment (defaults to center)
    public init(forHStack verticalAlignment: Document.VerticalAlignment?) {
        let v = verticalAlignment?.toIR() ?? .center
        self.init(horizontal: .center, vertical: v)
    }

    /// Create Alignment for ZStack from 2D alignment.
    ///
    /// - Parameter alignment: Optional 2D alignment (defaults to center)
    public init(forZStack alignment: Document.Alignment?) {
        if let alignment = alignment {
            self = alignment.toIR()
        } else {
            self = .center
        }
    }
}
