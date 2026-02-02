//
//  iOS26IRTypeConversions.swift
//  ScalsRendererFramework
//
//  Extensions for converting IR types to Tailwind CSS classes and inline CSS values.
//  These extensions follow the Golden Rule: no arithmetic, no nil coalescing - just type conversion.
//

import Foundation
import SCALS

// MARK: - IR.Color Extensions

extension IR.Color {
    /// Convert to CSS rgba() string for iOS 26 renderer
    var ios26CssRGBA: String {
        "rgba(\(Int(red * 255)), \(Int(green * 255)), \(Int(blue * 255)), \(alpha))"
    }

    /// Convert to Tailwind background color class
    var tailwindBgClass: String {
        if self == .clear {
            return "bg-transparent"
        }
        return "bg-[\(ios26CssRGBA)]"
    }

    /// Convert to Tailwind text color class
    var tailwindTextClass: String {
        if self == .clear {
            return ""
        }
        return "text-[\(ios26CssRGBA)]"
    }

    /// Convert to Tailwind border color class
    var tailwindBorderClass: String {
        "border-[\(ios26CssRGBA)]"
    }
}

// MARK: - IR.EdgeInsets Extensions

extension IR.EdgeInsets {
    /// Convert to array of Tailwind padding classes
    var tailwindPaddingClasses: [String] {
        var classes: [String] = []
        if top > 0 { classes.append("pt-[\(formatPx(top))]") }
        if leading > 0 { classes.append("pl-[\(formatPx(leading))]") }
        if bottom > 0 { classes.append("pb-[\(formatPx(bottom))]") }
        if trailing > 0 { classes.append("pr-[\(formatPx(trailing))]") }
        return classes
    }

    /// Convert to array of Tailwind margin classes
    var tailwindMarginClasses: [String] {
        var classes: [String] = []
        if top > 0 { classes.append("mt-[\(formatPx(top))]") }
        if leading > 0 { classes.append("ml-[\(formatPx(leading))]") }
        if bottom > 0 { classes.append("mb-[\(formatPx(bottom))]") }
        if trailing > 0 { classes.append("mr-[\(formatPx(trailing))]") }
        return classes
    }

    private func formatPx(_ value: CGFloat) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(value))px"
        }
        return "\(value)px"
    }
}

// MARK: - IR.Shadow Extensions

extension IR.Shadow {
    /// Convert to CSS box-shadow inline style value for iOS 26 renderer
    var ios26CssBoxShadow: String {
        "box-shadow: \(x)px \(y)px \(radius)px \(color.ios26CssRGBA)"
    }
}

// MARK: - IR.Border Extensions

extension IR.Border {
    /// Convert to array of Tailwind border classes
    var tailwindClasses: [String] {
        [
            "border-[\(formatPx(width))]",
            color.tailwindBorderClass
        ]
    }

    private func formatPx(_ value: CGFloat) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(value))px"
        }
        return "\(value)px"
    }
}

// MARK: - IR.Alignment Extensions

extension IR.Alignment {
    /// Convert horizontal alignment to Tailwind flex class
    var tailwindHorizontalClass: String {
        switch horizontal {
        case .leading: return "justify-start"
        case .center: return "justify-center"
        case .trailing: return "justify-end"
        }
    }

    /// Convert vertical alignment to Tailwind flex class
    var tailwindVerticalClass: String {
        switch vertical {
        case .top: return "items-start"
        case .center: return "items-center"
        case .bottom: return "items-end"
        }
    }
}

extension IR.HorizontalAlignment {
    /// Convert to Tailwind flex class
    var tailwindClass: String {
        switch self {
        case .leading: return "justify-start"
        case .center: return "justify-center"
        case .trailing: return "justify-end"
        }
    }
}

extension IR.VerticalAlignment {
    /// Convert to Tailwind flex class
    var tailwindClass: String {
        switch self {
        case .top: return "items-start"
        case .center: return "items-center"
        case .bottom: return "items-end"
        }
    }
}

// MARK: - IR.TextAlignment Extensions

extension IR.TextAlignment {
    /// Convert to Tailwind text alignment class
    var tailwindClass: String {
        switch self {
        case .leading: return "text-left"
        case .center: return "text-center"
        case .trailing: return "text-right"
        }
    }
}

// MARK: - IR.FontWeight Extensions

extension IR.FontWeight {
    /// Convert to Tailwind font weight class
    var tailwindClass: String {
        switch self {
        case .ultraLight: return "font-extralight"
        case .thin: return "font-thin"
        case .light: return "font-light"
        case .regular: return "font-normal"
        case .medium: return "font-medium"
        case .semibold: return "font-semibold"
        case .bold: return "font-bold"
        case .heavy: return "font-extrabold"
        case .black: return "font-black"
        }
    }
}

// MARK: - IR.DimensionValue Extensions

extension IR.DimensionValue {
    /// Convert to Tailwind width class
    var tailwindWidthClass: String {
        switch self {
        case .absolute(let value):
            return "w-[\(formatPx(value))]"
        case .fractional(let fraction):
            // Convert fraction to percentage
            let percentage = Int(fraction * 100)
            return "w-[\(percentage)%]"
        }
    }

    /// Convert to Tailwind height class
    var tailwindHeightClass: String {
        switch self {
        case .absolute(let value):
            return "h-[\(formatPx(value))]"
        case .fractional(let fraction):
            // Convert fraction to percentage
            let percentage = Int(fraction * 100)
            return "h-[\(percentage)%]"
        }
    }

    /// Convert to Tailwind min-width class
    var tailwindMinWidthClass: String {
        switch self {
        case .absolute(let value):
            return "min-w-[\(formatPx(value))]"
        case .fractional(let fraction):
            let percentage = Int(fraction * 100)
            return "min-w-[\(percentage)%]"
        }
    }

    /// Convert to Tailwind min-height class
    var tailwindMinHeightClass: String {
        switch self {
        case .absolute(let value):
            return "min-h-[\(formatPx(value))]"
        case .fractional(let fraction):
            let percentage = Int(fraction * 100)
            return "min-h-[\(percentage)%]"
        }
    }

    /// Convert to Tailwind max-width class
    var tailwindMaxWidthClass: String {
        switch self {
        case .absolute(let value):
            return "max-w-[\(formatPx(value))]"
        case .fractional(let fraction):
            let percentage = Int(fraction * 100)
            return "max-w-[\(percentage)%]"
        }
    }

    /// Convert to Tailwind max-height class
    var tailwindMaxHeightClass: String {
        switch self {
        case .absolute(let value):
            return "max-h-[\(formatPx(value))]"
        case .fractional(let fraction):
            let percentage = Int(fraction * 100)
            return "max-h-[\(percentage)%]"
        }
    }

    private func formatPx(_ value: CGFloat) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(value))px"
        }
        return "\(value)px"
    }
}
