//
//  CSSGenerator.swift
//  SCALS
//
//  Generates CSS styles from a RenderTree.
//  Walks the tree and creates CSS classes for each styled node.
//

import Foundation
import SCALS

// MARK: - CSS Generator

/// Generates CSS from a RenderTree by walking all nodes and extracting styles.
public struct CSSGenerator {
    // Separate counters for each node type to match HTMLNodeRenderer
    private var containerCounter = 0
    private var textCounter = 0
    private var buttonCounter = 0
    private var imageCounter = 0
    private var textFieldCounter = 0
    private var toggleCounter = 0
    private var sliderCounter = 0
    private var gradientCounter = 0
    private var shapeCounter = 0
    private var pageIndicatorCounter = 0
    private var dividerCounter = 0
    private var sectionLayoutCounter = 0
    private var generatedClasses: [String: String] = [:]

    public init() {}

    /// Generate CSS from a render tree.
    /// - Parameter tree: The render tree to generate CSS for
    /// - Returns: CSS string containing all generated classes
    public mutating func generate(from tree: RenderTree) -> String {
        // Reset all counters
        containerCounter = 0
        textCounter = 0
        buttonCounter = 0
        imageCounter = 0
        textFieldCounter = 0
        toggleCounter = 0
        sliderCounter = 0
        gradientCounter = 0
        shapeCounter = 0
        dividerCounter = 0
        sectionLayoutCounter = 0
        generatedClasses = [:]

        var css = "/* Generated SCALS Styles */\n\n"

        // Generate root styles
        css += generateRootStyles(tree.root)

        // Walk all nodes and generate styles
        for child in tree.root.children {
            css += generateNodeStyles(child)
        }

        return css
    }

    // MARK: - Root Styles

    private func generateRootStyles(_ root: RootNode) -> String {
        var css = ""

        // Root container style
        var rootRules: [String] = []

        // backgroundColor (only apply if specified)
        if let backgroundColor = root.backgroundColor {
            rootRules.append("background-color: \(backgroundColor.cssRGBA)")
        }

        // Edge insets as padding
        if let insets = root.edgeInsets {
            if let top = insets.top {
                rootRules.append("padding-top: \(Int(top.value))px")
            }
            if let bottom = insets.bottom {
                rootRules.append("padding-bottom: \(Int(bottom.value))px")
            }
            if let leading = insets.leading {
                rootRules.append("padding-left: \(Int(leading.value))px")
            }
            if let trailing = insets.trailing {
                rootRules.append("padding-right: \(Int(trailing.value))px")
            }
        }

        // Root flattened style properties
        if root.cornerRadius > 0 {
            rootRules.append("border-radius: \(Int(root.cornerRadius))px")
        }
        if let shadow = root.shadow {
            rootRules.append("box-shadow: \(shadow.cssBoxShadow)")
        }
        if let border = root.border {
            rootRules.append("border: \(border.cssBorder)")
        }
        if !root.padding.isEmpty {
            rootRules.append("padding: \(root.padding.cssPadding)")
        }

        if !rootRules.isEmpty {
            css += ".scals-root {\n"
            css += "    \(rootRules.joined(separator: ";\n    "));\n"
            css += "}\n\n"
        }

        return css
    }

    // MARK: - Node Styles

