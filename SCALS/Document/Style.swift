//
//  Style.swift
//  ScalsRendererFramework
//

import Foundation

// MARK: - Style

extension Document {
    /// Style definition with optional single-parent inheritance
    public struct Style: Codable {
        // Inheritance - single parent style ID
        public let inherits: String?

        // Typography
        public let fontFamily: String?
        public let fontSize: CGFloat?
        public let fontWeight: FontWeight?
        public let textColor: String?
        public let textAlignment: TextAlignment?

        // Background & Border
        public let backgroundColor: String?
        public let cornerRadius: CGFloat?
        public let borderWidth: CGFloat?
        public let borderColor: String?

        // Shadow
        public let shadow: Shadow?

        // Image
        public let tintColor: String?

        // Sizing
        public let width: DimensionValue?
        public let height: DimensionValue?
        public let minWidth: DimensionValue?
        public let minHeight: DimensionValue?
        public let maxWidth: DimensionValue?
        public let maxHeight: DimensionValue?

        // Padding (internal)
        public let padding: Padding?

        public init(
            inherits: String? = nil,
            fontFamily: String? = nil,
            fontSize: CGFloat? = nil,
            fontWeight: FontWeight? = nil,
            textColor: String? = nil,
            textAlignment: TextAlignment? = nil,
            backgroundColor: String? = nil,
            cornerRadius: CGFloat? = nil,
            borderWidth: CGFloat? = nil,
            borderColor: String? = nil,
            shadow: Shadow? = nil,
            tintColor: String? = nil,
            width: DimensionValue? = nil,
            height: DimensionValue? = nil,
            minWidth: DimensionValue? = nil,
            minHeight: DimensionValue? = nil,
            maxWidth: DimensionValue? = nil,
            maxHeight: DimensionValue? = nil,
            padding: Padding? = nil
        ) {
            self.inherits = inherits
            self.fontFamily = fontFamily
            self.fontSize = fontSize
            self.fontWeight = fontWeight
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.borderColor = borderColor
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

// MARK: - Shadow

extension Document {
    public struct Shadow: Codable {
        public let color: String?
        public let radius: CGFloat?
        public let x: CGFloat?
        public let y: CGFloat?

        public init(
            color: String? = nil,
            radius: CGFloat? = nil,
            x: CGFloat? = nil,
            y: CGFloat? = nil
        ) {
            self.color = color
            self.radius = radius
            self.x = x
            self.y = y
        }
    }
}

// MARK: - Font Weight

extension Document {
    public enum FontWeight: String, Codable, Sendable {
        case ultraLight
        case thin
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
        case black
    }
}

// MARK: - Text Alignment

extension Document {
    public enum TextAlignment: String, Codable, Sendable {
        case leading
        case center
        case trailing
    }
}
