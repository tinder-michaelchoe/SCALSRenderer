//
//  LayoutNode.swift
//  ScalsRendererFramework
//

import Foundation

// MARK: - LayoutNode

extension Document {
    /// A node in the layout tree - can be either a layout container or a component
    public indirect enum LayoutNode: Codable {
        case layout(Layout)
        case sectionLayout(SectionLayout)
        case forEach(ForEach)
        case component(Component)
        case spacer(Spacer)

        enum CodingKeys: String, CodingKey {
            case type
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)

            switch type {
            case "vstack", "hstack", "zstack":
                self = .layout(try Layout(from: decoder))
            case "sectionLayout":
                self = .sectionLayout(try SectionLayout(from: decoder))
            case "forEach":
                self = .forEach(try ForEach(from: decoder))
            case "spacer":
                self = .spacer(try Spacer(from: decoder))
            default:
                // Assume it's a component
                self = .component(try Component(from: decoder))
            }
        }

        public func encode(to encoder: Encoder) throws {
            switch self {
            case .layout(let layout):
                try layout.encode(to: encoder)
            case .sectionLayout(let sectionLayout):
                try sectionLayout.encode(to: encoder)
            case .forEach(let forEach):
                try forEach.encode(to: encoder)
            case .component(let component):
                try component.encode(to: encoder)
            case .spacer(let spacer):
                try spacer.encode(to: encoder)
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode("spacer", forKey: .type)
            }
        }
    }
}

// MARK: - Layout Type

extension Document {
    /// Layout container types
    public enum LayoutType: String, Codable {
        case vstack
        case hstack
        case zstack
    }
}

// MARK: - Alignment Types

extension Document {
    /// Horizontal alignment options
    public enum HorizontalAlignment: String, Codable {
        case leading
        case center
        case trailing
    }

    /// Vertical alignment options
    public enum VerticalAlignment: String, Codable {
        case top
        case center
        case bottom
    }

    /// Alignment for ZStack
    public struct Alignment: Codable {
        public let horizontal: HorizontalAlignment?
        public let vertical: VerticalAlignment?

        public init(horizontal: HorizontalAlignment? = nil, vertical: VerticalAlignment? = nil) {
            self.horizontal = horizontal
            self.vertical = vertical
        }

        // Custom decoding to support both string shortcuts and object format
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            // Try to decode as a string shortcut first
            if let alignmentString = try? container.decode(String.self) {
                switch alignmentString {
                case "topLeading":
                    self.horizontal = .leading
                    self.vertical = .top
                case "top":
                    self.horizontal = .center
                    self.vertical = .top
                case "topTrailing":
                    self.horizontal = .trailing
                    self.vertical = .top
                case "leading":
                    self.horizontal = .leading
                    self.vertical = .center
                case "center":
                    self.horizontal = .center
                    self.vertical = .center
                case "trailing":
                    self.horizontal = .trailing
                    self.vertical = .center
                case "bottomLeading":
                    self.horizontal = .leading
                    self.vertical = .bottom
                case "bottom":
                    self.horizontal = .center
                    self.vertical = .bottom
                case "bottomTrailing":
                    self.horizontal = .trailing
                    self.vertical = .bottom
                default:
                    // Unknown string, default to center
                    self.horizontal = .center
                    self.vertical = .center
                }
            } else {
                // Try to decode as an object with horizontal/vertical
                let objectContainer = try decoder.container(keyedBy: CodingKeys.self)
                self.horizontal = try objectContainer.decodeIfPresent(HorizontalAlignment.self, forKey: .horizontal)
                self.vertical = try objectContainer.decodeIfPresent(VerticalAlignment.self, forKey: .vertical)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(horizontal, forKey: .horizontal)
            try container.encodeIfPresent(vertical, forKey: .vertical)
        }

        enum CodingKeys: String, CodingKey {
            case horizontal, vertical
        }
    }
}

// MARK: - Padding

extension Document {
    /// Padding specification
    public struct Padding: Codable, Sendable {
        public let top: CGFloat?
        public let bottom: CGFloat?
        public let leading: CGFloat?
        public let trailing: CGFloat?
        public let horizontal: CGFloat?
        public let vertical: CGFloat?
        public let all: CGFloat?