    private mutating func generateNodeStyles(_ node: RenderNode) -> String {
        var css = ""

        if let container = node.data(ContainerNode.self) {
            css += generateContainerStyles(container)
            for child in container.children {
                css += generateNodeStyles(child)
            }
        } else if let sectionLayout = node.data(SectionLayoutNode.self) {
            css += generateSectionLayoutStyles(sectionLayout)
        } else if let text = node.data(TextNode.self) {
            css += generateTextStyles(text)
        } else if let button = node.data(ButtonNode.self) {
            css += generateButtonStyles(button)
        } else if let textField = node.data(TextFieldNode.self) {
            css += generateTextFieldStyles(textField)
        } else if let toggle = node.data(ToggleNode.self) {
            css += generateToggleStyles(toggle)
        } else if let slider = node.data(SliderNode.self) {
            css += generateSliderStyles(slider)
        } else if let image = node.data(ImageNode.self) {
            css += generateImageStyles(image)
        } else if let gradient = node.data(GradientNode.self) {
            css += generateGradientStyles(gradient)
        } else if let shape = node.data(ShapeNode.self) {
            css += generateShapeStyles(shape)
        } else if let pageIndicator = node.data(PageIndicatorNode.self) {
            css += generatePageIndicatorStyles(pageIndicator)
        } else if let divider = node.data(DividerNode.self) {
            css += generateDividerStyles(divider)
        } else if node.data(SpacerNode.self) != nil {
            // Spacer uses base class, no custom CSS needed
        }
        // Unknown or custom nodes are skipped

        return css
    }

    // MARK: - Container Styles

    private mutating func generateContainerStyles(_ container: ContainerNode) -> String {
        let className = generateContainerClassName(for: container.id)
        var rules: [String] = []

        // Layout type
        switch container.layoutType {
        case .vstack:
            rules.append("display: flex")
            rules.append("flex-direction: column")
        case .hstack:
            rules.append("display: flex")
            rules.append("flex-direction: row")
        case .zstack:
            // ZStack layout is handled by base .ios-zstack class
            // Don't override here to preserve grid stacking behavior
            break
        }

        // Alignment
        // For flexbox, align-items controls cross-axis, justify-content controls main-axis.
        // VStack (column): cross-axis is horizontal, main-axis is vertical
        // HStack (row): cross-axis is vertical, main-axis is horizontal
        // ZStack: alignment is handled via the test helper centering for now
        switch container.layoutType {
        case .vstack:
            // VStack: horizontal alignment → align-items, vertical → justify-content
            rules.append("align-items: \(container.alignment.horizontal.cssJustifyContent)")
            rules.append("justify-content: \(container.alignment.vertical.cssAlignItems)")
        case .hstack:
            // HStack: vertical alignment → align-items, horizontal → justify-content
            rules.append("align-items: \(container.alignment.vertical.cssAlignItems)")
            rules.append("justify-content: \(container.alignment.horizontal.cssJustifyContent)")
        case .zstack:
            // ZStack alignment is handled in base CSS
            break
        }

        // Spacing (gap)
        if container.spacing > 0 {
            rules.append("gap: \(Int(container.spacing))px")
        }

        // Padding - already resolved, directly on node
        if !container.padding.isEmpty {
            rules.append("padding: \(container.padding.cssPadding)")
        }

        // Flattened style properties - directly on node
        if let backgroundColor = container.backgroundColor {
            rules.append("background-color: \(backgroundColor.cssRGBA)")
        }
        if container.cornerRadius > 0 {
            rules.append("border-radius: \(Int(container.cornerRadius))px")
        }
        if let shadow = container.shadow {
            rules.append("box-shadow: \(shadow.cssBoxShadow)")
        }
        if let border = container.border {
            rules.append("border: \(border.cssBorder)")
        }

        // Sizing
        if let width = container.width {
            rules.append("width: \(width.cssValue)")
        }
        if let height = container.height {
            rules.append("height: \(height.cssValue)")
        }
        if let minWidth = container.minWidth {
            rules.append("min-width: \(minWidth.cssValue)")
        }
        if let minHeight = container.minHeight {
            rules.append("min-height: \(minHeight.cssValue)")
        }
        if let maxWidth = container.maxWidth {
            rules.append("max-width: \(maxWidth.cssValue)")
        }
        if let maxHeight = container.maxHeight {
            rules.append("max-height: \(maxHeight.cssValue)")
        }

        var css = ""
        if !rules.isEmpty {
            css += ".\(className) {\n    \(rules.joined(separator: ";\n    "));\n}\n\n"
        }


        return css
    }

