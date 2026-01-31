//
//  RenderTree.swift
//  ScalsRendererFramework
//
//  Intermediate Representation (IR) for rendering.
//  This is the resolved, ready-to-render tree structure.
//
//  **Important**: This file should remain platform-agnostic. Do NOT import
//  SwiftUI or UIKit here. Platform-specific conversions belong in the
//  renderer layer (see `Renderers/SwiftUI/IRTypeConversions.swift`).
//

import Foundation

// MARK: - Render Tree

/// The root of the resolved render tree
/// All styles resolved, data bound, references validated
public struct RenderTree {
    /// The root node containing all children
    public let root: RootNode

    /// Reference to state store for dynamic updates
    public let stateStore: StateStore

    /// Action definitions for execution
    public let actions: [String: ActionDefinition]

    public init(root: RootNode, stateStore: StateStore, actions: [String: ActionDefinition]) {
        self.root = root
        self.stateStore = stateStore
        self.actions = actions
    }
}

// MARK: - Color Scheme

/// Type alias for backward compatibility
/// - Note: Use `IR.ColorScheme` directly in new code
public typealias RenderColorScheme = IR.ColorScheme

// MARK: - Root Node

/// The resolved root container
public struct RootNode {
    public let backgroundColor: IR.Color
    public let edgeInsets: IR.PositionedEdgeInsets?
    public let colorScheme: IR.ColorScheme
    public let actions: LifecycleActions
    public let children: [RenderNode]

    // MARK: - Flattened Style Properties

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

// MARK: - Render Node Kind

/// Type-safe render node kind identifier.
///
/// Uses struct with static constants for compile-time safety while remaining extensible.
/// External modules can add new render node kinds without modifying core code.
///
/// Built-in kinds are accessed via static properties:
/// ```swift
/// RenderNodeKind.text
/// RenderNodeKind.button
/// ```
///
/// External modules can extend with new kinds:
/// ```swift
/// extension RenderNodeKind {
///     public static let chart = RenderNodeKind(rawValue: "chart")
/// }
/// ```
public struct RenderNodeKind: Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - Built-in Render Node Kinds

extension RenderNodeKind {
    public static let container = RenderNodeKind(rawValue: "container")
    public static let sectionLayout = RenderNodeKind(rawValue: "sectionLayout")
    public static let text = RenderNodeKind(rawValue: "text")
    public static let button = RenderNodeKind(rawValue: "button")
    public static let textField = RenderNodeKind(rawValue: "textField")
    public static let toggle = RenderNodeKind(rawValue: "toggle")
    public static let slider = RenderNodeKind(rawValue: "slider")
    public static let image = RenderNodeKind(rawValue: "image")
    public static let gradient = RenderNodeKind(rawValue: "gradient")
    public static let shape = RenderNodeKind(rawValue: "shape")
    public static let pageIndicator = RenderNodeKind(rawValue: "pageIndicator")
    public static let spacer = RenderNodeKind(rawValue: "spacer")
    public static let divider = RenderNodeKind(rawValue: "divider")
    public static let custom = RenderNodeKind(rawValue: "custom")
}

// MARK: - Custom Render Node Protocol

/// Protocol for custom render nodes defined by external modules.
///
/// Implement this protocol to create custom component render nodes.
///
/// Example:
/// ```swift
/// struct ChartNode: CustomRenderNode {
///     static let kind = RenderNodeKind(rawValue: "chart")
///
///     let dataPoints: [Double]
///     let chartType: String
///     let style: IR.Style
/// }
/// ```
public protocol CustomRenderNode: Sendable {
    /// The kind identifier for this custom node
    static var kind: RenderNodeKind { get }
}

// MARK: - Render Node

/// A node in the render tree - either a container or a leaf component
public enum RenderNode {
    case container(ContainerNode)
    case sectionLayout(SectionLayoutNode)
    case text(TextNode)
    case button(ButtonNode)
    case textField(TextFieldNode)
    case toggle(ToggleNode)
    case slider(SliderNode)
    case image(ImageNode)
    case gradient(GradientNode)
    case shape(ShapeNode)
    case pageIndicator(PageIndicatorNode)
    case spacer(SpacerNode)
    case divider(DividerNode)
    /// Custom render node for extensible components
    case custom(kind: RenderNodeKind, node: any CustomRenderNode)

