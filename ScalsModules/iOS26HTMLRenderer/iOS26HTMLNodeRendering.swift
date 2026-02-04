//
//  iOS26HTMLNodeRendering.swift
//  ScalsRendererFramework
//
//  Node-by-node rendering logic for iOS 26 HTML renderer.
//  Follows the Golden Rule: no arithmetic, no nil coalescing - properties are already resolved.
//

import Foundation
import SCALS

/// Internal renderer for individual render nodes
struct iOS26HTMLNodeRenderer {

    // MARK: - Counter for Unique IDs

    private var elementCounter = 0

    mutating func nextElementId() -> String {
        elementCounter += 1
        return "el-\(elementCounter)"
    }

    // MARK: - Root Rendering

    mutating func render(_ root: RootNode) -> String {
        var html = ""

        // Apply root container styling if present
        var rootClasses: [String] = []
        var rootStyles: [String] = []

        // Padding
        rootClasses.append(contentsOf: root.padding.tailwindPaddingClasses)

        // Corner radius
        if root.cornerRadius > 0 {
            rootClasses.append("rounded-[\(formatPx(root.cornerRadius))]")
        }

        // Shadow
        if let shadow = root.shadow {
            rootStyles.append(shadow.ios26CssBoxShadow)
        }

        // Border
        if let border = root.border {
            rootClasses.append(contentsOf: border.tailwindClasses)
        }

        // Render root container
        let classAttr = iOS26TailwindClasses.buildClassAttribute(rootClasses)
        let styleAttr = iOS26TailwindClasses.buildStyleAttribute(rootStyles)
        let attrs = [classAttr, styleAttr].filter { !$0.isEmpty }.joined(separator: " ")

        if !attrs.isEmpty {
            html += "<div \(attrs)>\n"
        }

        // Render all children
        for child in root.children {
            html += renderNode(child)
        }

        if !attrs.isEmpty {
            html += "</div>\n"
        }

        return html
    }

    // MARK: - Node Rendering Dispatch

    mutating func renderNode(_ node: RenderNode) -> String {
        if let container = node.data(ContainerNode.self) {
            return renderContainer(container)
        } else if let section = node.data(SectionLayoutNode.self) {
            return renderSectionLayout(section)
        } else if let text = node.data(TextNode.self) {
            return renderText(text)
        } else if let button = node.data(ButtonNode.self) {
            return renderButton(button)
        } else if let textField = node.data(TextFieldNode.self) {
            return renderTextField(textField)
        } else if let toggle = node.data(ToggleNode.self) {
            return renderToggle(toggle)
        } else if let slider = node.data(SliderNode.self) {
            return renderSlider(slider)
        } else if let image = node.data(ImageNode.self) {
            return renderImage(image)
        } else if let gradient = node.data(GradientNode.self) {
            return renderGradient(gradient)
        } else if let shape = node.data(ShapeNode.self) {
            return renderShape(shape)
        } else if let indicator = node.data(PageIndicatorNode.self) {
            return renderPageIndicator(indicator)
        } else if let spacer = node.data(SpacerNode.self) {
            return renderSpacer(spacer)
        } else if let divider = node.data(DividerNode.self) {
            return renderDivider(divider)
        } else {
            return renderUnknown(kind: node.kind)
        }
    }

    private func renderUnknown(kind: RenderNodeKind) -> String {
        return "<div class=\"scals-unknown\" data-kind=\"\(kind.rawValue)\"></div>"
    }

    // MARK: - Container Rendering

