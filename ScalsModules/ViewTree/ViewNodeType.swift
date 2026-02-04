//
//  ViewNodeType.swift
//  ScalsModules
//
//  Extracted from SCALS ViewNode.swift to separate renderer-specific metadata
//  from core tracking infrastructure.
//

import SCALS
import Foundation

// MARK: - View Node Type

/// The type of a view node
public enum ViewNodeType: Sendable {
    case root(RootNodeData)
    case container(ContainerNodeData)
    case sectionLayout(SectionLayoutNodeData)
    case section(SectionNodeData)
    case text(TextNodeData)
    case button(ButtonNodeData)
    case textField(TextFieldNodeData)
    case toggle(ToggleNodeData)
    case slider(SliderNodeData)
    case image(ImageNodeData)
    case gradient(GradientNodeData)
    case shape(ShapeNodeData)
    case spacer
    case customComponent(CustomComponentNodeData)
}

// MARK: - Node Data Types

public struct RootNodeData: Sendable {
    public var backgroundColor: String?
    public var colorScheme: IR.ColorScheme

    public init(backgroundColor: String? = nil, colorScheme: IR.ColorScheme = .system) {
        self.backgroundColor = backgroundColor
        self.colorScheme = colorScheme
    }
}

public struct ContainerNodeData: Sendable {
    public var layoutType: LayoutType
    public var alignment: IR.Alignment
    public var spacing: CGFloat
    public var padding: IR.EdgeInsets

    public init(
        layoutType: LayoutType = .vstack,
        alignment: IR.Alignment = .center,
        spacing: CGFloat = 0,
        padding: IR.EdgeInsets = .zero
    ) {
        self.layoutType = layoutType
        self.alignment = alignment
        self.spacing = spacing
        self.padding = padding
    }
}

public struct SectionLayoutNodeData: Sendable {
    public var sectionSpacing: CGFloat

    public init(sectionSpacing: CGFloat = 0) {
        self.sectionSpacing = sectionSpacing
    }
}

public struct SectionNodeData: Sendable {
    public var layoutType: IR.SectionType
    public var stickyHeader: Bool
    public var config: IR.SectionConfig

    public init(
        layoutType: IR.SectionType = .list,
        stickyHeader: Bool = false,
        config: IR.SectionConfig = IR.SectionConfig()
    ) {
        self.layoutType = layoutType
        self.stickyHeader = stickyHeader
        self.config = config
    }
}

public struct TextNodeData: Sendable {
    public var content: String

    public init(content: String = "") {
        self.content = content
    }
}

public struct ButtonNodeData: Sendable {
    public var label: String
    public var fillWidth: Bool
    public var onTapAction: Document.Component.ActionBinding?

    public init(
        label: String = "",
        fillWidth: Bool = false,
        onTapAction: Document.Component.ActionBinding? = nil
    ) {
        self.label = label
        self.fillWidth = fillWidth
        self.onTapAction = onTapAction
    }
}

public struct TextFieldNodeData: Sendable {
    public var placeholder: String
    public var bindingPath: String?

    public init(
        placeholder: String = "",
        bindingPath: String? = nil
    ) {
        self.placeholder = placeholder
        self.bindingPath = bindingPath
    }
}

public struct ToggleNodeData: Sendable {
    public var bindingPath: String?

    public init(
        bindingPath: String? = nil
    ) {
        self.bindingPath = bindingPath
    }
}

public struct SliderNodeData: Sendable {
    public var bindingPath: String?
    public var minValue: Double
    public var maxValue: Double

    public init(
        bindingPath: String? = nil,
        minValue: Double = 0.0,
        maxValue: Double = 1.0
    ) {
        self.bindingPath = bindingPath
        self.minValue = minValue
        self.maxValue = maxValue
    }
}

public struct ImageNodeData: Sendable {
    public var source: ImageSource
    public var placeholder: ImageSource?
    public var loading: ImageSource?

    public init(source: ImageSource = .sfsymbol(name: "questionmark"), placeholder: ImageSource? = nil, loading: ImageSource? = nil) {
        self.source = source
        self.placeholder = placeholder
        self.loading = loading
    }
}

public struct GradientNodeData: Sendable {
    public var gradientType: GradientType
    public var colors: [GradientColorStop]
    public var startPoint: IR.UnitPoint
    public var endPoint: IR.UnitPoint

    public init(
        gradientType: GradientType = .linear,
        colors: [GradientColorStop] = [],
        startPoint: IR.UnitPoint = .top,
        endPoint: IR.UnitPoint = .bottom
    ) {
        self.gradientType = gradientType
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

public struct ShapeNodeData: Sendable {
    public var shapeType: ShapeType

    public init(shapeType: ShapeType) {
        self.shapeType = shapeType
    }
}

public struct CustomComponentNodeData: Sendable {
    public var typeName: String

    public init(typeName: String) {
        self.typeName = typeName
    }
}