    /// The kind of this render node
    public var kind: RenderNodeKind {
        switch self {
        case .container: return .container
        case .sectionLayout: return .sectionLayout
        case .text: return .text
        case .button: return .button
        case .textField: return .textField
        case .toggle: return .toggle
        case .slider: return .slider
        case .image: return .image
        case .gradient: return .gradient
        case .shape: return .shape
        case .pageIndicator: return .pageIndicator
        case .spacer: return .spacer
        case .divider: return .divider
        case .custom(let kind, _): return kind
        }
    }
}

// MARK: - Container Node

/// A layout container (VStack, HStack, ZStack)
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

    // MARK: - Flattened Style Properties (fully resolved)

    /// Padding around the container content (fully resolved, no merging needed)
    public let padding: IR.EdgeInsets

    /// Background color (always present, use .clear for transparent)
    public let backgroundColor: IR.Color

    /// Corner radius for rounded corners
    public let cornerRadius: CGFloat

    /// Shadow effect (nil if no shadow)
    public let shadow: IR.Shadow?

    /// Border effect (nil if no border)
    public let border: IR.Border?

    // MARK: - Sizing

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


// MARK: - Section Layout Node

/// A section-based layout container for heterogeneous sections
public struct SectionLayoutNode {
    public let id: String?
    public let sectionSpacing: CGFloat
    public let sections: [IR.Section]

    public init(
        id: String? = nil,
        sectionSpacing: CGFloat = 0,
        sections: [IR.Section] = []
    ) {
        self.id = id
        self.sectionSpacing = sectionSpacing
        self.sections = sections
    }
}

// MARK: - Text Node

/// A text/label component
public struct TextNode {
    public let id: String?
    public let content: String
    public let styleId: String?

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

    /// Background color
    public let backgroundColor: IR.Color

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

// MARK: - Button Node

/// Fully resolved style for a single button state.
///
/// Contains all visual properties needed to render a button in a specific state.
/// This replaces the old IR.Style-based ButtonStyles for flattened IR.
public struct ButtonStateStyle: Sendable {
    // Typography
    public let textColor: IR.Color
    public let fontSize: CGFloat
    public let fontWeight: IR.FontWeight

    // Background & Border
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

/// A button component
public struct ButtonNode {
    /// Image placement relative to text
    public enum ImagePlacement: String, Codable {
        case leading
        case trailing
        case top
        case bottom
    }

    /// Button shape affecting corner radius
    public enum ButtonShape: String, Codable {
        case circle        // cornerRadius = min(width, height) / 2
        case capsule       // cornerRadius = height / 2
        case roundedSquare // cornerRadius = fixed (10px)
    }

    public let id: String?
    public let label: String
    public let styleId: String?
    public let styles: ButtonStyles
    public let isSelectedBinding: String?
    public let fillWidth: Bool
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

// MARK: - TextField Node

/// A text input component
public struct TextFieldNode {
    public let id: String?
    public let placeholder: String
    public let styleId: String?
    public let bindingPath: String?  // State path to bind to

    // MARK: - Flattened Style Properties

    public let textColor: IR.Color
    public let fontSize: CGFloat
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

// MARK: - Toggle Node

/// A toggle/switch component
public struct ToggleNode {
    public let id: String?
    public let styleId: String?
    public let bindingPath: String?  // State path to bind to

    // MARK: - Flattened Style Properties

    public let tintColor: IR.Color?
    public let padding: IR.EdgeInsets
    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?