        public init(
            top: CGFloat? = nil,
            bottom: CGFloat? = nil,
            leading: CGFloat? = nil,
            trailing: CGFloat? = nil,
            horizontal: CGFloat? = nil,
            vertical: CGFloat? = nil,
            all: CGFloat? = nil
        ) {
            self.top = top
            self.bottom = bottom
            self.leading = leading
            self.trailing = trailing
            self.horizontal = horizontal
            self.vertical = vertical
            self.all = all
        }

        /// Resolves the padding values, preferring specific values over general ones
        /// Priority: specific (top/bottom/leading/trailing) > axis (vertical/horizontal) > all > 0
        public var resolvedTop: CGFloat { top ?? vertical ?? all ?? 0 }
        public var resolvedBottom: CGFloat { bottom ?? vertical ?? all ?? 0 }
        public var resolvedLeading: CGFloat { leading ?? horizontal ?? all ?? 0 }
        public var resolvedTrailing: CGFloat { trailing ?? horizontal ?? all ?? 0 }
    }
}

// MARK: - Local State Declaration

extension Document {
    /// Local state declaration for a component or layout
    public struct LocalStateDeclaration: Codable, Sendable {
        /// Initial values for local state
        public let initialValues: [String: StateValue]

        public init(initialValues: [String: StateValue] = [:]) {
            self.initialValues = initialValues
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            initialValues = try container.decode([String: StateValue].self)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(initialValues)
        }
    }
}

// MARK: - Layout

extension Document {
    /// Layout container that holds children
    public struct Layout: Codable {
        public let type: LayoutType
        public let alignment: Alignment?
        public let horizontalAlignment: HorizontalAlignment?
        public let verticalAlignment: VerticalAlignment?
        public let spacing: CGFloat?
        public let padding: Padding?
        public let children: [LayoutNode]

        /// Local state for this layout scope
        public let state: LocalStateDeclaration?

        /// Style reference (for named styles)
        public let styleId: String?

        /// Inline style overrides
        public let style: Style?

        enum CodingKeys: String, CodingKey {
            case type, alignment, spacing, padding, children, state, styleId, style
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            type = try container.decode(LayoutType.self, forKey: .type)
            spacing = try container.decodeIfPresent(CGFloat.self, forKey: .spacing)
            padding = try container.decodeIfPresent(Padding.self, forKey: .padding)
            children = try container.decodeIfPresent([LayoutNode].self, forKey: .children) ?? []
            state = try container.decodeIfPresent(LocalStateDeclaration.self, forKey: .state)
            styleId = try container.decodeIfPresent(String.self, forKey: .styleId)
            style = try container.decodeIfPresent(Style.self, forKey: .style)

            // Decode alignment based on layout type
            // This ensures we decode the correct alignment type for each layout
            switch type {
            case .vstack:
                // VStack uses horizontal alignment (leading, center, trailing)
                if let hAlign = try? container.decodeIfPresent(HorizontalAlignment.self, forKey: .alignment) {
                    horizontalAlignment = hAlign
                    alignment = nil
                    verticalAlignment = nil
                } else {
                    alignment = nil
                    horizontalAlignment = nil
                    verticalAlignment = nil
                }

            case .hstack:
                // HStack uses vertical alignment (top, center, bottom)
                if let vAlign = try? container.decodeIfPresent(VerticalAlignment.self, forKey: .alignment) {
                    verticalAlignment = vAlign
                    alignment = nil
                    horizontalAlignment = nil
                } else {
                    alignment = nil
                    horizontalAlignment = nil
                    verticalAlignment = nil
                }

            case .zstack:
                // ZStack uses 2D alignment (can be string shortcut or object)
                if let alignmentObj = try? container.decodeIfPresent(Alignment.self, forKey: .alignment) {
                    alignment = alignmentObj
                    horizontalAlignment = nil
                    verticalAlignment = nil
                } else {
                    alignment = nil
                    horizontalAlignment = nil
                    verticalAlignment = nil
                }
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            try container.encodeIfPresent(spacing, forKey: .spacing)
            try container.encodeIfPresent(padding, forKey: .padding)
            try container.encode(children, forKey: .children)
            try container.encodeIfPresent(state, forKey: .state)
            try container.encodeIfPresent(styleId, forKey: .styleId)
            try container.encodeIfPresent(style, forKey: .style)
            if let alignment = alignment {
                try container.encode(alignment, forKey: .alignment)
            } else if let horizontalAlignment = horizontalAlignment {
                try container.encode(horizontalAlignment, forKey: .alignment)
            } else if let verticalAlignment = verticalAlignment {
                try container.encode(verticalAlignment, forKey: .alignment)
            }
        }

