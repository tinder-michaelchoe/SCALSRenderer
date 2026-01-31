//
//  StyleModifiers.swift
//  SCALS
//
//  SwiftUI View extensions for applying style properties from flattened IR nodes.
//

import SCALS
import SwiftUI

// MARK: - Style Modifiers for Flattened Nodes

public extension View {
    /// Apply text styling from a TextNode's flattened properties
    func applyTextStyle(from node: TextNode) -> some View {
        self
            .font(.system(size: node.fontSize, weight: node.fontWeight.swiftUI))
            .foregroundColor(node.textColor.swiftUI)
            .multilineTextAlignment(node.textAlignment.swiftUI)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
    }

    /// Apply text styling from a ButtonStateStyle's flattened properties
    func applyTextStyle(from style: ButtonStateStyle) -> some View {
        self
            .font(.system(size: style.fontSize, weight: style.fontWeight.swiftUI))
            .foregroundColor(style.textColor.swiftUI)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
    }

    /// Apply text styling from a TextFieldNode's flattened properties
    func applyTextStyle(from node: TextFieldNode) -> some View {
        self
            .font(.system(size: node.fontSize))
            .foregroundColor(node.textColor.swiftUI)
    }

    /// Apply container styling from flattened properties
    func applyContainerStyle(
        padding: IR.EdgeInsets,
        backgroundColor: IR.Color,
        cornerRadius: CGFloat,
        border: IR.Border?,
        shadow: IR.Shadow?,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil,
        minWidth: IR.DimensionValue? = nil,
        minHeight: IR.DimensionValue? = nil,
        maxWidth: IR.DimensionValue? = nil,
        maxHeight: IR.DimensionValue? = nil
    ) -> some View {
        self
            .padding(.top, padding.top)
            .padding(.bottom, padding.bottom)
            .padding(.leading, padding.leading)
            .padding(.trailing, padding.trailing)
            .modifier(DimensionFrameModifier(
                width: width,
                height: height,
                minWidth: minWidth,
                minHeight: minHeight,
                maxWidth: maxWidth,
                maxHeight: maxHeight
            ))
            .background(backgroundColor.swiftUI)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(border?.color.swiftUI ?? Color.clear, lineWidth: border?.width ?? 0)
            )
            .shadow(
                color: shadow?.color.swiftUI ?? .clear,
                radius: shadow?.radius ?? 0,
                x: shadow?.x ?? 0,
                y: shadow?.y ?? 0
            )
    }
}

// MARK: - Dimension Frame Modifier

/// Applies width/height constraints supporting both absolute and fractional dimensions.
/// Reuses proven pattern from HorizontalSectionLayoutRenderer.
public struct DimensionFrameModifier: ViewModifier {
    let width: IR.DimensionValue?
    let height: IR.DimensionValue?
    let minWidth: IR.DimensionValue?
    let minHeight: IR.DimensionValue?
    let maxWidth: IR.DimensionValue?
    let maxHeight: IR.DimensionValue?

    public init(
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil,
        minWidth: IR.DimensionValue? = nil,
        minHeight: IR.DimensionValue? = nil,
        maxWidth: IR.DimensionValue? = nil,
        maxHeight: IR.DimensionValue? = nil
    ) {
        self.width = width
        self.height = height
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }

    public func body(content: Content) -> some View {
        content
            .modifier(DimensionModifier(dimension: width, axis: .horizontal, type: .exact))
            .modifier(DimensionModifier(dimension: height, axis: .vertical, type: .exact))
            .modifier(DimensionModifier(dimension: minWidth, axis: .horizontal, type: .minimum))
            .modifier(DimensionModifier(dimension: minHeight, axis: .vertical, type: .minimum))
            .modifier(DimensionModifier(dimension: maxWidth, axis: .horizontal, type: .maximum))
            .modifier(DimensionModifier(dimension: maxHeight, axis: .vertical, type: .maximum))
    }
}

private struct DimensionModifier: ViewModifier {
    let dimension: IR.DimensionValue?
    let axis: Axis
    let type: ConstraintType

    enum Axis {
        case horizontal, vertical
    }

    enum ConstraintType {
        case exact, minimum, maximum
    }

    func body(content: Content) -> some View {
        if let dimension = dimension {
            switch dimension {
            case .absolute(let value):
                applyAbsolute(content, value: value)
            case .fractional(let fraction):
                applyFractional(content, fraction: fraction)
            }
        } else {
            content
        }
    }

    @ViewBuilder
    private func applyAbsolute(_ content: Content, value: CGFloat) -> some View {
        switch (axis, type) {
        case (.horizontal, .exact):
            content.frame(width: value)
        case (.horizontal, .minimum):
            content.frame(minWidth: value)
        case (.horizontal, .maximum):
            content.frame(maxWidth: value)
        case (.vertical, .exact):
            content.frame(height: value)
        case (.vertical, .minimum):
            content.frame(minHeight: value)
        case (.vertical, .maximum):
            content.frame(maxHeight: value)
        }
    }

    @ViewBuilder
    private func applyFractional(_ content: Content, fraction: CGFloat) -> some View {
        switch (axis, type) {
        case (.horizontal, .exact):
            content.containerRelativeFrame(.horizontal) { containerWidth, _ in
                containerWidth * fraction
            }
        case (.horizontal, .minimum):
            content.containerRelativeFrame(.horizontal) { containerWidth, _ in
                containerWidth * fraction
            }
            .frame(minWidth: 0)
        case (.horizontal, .maximum):
            content.containerRelativeFrame(.horizontal) { containerWidth, _ in
                containerWidth * fraction
            }
            .frame(maxWidth: .infinity)
        case (.vertical, .exact):
            content.containerRelativeFrame(.vertical) { containerHeight, _ in
                containerHeight * fraction
            }
        case (.vertical, .minimum):
            content.containerRelativeFrame(.vertical) { containerHeight, _ in
                containerHeight * fraction
            }
            .frame(minHeight: 0)
        case (.vertical, .maximum):
            content.containerRelativeFrame(.vertical) { containerHeight, _ in
                containerHeight * fraction
            }
            .frame(maxHeight: .infinity)
        }
    }
}