    public init(
        id: String? = nil,
        styleId: String? = nil,
        bindingPath: String? = nil,
        tintColor: IR.Color? = nil,
        padding: IR.EdgeInsets = .zero,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.styleId = styleId
        self.bindingPath = bindingPath
        self.tintColor = tintColor
        self.padding = padding
        self.width = width
        self.height = height
    }
}

// MARK: - Slider Node

/// A slider component
public struct SliderNode {
    public let id: String?
    public let styleId: String?
    public let bindingPath: String?  // State path to bind to (Double value 0.0-1.0)
    public let minValue: Double
    public let maxValue: Double

    // MARK: - Flattened Style Properties

    public let tintColor: IR.Color?
    public let padding: IR.EdgeInsets
    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?

    public init(
        id: String? = nil,
        styleId: String? = nil,
        bindingPath: String? = nil,
        minValue: Double = 0.0,
        maxValue: Double = 1.0,
        tintColor: IR.Color? = nil,
        padding: IR.EdgeInsets = .zero,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.styleId = styleId
        self.bindingPath = bindingPath
        self.minValue = minValue
        self.maxValue = maxValue
        self.tintColor = tintColor
        self.padding = padding
        self.width = width
        self.height = height
    }
}

// MARK: - Image Node

/// An image component
public struct ImageNode {
    /// Image source type
    public enum Source {
        case sfsymbol(name: String)
        case asset(name: String)
        case url(URL)
        /// Dynamic URL from state - supports templates like "${artwork.primaryImage}"
        case statePath(String)
        /// Activity indicator / loading spinner
        case activityIndicator
    }

    public let id: String?
    public let source: Source
    /// Placeholder image shown when URL is empty/invalid or on error (default: .sfsymbol(name: "photo"))
    public let placeholder: Source?
    /// Loading indicator shown while image is being fetched (default: ProgressView spinner)
    public let loading: Source?
    public let styleId: String?
    public let onTap: Document.Component.ActionBinding?

    // MARK: - Flattened Style Properties

    public let tintColor: IR.Color?
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

// MARK: - Gradient Node

/// A gradient overlay component
public struct GradientNode {
    /// Gradient type
    public enum GradientType {
        case linear
        case radial
    }

    public let id: String?
    public let gradientType: GradientType
    public let colors: [ColorStop]
    public let startPoint: IR.UnitPoint
    public let endPoint: IR.UnitPoint

    // MARK: - Flattened Style Properties

    public let cornerRadius: CGFloat
    public let padding: IR.EdgeInsets
    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?

    public init(
        id: String? = nil,
        gradientType: GradientType = .linear,
        colors: [ColorStop],
        startPoint: IR.UnitPoint = .bottom,
        endPoint: IR.UnitPoint = .top,
        cornerRadius: CGFloat = 0,
        padding: IR.EdgeInsets = .zero,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.gradientType = gradientType
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.width = width
        self.height = height
    }
}

// MARK: - Shape Node

/// A shape component (rectangle, circle, roundedRectangle, capsule, ellipse)
public struct ShapeNode {
    /// Shape type with associated values for parameters like cornerRadius
    public enum ShapeType: Hashable, Sendable {
        case rectangle
        case circle
        case roundedRectangle(cornerRadius: CGFloat)
        case capsule
        case ellipse
    }

    public let id: String?
    public let shapeType: ShapeType

    // MARK: - Flattened Style Properties

    public let fillColor: IR.Color
    public let strokeColor: IR.Color?
    public let strokeWidth: CGFloat
    public let padding: IR.EdgeInsets
    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?