    mutating func renderContainer(_ node: ContainerNode) -> String {
        var classes: [String] = []
        var styles: [String] = []

        // Layout classes
        classes.append(contentsOf: iOS26TailwindClasses.flexLayout(
            type: node.layoutType,
            spacing: node.spacing,
            alignment: node.alignment
        ))

        // Padding
        classes.append(contentsOf: node.padding.tailwindPaddingClasses)

        // Background, corner radius, border
        classes.append(contentsOf: iOS26TailwindClasses.styling(
            backgroundColor: node.backgroundColor,
            cornerRadius: node.cornerRadius,
            border: node.border
        ))

        // Sizing
        classes.append(contentsOf: iOS26TailwindClasses.sizing(
            width: node.width,
            height: node.height,
            minWidth: node.minWidth,
            minHeight: node.minHeight,
            maxWidth: node.maxWidth,
            maxHeight: node.maxHeight
        ))

        // Shadow (inline style)
        if let shadow = node.shadow {
            styles.append(shadow.ios26CssBoxShadow)
        }

        // Build attributes
        let id = node.id ?? nextElementId()
        let classAttr = iOS26TailwindClasses.buildClassAttribute(classes)
        let styleAttr = iOS26TailwindClasses.buildStyleAttribute(styles)
        let attrs = ["id=\"\(id)\"", classAttr, styleAttr]
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        var html = "<div \(attrs)>\n"

        // Render children
        for child in node.children {
            html += renderNode(child)
        }

        html += "</div>\n"

        return html
    }

    // MARK: - Text Rendering

    mutating func renderText(_ node: TextNode) -> String {
        var classes: [String] = []
        var styles: [String] = []

        // Typography
        classes.append(contentsOf: iOS26TailwindClasses.typography(
            fontSize: node.fontSize,
            fontWeight: node.fontWeight,
            textColor: node.textColor,
            textAlignment: node.textAlignment
        ))

        // Padding
        classes.append(contentsOf: node.padding.tailwindPaddingClasses)

        // Background, corner radius, border
        classes.append(contentsOf: iOS26TailwindClasses.styling(
            backgroundColor: node.backgroundColor,
            cornerRadius: node.cornerRadius,
            border: node.border
        ))

        // Sizing
        if let width = node.width {
            classes.append(width.tailwindWidthClass)
        }
        if let height = node.height {
            classes.append(height.tailwindHeightClass)
        }

        // Shadow
        if let shadow = node.shadow {
            styles.append(shadow.ios26CssBoxShadow)
        }

        // Build attributes
        let id = node.id ?? nextElementId()
        let classAttr = iOS26TailwindClasses.buildClassAttribute(classes)
        let styleAttr = iOS26TailwindClasses.buildStyleAttribute(styles)
        let attrs = ["id=\"\(id)\"", classAttr, styleAttr]
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        // Content (escaped)
        let content = node.content.htmlEscaped

        return "<span \(attrs)>\(content)</span>\n"
    }

    // MARK: - Spacer Rendering

    mutating func renderSpacer(_ node: SpacerNode) -> String {
        var classes: [String] = []

        // Flexible spacer or fixed size
        if let width = node.width {
            classes.append("w-[\(formatPx(width))]")
        } else if let height = node.height {
            classes.append("h-[\(formatPx(height))]")
        } else if let minLength = node.minLength {
            // Flexible with minimum
            classes.append("flex-1")
            classes.append("min-w-[\(formatPx(minLength))]")
        } else {
            // Fully flexible
            classes.append("flex-1")
        }

        let classAttr = iOS26TailwindClasses.buildClassAttribute(classes)
        return "<div \(classAttr)></div>\n"
    }

    // MARK: - Divider Rendering

    mutating func renderDivider(_ node: DividerNode) -> String {
        var classes: [String] = []

        // Default iOS divider styling
        classes.append("border-t")
        classes.append("border-gray-200")
        classes.append("my-2")

        let classAttr = iOS26TailwindClasses.buildClassAttribute(classes)
        return "<hr \(classAttr) />\n"
    }

    // MARK: - Button Rendering