    // MARK: - Section Layout Styles

    private mutating func generateSectionLayoutStyles(_ sectionLayout: SectionLayoutNode) -> String {
        var css = ""
        let className = generateSectionLayoutClassName(for: sectionLayout.id)

        // Container styles
        var rules = ["display: flex", "flex-direction: column"]
        if sectionLayout.sectionSpacing > 0 {
            rules.append("gap: \(Int(sectionLayout.sectionSpacing))px")
        }

        css += ".\(className) {\n    \(rules.joined(separator: ";\n    "));\n}\n\n"

        // Generate styles for each section
        for (index, section) in sectionLayout.sections.enumerated() {
            css += generateSectionStyles(section, index: index, parentClass: className)
        }

        return css
    }

    private mutating func generateSectionStyles(_ section: IR.Section, index: Int, parentClass: String) -> String {
        var css = ""
        let sectionClass = "\(parentClass)-section-\(index)"

        var rules: [String] = []

        switch section.layoutType {
        case .horizontal:
            rules.append("display: flex")
            rules.append("flex-direction: row")
            rules.append("overflow-x: auto")
            rules.append("-webkit-overflow-scrolling: touch")
            if !section.config.showsIndicators {
                rules.append("scrollbar-width: none")
            }

        case .list:
            rules.append("display: flex")
            rules.append("flex-direction: column")

        case .grid(let columns):
            rules.append("display: grid")
            switch columns {
            case .fixed(let count):
                rules.append("grid-template-columns: repeat(\(count), 1fr)")
            case .adaptive(let minWidth):
                rules.append("grid-template-columns: repeat(auto-fill, minmax(\(Int(minWidth))px, 1fr))")
            }

        case .flow:
            rules.append("display: flex")
            rules.append("flex-wrap: wrap")
        }

        // Spacing
        if section.config.itemSpacing > 0 || section.config.lineSpacing > 0 {
            let rowGap = section.config.lineSpacing > 0 ? Int(section.config.lineSpacing) : Int(section.config.itemSpacing)
            let colGap = Int(section.config.itemSpacing)
            rules.append("gap: \(rowGap)px \(colGap)px")
        }

        // Content insets
        if !section.config.contentInsets.isEmpty {
            rules.append("padding: \(section.config.contentInsets.cssPadding)")
        }

        css += ".\(sectionClass) {\n    \(rules.joined(separator: ";\n    "));\n}\n\n"

        // Hide scrollbar for horizontal sections
        if case .horizontal = section.layoutType, !section.config.showsIndicators {
            css += ".\(sectionClass)::-webkit-scrollbar {\n    display: none;\n}\n\n"
        }

        // Generate styles for children
        for child in section.children {
            css += generateNodeStyles(child)
        }

        // Header and footer styles
        if let header = section.header {
            css += generateNodeStyles(header)
        }
        if let footer = section.footer {
            css += generateNodeStyles(footer)
        }

        return css
    }

    // MARK: - Component Styles

    private mutating func generateTextStyles(_ text: TextNode) -> String {
        let className = generateTextClassName(for: text.id)
        var rules: [String] = []

        // Flattened text style properties - directly on node
        rules.append("color: \(text.textColor.cssRGBA)")
        rules.append("font-size: \(Int(text.fontSize))px")
        rules.append("font-weight: \(text.fontWeight.cssValue)")
        rules.append("text-align: \(text.textAlignment.cssValue)")
        if let backgroundColor = text.backgroundColor {
            rules.append("background-color: \(backgroundColor.cssRGBA)")
        }

        if text.cornerRadius > 0 {
            rules.append("border-radius: \(Int(text.cornerRadius))px")
        }
        if let shadow = text.shadow {
            rules.append("box-shadow: \(shadow.cssBoxShadow)")
        }
        if let border = text.border {
            rules.append("border: \(border.cssBorder)")
        }
        if !text.padding.isEmpty {
            rules.append("padding: \(text.padding.cssPadding)")
        }
        if let width = text.width {
            rules.append("width: \(width.cssValue)")
        }
        if let height = text.height {
            rules.append("height: \(height.cssValue)")
        }


        return ".\(className) {\n    \(rules.joined(separator: ";\n    "));\n}\n\n"
    }