    public init(
        id: String? = nil,
        shapeType: ShapeType,
        fillColor: IR.Color = .clear,
        strokeColor: IR.Color? = nil,
        strokeWidth: CGFloat = 0,
        padding: IR.EdgeInsets = .zero,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.shapeType = shapeType
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.padding = padding
        self.width = width
        self.height = height
    }
}

// MARK: - Page Indicator Node

/// A page indicator component showing dots for pagination
public struct PageIndicatorNode {
    public let id: String?
    public let currentPagePath: String       // State path to read current page
    public let pageCountPath: String?        // State path to read page count (optional)
    public let pageCountStatic: Int?         // Static page count (if not from state)
    public let dotSize: CGFloat
    public let dotSpacing: CGFloat
    public let dotColor: IR.Color
    public let currentDotColor: IR.Color

    // MARK: - Flattened Style Properties

    public let padding: IR.EdgeInsets
    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?

    public init(
        id: String? = nil,
        currentPagePath: String,
        pageCountPath: String? = nil,
        pageCountStatic: Int? = nil,
        dotSize: CGFloat = 8,
        dotSpacing: CGFloat = 8,
        dotColor: IR.Color = IR.Color(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0),
        currentDotColor: IR.Color = IR.Color(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0),
        padding: IR.EdgeInsets = .zero,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.currentPagePath = currentPagePath
        self.pageCountPath = pageCountPath
        self.pageCountStatic = pageCountStatic
        self.dotSize = dotSize
        self.dotSpacing = dotSpacing
        self.dotColor = dotColor
        self.currentDotColor = currentDotColor
        self.padding = padding
        self.width = width
        self.height = height
    }
}

// MARK: - Spacer Node

/// A spacer component with optional sizing properties
public struct SpacerNode {
    /// Minimum length in points (flexible - can grow)
    public let minLength: CGFloat?

    /// Fixed width in points (exact size)
    public let width: CGFloat?

    /// Fixed height in points (exact size)
    public let height: CGFloat?

    public init(minLength: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.minLength = minLength
        self.width = width
        self.height = height
    }
}

extension GradientNode {
    /// A color stop in a gradient
    public struct ColorStop {
        public let color: GradientColor
        public let location: CGFloat  // 0.0 to 1.0

        public init(color: GradientColor, location: CGFloat) {
            self.color = color
            self.location = location
        }
    }
}

/// Color for gradient - can be static or adapt to color scheme
public enum GradientColor {
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

// MARK: - Divider Node

/// A divider/separator component
public struct DividerNode {
    public let id: String?

    // MARK: - Flattened Style Properties

    public let color: IR.Color
    public let thickness: CGFloat
    public let padding: IR.EdgeInsets

    public init(
        id: String? = nil,
        color: IR.Color = IR.Color(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0),
        thickness: CGFloat = 1,
        padding: IR.EdgeInsets = .zero
    ) {
        self.id = id
        self.color = color
        self.thickness = thickness
        self.padding = padding
    }
}

// MARK: - Action Definition

/// A resolved action ready for execution.
///
/// This is the IR representation of an action, used during execution.
/// Codable for serialization/debugging purposes.
public enum ActionDefinition: Codable {
    case dismiss
    case setState(path: String, value: StateSetValue)
    case toggleState(path: String)
    case showAlert(config: AlertActionConfig)
    case sequence(steps: [ActionDefinition])
    case navigate(destination: String, presentation: Document.NavigationPresentation)
    case custom(type: String, parameters: [String: Document.StateValue])

    // MARK: - Codable

    private enum CodingKeys: String, CodingKey {
        case type, path, value, config, steps, destination, presentation, parameters
    }

    private enum ActionType: String, Codable {
        case dismiss, setState, toggleState, showAlert, sequence, navigate, custom
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ActionType.self, forKey: .type)