    mutating func renderButton(_ node: ButtonNode) -> String {
        let style = node.styles.normal
        var classes: [String] = []
        var styles: [String] = []

        // Typography
        classes.append("text-[\(formatPx(style.fontSize))]")
        classes.append(style.fontWeight.tailwindClass)
        classes.append(style.textColor.tailwindTextClass)

        // Padding
        classes.append(contentsOf: style.padding.tailwindPaddingClasses)

        // Background color (only apply if specified)
        if let backgroundColor = style.backgroundColor {
            classes.append(backgroundColor.tailwindBgClass)
        }

        // Corner radius
        if style.cornerRadius > 0 {
            classes.append("rounded-[\(formatPx(style.cornerRadius))]")
        }

        // Border
        if let border = style.border {
            classes.append(contentsOf: border.tailwindClasses)
        }

        // Shadow
        if let shadow = style.shadow {
            styles.append(shadow.ios26CssBoxShadow)
        }

        // Full width
        if node.fillWidth {
            classes.append("w-full")
        }

        // Sizing
        classes.append(contentsOf: iOS26TailwindClasses.sizing(
            width: style.width,
            height: style.height,
            minWidth: style.minWidth,
            minHeight: style.minHeight,
            maxWidth: style.maxWidth,
            maxHeight: style.maxHeight
        ))

        // iOS button behavior
        classes.append("active:opacity-70")
        classes.append("transition-opacity")
        classes.append("cursor-pointer")

        // Build attributes
        let id = node.id ?? nextElementId()
        let classAttr = iOS26TailwindClasses.buildClassAttribute(classes)
        let styleAttr = iOS26TailwindClasses.buildStyleAttribute(styles)
        let attrs = ["id=\"\(id)\"", classAttr, styleAttr]
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        // Label (escaped)
        let label = node.label.htmlEscaped

        return "<button \(attrs)>\(label)</button>\n"
    }

    // MARK: - TextField Rendering

    mutating func renderTextField(_ node: TextFieldNode) -> String {
        var classes: [String] = []

        // iOS input field styling
        classes.append("w-full")
        classes.append("px-4")
        classes.append("py-3")
        classes.append("bg-white")
        classes.append("border")
        classes.append("border-gray-200")
        classes.append("rounded-xl")
        classes.append("text-[\(formatPx(17))]") // iOS default
        classes.append("focus:outline-none")
        classes.append("focus:border-blue-500")

        let id = node.id ?? nextElementId()
        let classAttr = iOS26TailwindClasses.buildClassAttribute(classes)
        let placeholder = node.placeholder.htmlEscaped

        return "<input type=\"text\" id=\"\(id)\" \(classAttr) placeholder=\"\(placeholder)\" />\n"
    }

    // MARK: - Toggle Rendering

    mutating func renderToggle(_ node: ToggleNode) -> String {
        let id = node.id ?? nextElementId()

        return """
        <label class="relative inline-flex items-center cursor-pointer" for="\(id)">
            <input type="checkbox" id="\(id)" class="sr-only peer" />
            <div class="ios-toggle-track w-12 h-7 bg-gray-300 rounded-full peer peer-checked:bg-green-500 transition-colors relative">
                <div class="ios-toggle-knob absolute top-0.5 left-0.5 w-6 h-6 bg-white rounded-full shadow transition-transform"></div>
            </div>
        </label>

        """
    }

    // MARK: - Slider Rendering

    mutating func renderSlider(_ node: SliderNode) -> String {
        let id = node.id ?? nextElementId()

        return """
        <input type="range" id="\(id)" class="w-full" min="\(node.minValue)" max="\(node.maxValue)" step="0.01" />

        """
    }

    // MARK: - Image Rendering