    private mutating func generateButtonStyles(_ button: ButtonNode) -> String {
        let className = generateButtonClassName(for: button.id)
        var css = ""

        // Normal state - using ButtonStateStyle.cssRuleString()
        let normalRules = button.styles.normal.cssRuleString()
        if !normalRules.isEmpty {
            css += ".\(className) {\n    \(normalRules);\n}\n\n"
        }

        // Selected state
        if let selected = button.styles.selected {
            let selectedRules = selected.cssRuleString()
            if !selectedRules.isEmpty {
                css += ".\(className).selected {\n    \(selectedRules);\n}\n\n"
            }
        }

        // Disabled state
        if let disabled = button.styles.disabled {
            let disabledRules = disabled.cssRuleString()
            if !disabledRules.isEmpty {
                css += ".\(className):disabled {\n    \(disabledRules);\n}\n\n"
            }
        }

        return css
    }

    private mutating func generateTextFieldStyles(_ textField: TextFieldNode) -> String {
        let className = generateTextFieldClassName(for: textField.id)
        var rules: [String] = []

        // Flattened properties - directly on node
        rules.append("color: \(textField.textColor.cssRGBA)")
        rules.append("font-size: \(Int(textField.fontSize))px")
        if let backgroundColor = textField.backgroundColor {
            rules.append("background-color: \(backgroundColor.cssRGBA)")
        }
        if textField.cornerRadius > 0 {
            rules.append("border-radius: \(Int(textField.cornerRadius))px")
        }
        if let border = textField.border {
            rules.append("border: \(border.cssBorder)")
        }
        if !textField.padding.isEmpty {
            rules.append("padding: \(textField.padding.cssPadding)")
        }
        if let width = textField.width {
            rules.append("width: \(width.cssValue)")
        }
        if let height = textField.height {
            rules.append("height: \(height.cssValue)")
        }

        return ".\(className) {\n    \(rules.joined(separator: ";\n    "));\n}\n\n"
    }

    private mutating func generateToggleStyles(_ toggle: ToggleNode) -> String {
        let className = generateToggleClassName(for: toggle.id)
        var rules: [String] = []

        // Flattened properties - directly on node
        if let tintColor = toggle.tintColor {
            rules.append("--toggle-tint: \(tintColor.cssRGBA)")
        }
        if !toggle.padding.isEmpty {
            rules.append("padding: \(toggle.padding.cssPadding)")
        }
        if let width = toggle.width {
            rules.append("width: \(width.cssValue)")
        }
        if let height = toggle.height {
            rules.append("height: \(height.cssValue)")
        }

        guard !rules.isEmpty else {
            return ""
        }
        return ".\(className) {\n    \(rules.joined(separator: ";\n    "));\n}\n\n"
    }

    private mutating func generateSliderStyles(_ slider: SliderNode) -> String {
        let className = generateSliderClassName(for: slider.id)
        var rules: [String] = []

        // Flattened properties - directly on node
        if let tintColor = slider.tintColor {
            rules.append("--slider-tint: \(tintColor.cssRGBA)")
        }
        if !slider.padding.isEmpty {
            rules.append("padding: \(slider.padding.cssPadding)")
        }
        if let width = slider.width {
            rules.append("width: \(width.cssValue)")
        }
        if let height = slider.height {
            rules.append("height: \(height.cssValue)")
        }

        guard !rules.isEmpty else {
            return ""
        }
        return ".\(className) {\n    \(rules.joined(separator: ";\n    "));\n}\n\n"
    }

