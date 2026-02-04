//
//  ImageNode.swift
//  ScalsModules
//
//  Image component node.
//

import Foundation
import SCALS

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Image node
    public static let image = RenderNodeKind(rawValue: "image")
}

// MARK: - Image Node

/// An image component.
///
/// Supports SF Symbols, asset catalog images, remote URLs, and state-bound images.
public struct ImageNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.image

    /// Type alias for compatibility - uses standalone ImageSource from SCALS
    public typealias Source = ImageSource

    public let id: String?
    public let styleId: String?

    /// The image source
    public let source: ImageSource

    /// Placeholder image shown when URL is empty/invalid or on error
    public let placeholder: ImageSource?

    /// Loading indicator shown while image is being fetched
    public let loading: ImageSource?

    /// Action to perform on tap
    public let onTap: Document.Component.ActionBinding?

    // MARK: - Flattened Style Properties

    public let tintColor: IR.Color?
    public let backgroundColor: IR.Color?
    public let cornerRadius: CGFloat
    public let border: IR.Border?
    public let shadow: IR.Shadow?
    public let padding: IR.EdgeInsets
    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?
    public let minWidth: IR.DimensionValue?
    public let minHeight: IR.DimensionValue?
    public let maxWidth: IR.DimensionValue?
    public let maxHeight: IR.DimensionValue?

    public init(
        id: String? = nil,
        source: ImageSource,
        placeholder: ImageSource? = nil,
        loading: ImageSource? = nil,
        styleId: String? = nil,
        onTap: Document.Component.ActionBinding? = nil,
        tintColor: IR.Color? = nil,
        backgroundColor: IR.Color? = nil,
        cornerRadius: CGFloat = 0,
        border: IR.Border? = nil,
        shadow: IR.Shadow? = nil,
        padding: IR.EdgeInsets = .zero,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil,
        minWidth: IR.DimensionValue? = nil,
        minHeight: IR.DimensionValue? = nil,
        maxWidth: IR.DimensionValue? = nil,
        maxHeight: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.source = source
        self.placeholder = placeholder
        self.loading = loading
        self.styleId = styleId
        self.onTap = onTap
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.border = border
        self.shadow = shadow
        self.padding = padding
        self.width = width
        self.height = height
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
}
