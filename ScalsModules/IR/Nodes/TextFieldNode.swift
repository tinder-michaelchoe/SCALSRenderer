//
//  TextFieldNode.swift
//  ScalsModules
//
//  Text input field component node.
//

import Foundation
import SCALS

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Text field node
    public static let textField = RenderNodeKind(rawValue: "textField")
}

// MARK: - TextField Node

/// A text input component.
///
/// TextFields provide text entry bound to state.
public struct TextFieldNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.textField

    public let id: String?
    public let styleId: String?

    /// Placeholder text shown when empty
    public let placeholder: String

    /// State path to bind to
    public let bindingPath: String?

    // MARK: - Flattened Style Properties

    public let textColor: IR.Color
    public let fontSize: CGFloat
    public let backgroundColor: IR.Color?
    public let cornerRadius: CGFloat
    public let border: IR.Border?
    public let padding: IR.EdgeInsets
    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?

    public init(
        id: String? = nil,
        placeholder: String = "",
        styleId: String? = nil,
        bindingPath: String? = nil,
        textColor: IR.Color = .black,
        fontSize: CGFloat = 17,
        backgroundColor: IR.Color? = nil,
        cornerRadius: CGFloat = 0,
        border: IR.Border? = nil,
        padding: IR.EdgeInsets = .zero,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.placeholder = placeholder
        self.styleId = styleId
        self.bindingPath = bindingPath
        self.textColor = textColor
        self.fontSize = fontSize
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.border = border
        self.padding = padding
        self.width = width
        self.height = height
    }
}