    private mutating func generateImageStyles(_ image: ImageNode) -> String {
        let className = generateImageClassName(for: image.id)
        var rules: [String] = []

        // Flattened properties - directly on node
        if let tintColor = image.tintColor {
            rules.append("color: \(tintColor.cssRGBA)")
        }
        if let backgroundColor = image.backgroundColor {
            rules.append("background-color: \(backgroundColor.cssRGBA)")
        }
        if image.cornerRadius > 0 {
            rules.append("border-radius: \(Int(image.cornerRadius))px")
        }
        if let shadow = image.shadow {
            rules.append("box-shadow: \(shadow.cssBoxShadow)")
        }
        if let border = image.border {
            rules.append("border: \(border.cssBorder)")
        }
        if !image.padding.isEmpty {
            rules.append("padding: \(image.padding.cssPadding)")
        }
        if let width = image.width {
            rules.append("width: \(width.cssValue)")
        }
        if let height = image.height {
            rules.append("height: \(height.cssValue)")
        }
        if let minWidth = image.minWidth {
            rules.append("min-width: \(minWidth.cssValue)")
        }
        if let minHeight = image.minHeight {
            rules.append("min-height: \(minHeight.cssValue)")
        }
        if let maxWidth = image.maxWidth {
            rules.append("max-width: \(maxWidth.cssValue)")
        }
        if let maxHeight = image.maxHeight {
            rules.append("max-height: \(maxHeight.cssValue)")
        }

        return ".\(className) {\n    \(rules.joined(separator: ";\n    "));\n}\n\n"
    }

    private mutating func generateGradientStyles(_ gradient: GradientNode) -> String {
        let className = generateGradientClassName(for: gradient.id)
        var rules: [String] = []

        // Gradient background
        rules.append("background: \(gradient.cssGradient)")

        // Flattened properties - directly on node
        if gradient.cornerRadius > 0 {
            rules.append("border-radius: \(Int(gradient.cornerRadius))px")
        }
        if !gradient.padding.isEmpty {
            rules.append("padding: \(gradient.padding.cssPadding)")
        }
        if let width = gradient.width {
            rules.append("width: \(width.cssValue)")
        }
        if let height = gradient.height {
            rules.append("height: \(height.cssValue)")
        }

        return ".\(className) {\n    \(rules.joined(separator: ";\n    "));\n}\n\n"
    }

    private mutating func generateShapeStyles(_ shape: ShapeNode) -> String {
        let className = generateShapeClassName(for: shape.id)
        var rules: [String] = []

        // Flattened properties - directly on node
        rules.append("background-color: \(shape.fillColor.cssRGBA)")
        if let strokeColor = shape.strokeColor {
            rules.append("border-color: \(strokeColor.cssRGBA)")
        }
        if shape.strokeWidth > 0 {
            rules.append("border-width: \(Int(shape.strokeWidth))px")
            rules.append("border-style: solid")
        }

        // Corner radius based on shape type
        switch shape.shapeType {
        case .roundedRectangle(let cornerRadius):
            rules.append("border-radius: \(Int(cornerRadius))px")
        case .circle, .capsule:
            rules.append("border-radius: 50%")
        case .rectangle, .ellipse:
            break
        }

        if !shape.padding.isEmpty {
            rules.append("padding: \(shape.padding.cssPadding)")
        }
        if let width = shape.width {
            rules.append("width: \(width.cssValue)")
        }
        if let height = shape.height {
            rules.append("height: \(height.cssValue)")
        }

        return ".\(className) {\n    \(rules.joined(separator: ";\n    "));\n}\n\n"
    }

    private mutating func generatePageIndicatorStyles(_ pageIndicator: PageIndicatorNode) -> String {
        let className = generatePageIndicatorClassName(for: pageIndicator.id)
        var rules: [String] = []

        // Flattened properties - directly on node
        if !pageIndicator.padding.isEmpty {
            rules.append("padding: \(pageIndicator.padding.cssPadding)")
        }
        if let width = pageIndicator.width {
            rules.append("width: \(width.cssValue)")
        }
        if let height = pageIndicator.height {
            rules.append("height: \(height.cssValue)")
        }

        guard !rules.isEmpty else {
            return ""
        }

        return ".\(className) {\n    \(rules.joined(separator: ";\n    "));\n}\n\n"
    }