        public init(
            type: LayoutType,
            alignment: Alignment? = nil,
            horizontalAlignment: HorizontalAlignment? = nil,
            verticalAlignment: VerticalAlignment? = nil,
            spacing: CGFloat? = nil,
            padding: Padding? = nil,
            children: [LayoutNode],
            state: LocalStateDeclaration? = nil,
            styleId: String? = nil,
            style: Style? = nil
        ) {
            self.type = type
            self.alignment = alignment
            self.horizontalAlignment = horizontalAlignment
            self.verticalAlignment = verticalAlignment
            self.spacing = spacing
            self.padding = padding
            self.children = children
            self.state = state
            self.styleId = styleId
            self.style = style
        }
    }
}

// MARK: - ForEach

extension Document {
    /// ForEach layout that iterates over an array and renders a template for each item
    ///
    /// Example JSON:
    /// ```json
    /// {
    ///   "type": "forEach",
    ///   "items": "interests",
    ///   "itemVariable": "item",
    ///   "indexVariable": "index",
    ///   "layout": "hstack",
    ///   "spacing": 8,
    ///   "template": {
    ///     "type": "button",
    ///     "text": "${item}",
    ///     "actions": { "onTap": "selectItem" }
    ///   },
    ///   "emptyView": {
    ///     "type": "label",
    ///     "text": "No items"
    ///   }
    /// }
    /// ```
    public struct ForEach: Codable {
        /// The type identifier (always "forEach")
        public let type: String

        /// State path to the array to iterate over
        public let items: String

        /// Variable name for the current item (default: "item")
        public let itemVariable: String

        /// Variable name for the current index (default: "index")
        public let indexVariable: String

        /// Layout type for arranging items: "vstack", "hstack", or "zstack" (default: "vstack")
        public let layout: LayoutType

        /// Spacing between items
        public let spacing: CGFloat?

        /// Alignment for the layout
        public let alignment: HorizontalAlignment?

        /// Padding around the forEach container
        public let padding: Padding?

        /// Template to render for each item
        public let template: LayoutNode

        /// Optional view to show when the array is empty
        public let emptyView: LayoutNode?

        enum CodingKeys: String, CodingKey {
            case type, items, itemVariable, indexVariable, layout, spacing, alignment, padding, template, emptyView
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            type = try container.decode(String.self, forKey: .type)
            items = try container.decode(String.self, forKey: .items)
            itemVariable = try container.decodeIfPresent(String.self, forKey: .itemVariable) ?? "item"
            indexVariable = try container.decodeIfPresent(String.self, forKey: .indexVariable) ?? "index"
            layout = try container.decodeIfPresent(LayoutType.self, forKey: .layout) ?? .vstack
            spacing = try container.decodeIfPresent(CGFloat.self, forKey: .spacing)
            alignment = try container.decodeIfPresent(HorizontalAlignment.self, forKey: .alignment)
            padding = try container.decodeIfPresent(Padding.self, forKey: .padding)
            template = try container.decode(LayoutNode.self, forKey: .template)
            emptyView = try container.decodeIfPresent(LayoutNode.self, forKey: .emptyView)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            try container.encode(items, forKey: .items)
            try container.encode(itemVariable, forKey: .itemVariable)
            try container.encode(indexVariable, forKey: .indexVariable)
            try container.encode(layout, forKey: .layout)
            try container.encodeIfPresent(spacing, forKey: .spacing)
            try container.encodeIfPresent(alignment, forKey: .alignment)
            try container.encodeIfPresent(padding, forKey: .padding)
            try container.encode(template, forKey: .template)
            try container.encodeIfPresent(emptyView, forKey: .emptyView)
        }

        public init(
            items: String,
            itemVariable: String = "item",
            indexVariable: String = "index",
            layout: LayoutType = .vstack,
            spacing: CGFloat? = nil,
            alignment: HorizontalAlignment? = nil,
            padding: Padding? = nil,
            template: LayoutNode,
            emptyView: LayoutNode? = nil
        ) {
            self.type = "forEach"
            self.items = items
            self.itemVariable = itemVariable
            self.indexVariable = indexVariable
            self.layout = layout
            self.spacing = spacing
            self.alignment = alignment
            self.padding = padding
            self.template = template
            self.emptyView = emptyView
        }
    }
}

// MARK: - Spacer

extension Document {
    /// Spacer component with optional sizing properties
    public struct Spacer: Codable {
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
}
