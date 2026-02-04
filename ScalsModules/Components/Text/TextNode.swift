//
//  TextNode.swift
//  ScalsModules
//
//  Text/label component node.
//

import Foundation
import SCALS

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Text/label node
    public static let text = RenderNodeKind(rawValue: "text")
}

// MARK: - Text Node

/// A text/label component.
///
/// Displays text content with optional state binding for dynamic content.
public struct TextNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.text

    public let id: String?
    public let styleId: String?

    /// Static text content
    public let content: String

    /// If set, the content should be read dynamically from StateStore at this path
    public let bindingPath: String?

    /// If set, this template should be interpolated with StateStore values (e.g., "Hello ${name}")
    public let bindingTemplate: String?

    // MARK: - Flattened Style Properties (fully resolved)

    /// Padding around the text
    public let padding: IR.EdgeInsets

    /// Text color
    public let textColor: IR.Color

    /// Font size in points
    public let fontSize: CGFloat

    /// Font weight
    public let fontWeight: IR.FontWeight

    /// Text alignment
    public let textAlignment: IR.TextAlignment

    /// Background color (nil means no background applied)
    public let backgroundColor: IR.Color?

    /// Corner radius for background
    public let cornerRadius: CGFloat

    /// Shadow effect (nil if no shadow)
    public let shadow: IR.Shadow?

    /// Border effect (nil if no border)
    public let border: IR.Border?

    // MARK: - Sizing

    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?

    /// Whether this text node has dynamic content that should be observed
    public var isDynamic: Bool {
        bindingPath != nil || bindingTemplate != nil
    }

    public init(
        id: String? = nil,
        content: String,
        styleId: String? = nil,
        bindingPath: String? = nil,
        bindingTemplate: String? = nil,
        padding: IR.EdgeInsets = .zero,
        textColor: IR.Color = .black,
        fontSize: CGFloat = 17,
        fontWeight: IR.FontWeight = .regular,
        textAlignment: IR.TextAlignment = .leading,
        backgroundColor: IR.Color? = nil,
        cornerRadius: CGFloat = 0,
        shadow: IR.Shadow? = nil,
        border: IR.Border? = nil,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.content = content
        self.styleId = styleId
        self.bindingPath = bindingPath
        self.bindingTemplate = bindingTemplate
        self.padding = padding
        self.textColor = textColor
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.border = border
        self.width = width
        self.height = height
    }
}
