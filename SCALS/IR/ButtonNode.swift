//
//  ButtonNode.swift
//  SCALS
//
//  Button component node.
//

import Foundation

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Button node
    public static let button = RenderNodeKind(rawValue: "button")
}

// MARK: - Button State Style

/// Fully resolved style for a single button state.
///
/// Contains all visual properties needed to render a button in a specific state.
public struct ButtonStateStyle: Sendable {
    // Typography
    public let textColor: IR.Color
    public let fontSize: CGFloat
    public let fontWeight: IR.FontWeight

    // Background & Border (nil means no background applied)
    public let backgroundColor: IR.Color?
    public let cornerRadius: CGFloat
    public let border: IR.Border?

    // Shadow
    public let shadow: IR.Shadow?

    // Image
    public let tintColor: IR.Color?

    // Sizing
    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?
    public let minWidth: IR.DimensionValue?
    public let minHeight: IR.DimensionValue?
    public let maxWidth: IR.DimensionValue?
    public let maxHeight: IR.DimensionValue?

    // Padding
    public let padding: IR.EdgeInsets

    public init(
        textColor: IR.Color = .black,
        fontSize: CGFloat = 17,
        fontWeight: IR.FontWeight = .regular,
        backgroundColor: IR.Color? = nil,
        cornerRadius: CGFloat = 0,
        border: IR.Border? = nil,
        shadow: IR.Shadow? = nil,
        tintColor: IR.Color? = nil,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil,
        minWidth: IR.DimensionValue? = nil,
        minHeight: IR.DimensionValue? = nil,
        maxWidth: IR.DimensionValue? = nil,
        maxHeight: IR.DimensionValue? = nil,
        padding: IR.EdgeInsets = .zero
    ) {
        self.textColor = textColor
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.border = border
        self.shadow = shadow
        self.tintColor = tintColor
        self.width = width
        self.height = height
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.padding = padding
    }
}

// MARK: - Button Styles

/// Resolved styles for different button states
public struct ButtonStyles: Sendable {
    public let normal: ButtonStateStyle
    public let selected: ButtonStateStyle?
    public let disabled: ButtonStateStyle?

    public init(
        normal: ButtonStateStyle = ButtonStateStyle(),
        selected: ButtonStateStyle? = nil,
        disabled: ButtonStateStyle? = nil
    ) {
        self.normal = normal
        self.selected = selected
        self.disabled = disabled
    }

    /// Get the appropriate style for the current state
    public func style(isSelected: Bool, isDisabled: Bool = false) -> ButtonStateStyle {
        if isDisabled, let disabled = disabled {
            return disabled
        }
        if isSelected, let selected = selected {
            return selected
        }
        return normal
    }
}

// MARK: - Button Node

/// A button component.
///
/// Buttons support text, images, multiple states, and tap actions.
public struct ButtonNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.button

    /// Image placement relative to text
    @frozen
    public enum ImagePlacement: String, Codable, Sendable {
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

    public let id: String?
    public let styleId: String?

    /// Button label text
    public let label: String

    /// Styles for different states
    public let styles: ButtonStyles

    /// State path for selected state binding
    public let isSelectedBinding: String?

    /// Whether button should fill available width
    public let fillWidth: Bool

    /// Action to perform on tap
    public let onTap: Document.Component.ActionBinding?

    // Image support
    public let image: ImageNode.Source?
    public let imagePlacement: ImagePlacement
    public let imageSpacing: CGFloat

    // Button shape
    public let buttonShape: ButtonShape?

    /// Convenience accessor for the normal state style
    public var style: ButtonStateStyle { styles.normal }

    public init(
        id: String? = nil,
        label: String,
        styleId: String? = nil,
        styles: ButtonStyles = ButtonStyles(),
        isSelectedBinding: String? = nil,
        fillWidth: Bool = false,
        onTap: Document.Component.ActionBinding? = nil,
        image: ImageNode.Source? = nil,
        imagePlacement: ImagePlacement = .leading,
        imageSpacing: CGFloat = 8,
        buttonShape: ButtonShape? = nil
    ) {
        self.id = id
        self.label = label
        self.styleId = styleId
        self.styles = styles
        self.isSelectedBinding = isSelectedBinding
        self.fillWidth = fillWidth
        self.onTap = onTap
        self.image = image
        self.imagePlacement = imagePlacement
        self.imageSpacing = imageSpacing
        self.buttonShape = buttonShape
    }
}
