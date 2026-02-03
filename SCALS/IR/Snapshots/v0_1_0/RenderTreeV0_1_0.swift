//
//  RenderTreeV0_1_0.swift
//  ScalsRendererFramework
//
// ============================================================
// FROZEN SNAPSHOT - DO NOT MODIFY
// IR Schema Version: 0.1.0
// Snapshot Created: 2026-02-02
//
// This file represents the IR schema as it existed in v0.1.0.
// It is preserved for reference and migration purposes only.
// All new development should use the current IR types.
//
// KEY DIFFERENCE FROM v0.2.0:
// - backgroundColor is IR.Color (non-optional, default .clear)
// - In v0.2.0, backgroundColor is IR.Color? (optional, default nil)
// ============================================================
//

import Foundation

// MARK: - RootNode (v0.1.0)

extension IRSnapshot.V0_1_0 {
    /// The resolved root container (v0.1.0 schema)
    ///
    /// **v0.1.0 Difference:** `backgroundColor` is non-optional with default `.clear`
    public struct RootNode {
        /// Background color - non-optional in v0.1.0 (default: .clear)
        public let backgroundColor: IR.Color
        public let edgeInsets: IR.PositionedEdgeInsets?
        public let colorScheme: IR.ColorScheme
        public let actions: LifecycleActions
        public let children: [RenderNode]

        // Flattened Style Properties
        public let padding: IR.EdgeInsets
        public let cornerRadius: CGFloat
        public let shadow: IR.Shadow?
        public let border: IR.Border?

        public init(
            backgroundColor: IR.Color = .clear,
            edgeInsets: IR.PositionedEdgeInsets? = nil,
            colorScheme: IR.ColorScheme = .system,
            actions: LifecycleActions = LifecycleActions(),
            children: [RenderNode] = [],
            padding: IR.EdgeInsets = .zero,
            cornerRadius: CGFloat = 0,
            shadow: IR.Shadow? = nil,
            border: IR.Border? = nil
        ) {
            self.backgroundColor = backgroundColor
            self.edgeInsets = edgeInsets
            self.colorScheme = colorScheme
            self.actions = actions
            self.children = children
            self.padding = padding
            self.cornerRadius = cornerRadius
            self.shadow = shadow
            self.border = border
        }
    }
}

// MARK: - ContainerNode (v0.1.0)

extension IRSnapshot.V0_1_0 {
    /// A layout container (v0.1.0 schema)
    ///
    /// **v0.1.0 Difference:** `backgroundColor` is non-optional with default `.clear`
    public struct ContainerNode {
        /// Layout type for containers
        public enum LayoutType {
            case vstack
            case hstack
            case zstack
        }

        public let id: String?
        public let layoutType: LayoutType
        public let alignment: IR.Alignment
        public let spacing: CGFloat
        public let children: [RenderNode]

        // Flattened Style Properties
        public let padding: IR.EdgeInsets
        /// Background color - non-optional in v0.1.0 (default: .clear)
        public let backgroundColor: IR.Color
        public let cornerRadius: CGFloat
        public let shadow: IR.Shadow?
        public let border: IR.Border?

        // Sizing
        public let width: IR.DimensionValue?
        public let height: IR.DimensionValue?
        public let minWidth: IR.DimensionValue?
        public let minHeight: IR.DimensionValue?
        public let maxWidth: IR.DimensionValue?
        public let maxHeight: IR.DimensionValue?

        public init(
            id: String? = nil,
            layoutType: LayoutType = .vstack,
            alignment: IR.Alignment = .center,
            spacing: CGFloat = 0,
            children: [RenderNode] = [],
            padding: IR.EdgeInsets = .zero,
            backgroundColor: IR.Color = .clear,
            cornerRadius: CGFloat = 0,
            shadow: IR.Shadow? = nil,
            border: IR.Border? = nil,
            width: IR.DimensionValue? = nil,
            height: IR.DimensionValue? = nil,
            minWidth: IR.DimensionValue? = nil,
            minHeight: IR.DimensionValue? = nil,
            maxWidth: IR.DimensionValue? = nil,
            maxHeight: IR.DimensionValue? = nil
        ) {
            self.id = id
            self.layoutType = layoutType
            self.alignment = alignment
            self.spacing = spacing
            self.children = children
            self.padding = padding
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.shadow = shadow
            self.border = border
            self.width = width
            self.height = height
            self.minWidth = minWidth
            self.minHeight = minHeight
            self.maxWidth = maxWidth
            self.maxHeight = maxHeight
        }
    }
}