    private mutating func generateDividerStyles(_ divider: DividerNode) -> String {
        let className = generateDividerClassName(for: divider.id)
        var rules: [String] = []

        // Flattened properties - directly on node
        rules.append("background-color: \(divider.color.cssRGBA)")
        rules.append("height: \(Int(divider.thickness))px")
        if !divider.padding.isEmpty {
            rules.append("margin: \(divider.padding.cssPadding)")
        }

        return ".\(className) {\n    \(rules.joined(separator: ";\n    "));\n}\n\n"
    }


    // MARK: - Helpers

    private mutating func generateContainerClassName(for id: String?) -> String {
        containerCounter += 1
        if let id = id {
            return "scals-container-\(id.cssClassName)"
        }
        return "scals-container-\(containerCounter)"
    }

    private mutating func generateTextClassName(for id: String?) -> String {
        textCounter += 1
        if let id = id {
            return "scals-text-\(id.cssClassName)"
        }
        return "scals-text-\(textCounter)"
    }

    private mutating func generateButtonClassName(for id: String?) -> String {
        buttonCounter += 1
        if let id = id {
            return "scals-button-\(id.cssClassName)"
        }
        return "scals-button-\(buttonCounter)"
    }

    private mutating func generateImageClassName(for id: String?) -> String {
        imageCounter += 1
        if let id = id {
            return "scals-image-\(id.cssClassName)"
        }
        return "scals-image-\(imageCounter)"
    }

    private mutating func generateTextFieldClassName(for id: String?) -> String {
        textFieldCounter += 1
        if let id = id {
            return "scals-textfield-\(id.cssClassName)"
        }
        return "scals-textfield-\(textFieldCounter)"
    }

    private mutating func generateToggleClassName(for id: String?) -> String {
        toggleCounter += 1
        if let id = id {
            return "scals-toggle-\(id.cssClassName)"
        }
        return "scals-toggle-\(toggleCounter)"
    }

    private mutating func generateSliderClassName(for id: String?) -> String {
        sliderCounter += 1
        if let id = id {
            return "scals-slider-\(id.cssClassName)"
        }
        return "scals-slider-\(sliderCounter)"
    }

    private mutating func generateGradientClassName(for id: String?) -> String {
        gradientCounter += 1
        if let id = id {
            return "scals-gradient-\(id.cssClassName)"
        }
        return "scals-gradient-\(gradientCounter)"
    }

    private mutating func generateShapeClassName(for id: String?) -> String {
        shapeCounter += 1
        if let id = id {
            return "scals-shape-\(id.cssClassName)"
        }
        return "scals-shape-\(shapeCounter)"
    }

    private mutating func generatePageIndicatorClassName(for id: String?) -> String {
        pageIndicatorCounter += 1
        if let id = id {
            return "scals-page-indicator-\(id.cssClassName)"
        }
        return "scals-page-indicator-\(pageIndicatorCounter)"
    }

    private mutating func generateDividerClassName(for id: String?) -> String {
        dividerCounter += 1
        if let id = id {
            return "scals-divider-\(id.cssClassName)"
        }
        return "scals-divider-\(dividerCounter)"
    }

    private mutating func generateSectionLayoutClassName(for id: String?) -> String {
        sectionLayoutCounter += 1
        if let id = id {
            return "scals-section-layout-\(id.cssClassName)"
        }
        return "scals-section-layout-\(sectionLayoutCounter)"
    }
}

// MARK: - CSS Generating Protocol

/// Protocol for custom nodes that can generate their own CSS.
public protocol CSSGenerating {
    /// Generate CSS for this node.
    func generateCSS() -> String
}
