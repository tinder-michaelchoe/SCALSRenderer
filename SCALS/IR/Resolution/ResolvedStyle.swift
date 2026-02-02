//
//  ResolvedStyle.swift
//  ScalsRendererFramework
//
//  Temporary type used during Document→IR resolution.
//  This type exists ONLY during conversion and is NOT stored in the IR tree.
//
//  **Important**: This file should remain platform-agnostic. Do NOT import
//  SwiftUI or UIKit here. Platform-specific conversions belong in the
//  renderer layer (see `Renderers/SwiftUI/IRTypeConversions.swift`).
//

import Foundation

// MARK: - ResolvedStyle

/// Resolved style properties from style inheritance and merging.
///
/// This is a **temporary artifact** used during Document→IR conversion.
/// After resolution, properties are extracted and placed directly on IR nodes.
/// This type should **NEVER** appear in the final IR tree.
///
/// ## Usage
///
/// ```swift
/// // In a resolver:
/// let resolvedStyle = context.styleResolver.resolve(layout.styleId, inline: layout.style)
///
/// // Extract properties for the IR node
/// let backgroundColor = resolvedStyle.backgroundColor ?? .clear
/// let cornerRadius = resolvedStyle.cornerRadius ?? 0
/// let shadow = IR.Shadow(from: resolvedStyle)  // failable init
///
/// // Create flat IR node (no .style property)
/// let node = ContainerNode(
///     backgroundColor: backgroundColor,
///     cornerRadius: cornerRadius,
///     shadow: shadow,
///     // ...
/// )
/// ```
public struct ResolvedStyle: Sendable {

    // MARK: - Typography

    public var fontFamily: String?
    public var fontSize: CGFloat?
    public var fontWeight: IR.FontWeight?
    public var textColor: IR.Color?
    public var textAlignment: IR.TextAlignment?

    // MARK: - Background & Border

    public var backgroundColor: IR.Color?
    public var cornerRadius: CGFloat?
    public var borderWidth: CGFloat?
    public var borderColor: IR.Color?

    // MARK: - Shadow

    public var shadowColor: IR.Color?
    public var shadowRadius: CGFloat?
    public var shadowX: CGFloat?
    public var shadowY: CGFloat?

    // MARK: - Image

    public var tintColor: IR.Color?

    // MARK: - Sizing

    public var width: IR.DimensionValue?
    public var height: IR.DimensionValue?
    public var minWidth: IR.DimensionValue?
    public var minHeight: IR.DimensionValue?
    public var maxWidth: IR.DimensionValue?
    public var maxHeight: IR.DimensionValue?

    // MARK: - Padding (individual edges for merging)

    public var paddingTop: CGFloat?
    public var paddingBottom: CGFloat?
    public var paddingLeading: CGFloat?
    public var paddingTrailing: CGFloat?

    // MARK: - Initialization

    public init() {}

    // MARK: - Merging

    /// Merge properties from a Document.Style into this resolved style.
    ///
    /// Non-nil values in the source style override existing values.
    /// This implements style inheritance by merging parent styles first,
    /// then child styles.
    public mutating func merge(from style: Document.Style) {
        if let v = style.fontFamily { fontFamily = v }
        if let v = style.fontSize { fontSize = v }
        if let v = style.fontWeight { fontWeight = v }
        if let v = style.textColor { textColor = IR.Color(hex: v) }
        if let v = style.textAlignment { textAlignment = v }
        if let v = style.backgroundColor { backgroundColor = IR.Color(hex: v) }
        if let v = style.cornerRadius { cornerRadius = v }
        if let v = style.borderWidth { borderWidth = v }
        if let v = style.borderColor { borderColor = IR.Color(hex: v) }

        // Shadow resolution from Document.Shadow
        if let shadow = style.shadow {
            // Check if this is an explicit shadow clear (all properties nil)
            let isExplicitClear = shadow.color == nil && shadow.radius == nil && shadow.x == nil && shadow.y == nil

            if isExplicitClear {
                // Clear inherited shadow properties
                shadowColor = nil
                shadowRadius = nil
                shadowX = nil
                shadowY = nil
            } else {
                // Merge shadow properties
                if let v = shadow.color { shadowColor = IR.Color(hex: v) }
                if let v = shadow.radius { shadowRadius = v }
                if let v = shadow.x { shadowX = v }
                if let v = shadow.y { shadowY = v }
            }
        }

        if let v = style.tintColor { tintColor = IR.Color(hex: v) }
        if let v = style.width { width = v.toIR() }
        if let v = style.height { height = v.toIR() }
        if let v = style.minWidth { minWidth = v.toIR() }
        if let v = style.minHeight { minHeight = v.toIR() }
        if let v = style.maxWidth { maxWidth = v.toIR() }
        if let v = style.maxHeight { maxHeight = v.toIR() }

        // Padding resolution using Padding struct
        if let padding = style.padding {
            // Check if this is an explicit padding clear (all properties nil)
            let isExplicitClear = padding.top == nil && padding.bottom == nil &&
                                 padding.leading == nil && padding.trailing == nil &&
                                 padding.horizontal == nil && padding.vertical == nil

            if isExplicitClear {
                // Clear inherited padding properties
                paddingTop = nil
                paddingBottom = nil
                paddingLeading = nil
                paddingTrailing = nil
            } else {
                // Merge padding properties
                if padding.top != nil || padding.vertical != nil {
                    paddingTop = padding.resolvedTop
                }
                if padding.bottom != nil || padding.vertical != nil {
                    paddingBottom = padding.resolvedBottom
                }
                if padding.leading != nil || padding.horizontal != nil {
                    paddingLeading = padding.resolvedLeading
                }
                if padding.trailing != nil || padding.horizontal != nil {
                    paddingTrailing = padding.resolvedTrailing
                }
            }
        }
    }

    // MARK: - Convenience Properties

    /// Whether any shadow properties are defined
    public var hasShadow: Bool {
        shadowColor != nil || shadowRadius != nil || shadowX != nil || shadowY != nil
    }

    /// Whether any border properties are defined
    public var hasBorder: Bool {
        borderColor != nil && borderWidth != nil && borderWidth! > 0
    }
}