        switch type {
        case .dismiss:
            self = .dismiss
        case .setState:
            let path = try container.decode(String.self, forKey: .path)
            let value = try container.decode(StateSetValue.self, forKey: .value)
            self = .setState(path: path, value: value)
        case .toggleState:
            let path = try container.decode(String.self, forKey: .path)
            self = .toggleState(path: path)
        case .showAlert:
            let config = try container.decode(AlertActionConfig.self, forKey: .config)
            self = .showAlert(config: config)
        case .sequence:
            let steps = try container.decode([ActionDefinition].self, forKey: .steps)
            self = .sequence(steps: steps)
        case .navigate:
            let destination = try container.decode(String.self, forKey: .destination)
            let presentation = try container.decode(Document.NavigationPresentation.self, forKey: .presentation)
            self = .navigate(destination: destination, presentation: presentation)
        case .custom:
            let customType = try container.decode(String.self, forKey: .type)
            let parameters = try container.decodeIfPresent([String: Document.StateValue].self, forKey: .parameters) ?? [:]
            self = .custom(type: customType, parameters: parameters)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .dismiss:
            try container.encode(ActionType.dismiss, forKey: .type)
        case .setState(let path, let value):
            try container.encode(ActionType.setState, forKey: .type)
            try container.encode(path, forKey: .path)
            try container.encode(value, forKey: .value)
        case .toggleState(let path):
            try container.encode(ActionType.toggleState, forKey: .type)
            try container.encode(path, forKey: .path)
        case .showAlert(let config):
            try container.encode(ActionType.showAlert, forKey: .type)
            try container.encode(config, forKey: .config)
        case .sequence(let steps):
            try container.encode(ActionType.sequence, forKey: .type)
            try container.encode(steps, forKey: .steps)
        case .navigate(let destination, let presentation):
            try container.encode(ActionType.navigate, forKey: .type)
            try container.encode(destination, forKey: .destination)
            try container.encode(presentation, forKey: .presentation)
        case .custom(let customType, let parameters):
            try container.encode(customType, forKey: .type)
            try container.encode(parameters, forKey: .parameters)
        }
    }
}

/// Value to set in state.
///
/// Uses `Document.StateValue` for type-safe, Codable storage.
public enum StateSetValue: Codable {
    case literal(Document.StateValue)
    case expression(String)

    private enum CodingKeys: String, CodingKey {
        case type, value, expression
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        if type == "expression" {
            let expr = try container.decode(String.self, forKey: .expression)
            self = .expression(expr)
        } else {
            let value = try container.decode(Document.StateValue.self, forKey: .value)
            self = .literal(value)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .literal(let value):
            try container.encode("literal", forKey: .type)
            try container.encode(value, forKey: .value)
        case .expression(let expr):
            try container.encode("expression", forKey: .type)
            try container.encode(expr, forKey: .expression)
        }
    }

    /// Convert to Any for runtime use
    public func toAny() -> Any {
        switch self {
        case .literal(let stateValue):
            return StateValueConverter.unwrap(stateValue)
        case .expression(let expr):
            return expr
        }
    }
}

/// Alert action configuration
public struct AlertActionConfig: Codable {
    public let title: String
    public let message: AlertMessage?
    public let buttons: [AlertButtonConfig]

    public init(title: String, message: AlertMessage? = nil, buttons: [AlertButtonConfig] = []) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}

/// Alert message - static or dynamic
public enum AlertMessage: Codable {
    case `static`(String)
    case template(String)  // Contains ${variable} placeholders

    private enum CodingKeys: String, CodingKey {
        case type, value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        let value = try container.decode(String.self, forKey: .value)

        if type == "template" {
            self = .template(value)
        } else {
            self = .static(value)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .static(let value):
            try container.encode("static", forKey: .type)
            try container.encode(value, forKey: .value)
        case .template(let value):
            try container.encode("template", forKey: .type)
            try container.encode(value, forKey: .value)
        }
    }
}

/// Alert button configuration
public struct AlertButtonConfig: Codable {
    public let label: String
    public let style: Document.AlertButtonStyle
    public let action: String?  // Action ID to execute

    public init(label: String, style: Document.AlertButtonStyle = .default, action: String? = nil) {
        self.label = label
        self.style = style
        self.action = action
    }
}