// MARK: - TextNode (v0.1.0)

extension IRSnapshot.V0_1_0 {
    /// A text/label component (v0.1.0 schema)
    ///
    /// **v0.1.0 Difference:** `backgroundColor` is non-optional with default `.clear`
    public struct TextNode {
        public let id: String?
        public let content: String
        public let styleId: String?
        public let bindingPath: String?
        public let bindingTemplate: String?

        // Flattened Style Properties
        public let padding: IR.EdgeInsets
        public let textColor: IR.Color
        public let fontSize: CGFloat
        public let fontWeight: IR.FontWeight
        public let textAlignment: IR.TextAlignment
        /// Background color - non-optional in v0.1.0 (default: .clear)
        public let backgroundColor: IR.Color
        public let cornerRadius: CGFloat
        public let shadow: IR.Shadow?
        public let border: IR.Border?

        // Sizing
        public let width: IR.DimensionValue?
        public let height: IR.DimensionValue?

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
            backgroundColor: IR.Color = .clear,
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
}

// MARK: - ButtonStateStyle (v0.1.0)

extension IRSnapshot.V0_1_0 {
    /// Fully resolved style for a single button state (v0.1.0 schema)
    ///
    /// **v0.1.0 Difference:** `backgroundColor` is non-optional with default `.clear`
    public struct ButtonStateStyle: Sendable {
        // Typography
        public let textColor: IR.Color
        public let fontSize: CGFloat
        public let fontWeight: IR.FontWeight

        // Background & Border
        /// Background color - non-optional in v0.1.0 (default: .clear)
        public let backgroundColor: IR.Color
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
            backgroundColor: IR.Color = .clear,
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
}

// MARK: - TextFieldNode (v0.1.0)

extension IRSnapshot.V0_1_0 {
    /// A text input component (v0.1.0 schema)
    ///
    /// **v0.1.0 Difference:** `backgroundColor` is non-optional with default `.clear`
    public struct TextFieldNode {
        public let id: String?
        public let placeholder: String
        public let styleId: String?
        public let bindingPath: String?

        // Flattened Style Properties
        public let textColor: IR.Color
        public let fontSize: CGFloat
        /// Background color - non-optional in v0.1.0 (default: .clear)
        public let backgroundColor: IR.Color
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
            backgroundColor: IR.Color = .clear,
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
}

// MARK: - ImageNode (v0.1.0)

extension IRSnapshot.V0_1_0 {
    /// An image component (v0.1.0 schema)
    ///
    /// **v0.1.0 Difference:** `backgroundColor` is non-optional with default `.clear`
    public struct ImageNode {
        /// Image source type (same as current)
        public enum Source {
            case sfsymbol(name: String)
            case asset(name: String)
            case url(URL)
            case statePath(String)
            case activityIndicator
        }

        public let id: String?
        public let source: Source
        public let placeholder: Source?
        public let loading: Source?
        public let styleId: String?
        public let onTap: Document.Component.ActionBinding?

        // Flattened Style Properties
        public let tintColor: IR.Color?
        /// Background color - non-optional in v0.1.0 (default: .clear)
        public let backgroundColor: IR.Color
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
            source: Source,
            placeholder: Source? = nil,
            loading: Source? = nil,
            styleId: String? = nil,
            onTap: Document.Component.ActionBinding? = nil,
            tintColor: IR.Color? = nil,
            backgroundColor: IR.Color = .clear,
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
}

// MARK: - Version Constant

extension IRSnapshot.V0_1_0 {
    /// The IR version this snapshot represents
    public static let version = DocumentVersion(0, 1, 0)
}