    mutating func renderImage(_ node: ImageNode) -> String {
        var classes: [String] = []
        var styles: [String] = []

        // Sizing
        classes.append(contentsOf: iOS26TailwindClasses.sizing(
            width: node.width,
            height: node.height
        ))

        // Corner radius
        if node.cornerRadius > 0 {
            classes.append("rounded-[\(formatPx(node.cornerRadius))]")
        }

        // Border
        if let border = node.border {
            classes.append(contentsOf: border.tailwindClasses)
        }

        // Shadow
        if let shadow = node.shadow {
            styles.append(shadow.ios26CssBoxShadow)
        }

        // Object fit
        classes.append("object-cover")

        let id = node.id ?? nextElementId()
        let classAttr = iOS26TailwindClasses.buildClassAttribute(classes)
        let styleAttr = iOS26TailwindClasses.buildStyleAttribute(styles)
        let attrs = ["id=\"\(id)\"", classAttr, styleAttr]
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        // Determine source
        let src: String
        switch node.source {
        case .url(let url):
            src = url.absoluteString
        case .asset(let name):
            src = "/assets/\(name)"
        case .sfsymbol(let name):
            // For SF Symbols, use a Unicode character or icon font
            return "<span \(attrs) aria-label=\"\(name.htmlEscaped)\">􀀀</span>\n"
        case .statePath, .activityIndicator:
            // Not supported in static HTML
            return "<span \(attrs)>[Image]</span>\n"
        }

        return "<img src=\"\(src.htmlEscaped)\" \(attrs) />\n"
    }

    // MARK: - Gradient Rendering

    mutating func renderGradient(_ node: GradientNode) -> String {
        var classes: [String] = []
        var styles: [String] = []

        // Sizing
        classes.append(contentsOf: iOS26TailwindClasses.sizing(
            width: node.width,
            height: node.height
        ))

        // Corner radius
        if node.cornerRadius > 0 {
            classes.append("rounded-[\(formatPx(node.cornerRadius))]")
        }

        // Build gradient CSS
        let gradientCSS = buildGradientCSS(node)
        styles.append("background: \(gradientCSS)")

        let id = node.id ?? nextElementId()
        let classAttr = iOS26TailwindClasses.buildClassAttribute(classes)
        let styleAttr = iOS26TailwindClasses.buildStyleAttribute(styles)
        let attrs = ["id=\"\(id)\"", classAttr, styleAttr]
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        return "<div \(attrs)></div>\n"
    }

    // MARK: - Shape Rendering

    mutating func renderShape(_ node: ShapeNode) -> String {
        var classes: [String] = []
        let styles: [String] = []

        // Fill color
        if node.fillColor != .clear {
            classes.append(node.fillColor.tailwindBgClass)
        }

        // Sizing
        classes.append(contentsOf: iOS26TailwindClasses.sizing(
            width: node.width,
            height: node.height
        ))

        // Stroke (border)
        if let strokeColor = node.strokeColor, node.strokeWidth > 0 {
            classes.append("border-[\(formatPx(node.strokeWidth))]")
            classes.append(strokeColor.tailwindBorderClass)
        }

        // Shape-specific styling
        switch node.shapeType {
        case .rectangle:
            // No rounding
            break
        case .circle:
            classes.append("rounded-full")
        case .roundedRectangle(let radius):
            classes.append("rounded-[\(formatPx(radius))]")
        case .capsule:
            classes.append("rounded-full")
        case .ellipse:
            classes.append("rounded-full")
        @unknown default:
            break
        }

        let id = node.id ?? nextElementId()
        let classAttr = iOS26TailwindClasses.buildClassAttribute(classes)
        let styleAttr = iOS26TailwindClasses.buildStyleAttribute(styles)
        let attrs = ["id=\"\(id)\"", classAttr, styleAttr]
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        return "<div \(attrs)></div>\n"
    }

    // MARK: - Page Indicator Rendering

    mutating func renderPageIndicator(_ node: PageIndicatorNode) -> String {
        // Static rendering - show placeholder dots
        let pageCount = node.pageCountStatic ?? 3
        let currentPage = 0 // Default to first page in static HTML

        var dotsHTML = ""
        for i in 0..<pageCount {
            let isActive = i == currentPage
            let color = isActive ? node.currentDotColor : node.dotColor
            let size = node.dotSize

            let dotStyle = "width: \(formatPx(size)); height: \(formatPx(size)); background-color: \(color.ios26CssRGBA); border-radius: 50%;"
            dotsHTML += "<div style=\"\(dotStyle)\"></div>\n"
        }

        let spacing = node.dotSpacing
        let containerStyle = "display: flex; gap: \(formatPx(spacing)); align-items: center;"

        return "<div style=\"\(containerStyle)\">\n\(dotsHTML)</div>\n"
    }

    // MARK: - Section Layout Rendering

    mutating func renderSectionLayout(_ node: SectionLayoutNode) -> String {
        var html = ""

        for (index, section) in node.sections.enumerated() {
            // Add section spacing
            if index > 0 && node.sectionSpacing > 0 {
                html += "<div class=\"h-[\(formatPx(node.sectionSpacing))]\"></div>\n"
            }

            html += renderSection(section)
        }

        return html
    }

    mutating func renderSection(_ section: IR.Section) -> String {
        var html = ""
        var classes: [String] = []

        // Section styling based on layout type
        switch section.layoutType {
        case .list:
            classes.append("bg-white")
            classes.append("rounded-xl")
            classes.append("overflow-hidden")
            classes.append("divide-y")
            classes.append("divide-gray-200")

        case .horizontal:
            classes.append("flex")
            classes.append("overflow-x-auto")
            classes.append("gap-[\(formatPx(section.config.itemSpacing))]")

        case .grid(_):
            let columns = 2  // Default to 2 columns, could extract from columnConfig if needed
            classes.append("grid")
            classes.append("grid-cols-\(columns)")
            classes.append("gap-[\(formatPx(section.config.itemSpacing))]")

        case .flow:
            classes.append("flex")
            classes.append("flex-wrap")
            classes.append("gap-[\(formatPx(section.config.itemSpacing))]")
        @unknown default:
            break
        }

        let classAttr = iOS26TailwindClasses.buildClassAttribute(classes)

        // Render section container
        html += "<div \(classAttr)>\n"

        // Header
        if let header = section.header {
            html += "<div class=\"px-4 py-2 bg-gray-100 font-semibold text-sm text-gray-600\">\n"
            html += renderNode(header)
            html += "</div>\n"
        }

        // Children
        for child in section.children {
            switch section.layoutType {
            case .list:
                // Wrap in list item
                html += "<div class=\"px-4 py-3\">\n"
                html += renderNode(child)
                html += "</div>\n"
            default:
                html += renderNode(child)
            }
        }

        // Footer
        if let footer = section.footer {
            html += "<div class=\"px-4 py-2 bg-gray-100 text-xs text-gray-500\">\n"
            html += renderNode(footer)
            html += "</div>\n"
        }

        html += "</div>\n"

        return html
    }

    // MARK: - Helper Methods

    private func formatPx(_ value: CGFloat) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(value))px"
        }
        return String(format: "%.1fpx", value)
    }

    private func buildGradientCSS(_ node: GradientNode) -> String {
        // Build color stops
        let stops = node.colors.map { stop -> String in
            let color = resolveGradientColor(stop.color)
            let location = Int(stop.location * 100)
            return "\(color.ios26CssRGBA) \(location)%"
        }.joined(separator: ", ")

        // Build gradient based on type
        switch node.gradientType {
        case .linear:
            // Calculate angle from start/end points
            let angle = calculateLinearGradientAngle(
                start: node.startPoint,
                end: node.endPoint
            )
            return "linear-gradient(\(angle)deg, \(stops))"

        case .radial:
            return "radial-gradient(circle, \(stops))"
        }
    }

    private func resolveGradientColor(_ color: GradientColor) -> IR.Color {
        switch color {
        case .fixed(let color):
            return color
        case .adaptive(let light, _):
            // Use light color for static HTML
            return light
        }
    }

    private func calculateLinearGradientAngle(start: IR.UnitPoint, end: IR.UnitPoint) -> Int {
        // Convert unit points to angle in degrees
        let dx = end.x - start.x
        let dy = end.y - start.y
        let radians = atan2(dy, dx)
        let degrees = radians * 180 / .pi
        return Int(degrees + 90) // Adjust for CSS gradient coordinate system
    }
}
