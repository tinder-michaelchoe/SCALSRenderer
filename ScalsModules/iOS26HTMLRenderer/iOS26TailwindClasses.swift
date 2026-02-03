//
//  iOS26TailwindClasses.swift
//  ScalsRendererFramework
//
//  Helper utilities for generating Tailwind CSS classes from IR properties.
//

import Foundation
import SCALS

/// Utilities for building Tailwind CSS class strings
public enum iOS26TailwindClasses {

    // MARK: - Layout Classes

    /// Generate flex layout classes for ContainerNode
    public static func flexLayout(
        type: ContainerNode.LayoutType,
        spacing: CGFloat,
        alignment: IR.Alignment
    ) -> [String] {
        var classes: [String] = []

        switch type {
        case .vstack:
            classes.append("flex")
            classes.append("flex-col")
            if spacing > 0 {
                classes.append("gap-[\(formatPx(spacing))]")
            }
            classes.append(alignment.tailwindVerticalClass)

        case .hstack:
            classes.append("flex")
            classes.append("flex-row")
            if spacing > 0 {
                classes.append("gap-[\(formatPx(spacing))]")
            }
            classes.append(alignment.tailwindVerticalClass)

        case .zstack:
            classes.append("grid")
            classes.append("*:col-start-1")
            classes.append("*:row-start-1")
            classes.append(alignment.tailwindHorizontalClass)
            classes.append(alignment.tailwindVerticalClass)
        }

        return classes
    }

    // MARK: - Sizing Classes

    /// Generate sizing classes from dimension values
    public static func sizing(
        width: IR.DimensionValue?,
        height: IR.DimensionValue?,
        minWidth: IR.DimensionValue? = nil,
        minHeight: IR.DimensionValue? = nil,
        maxWidth: IR.DimensionValue? = nil,
        maxHeight: IR.DimensionValue? = nil
    ) -> [String] {
        var classes: [String] = []

        if let width = width {
            classes.append(width.tailwindWidthClass)
        }
        if let height = height {
            classes.append(height.tailwindHeightClass)
        }
        if let minWidth = minWidth {
            classes.append(minWidth.tailwindMinWidthClass)
        }
        if let minHeight = minHeight {
            classes.append(minHeight.tailwindMinHeightClass)
        }
        if let maxWidth = maxWidth {
            classes.append(maxWidth.tailwindMaxWidthClass)
        }
        if let maxHeight = maxHeight {
            classes.append(maxHeight.tailwindMaxHeightClass)
        }

        return classes
    }

    // MARK: - Style Classes

    /// Generate style classes (background, corner radius, border)
    public static func styling(
        backgroundColor: IR.Color?,
        cornerRadius: CGFloat,
        border: IR.Border?
    ) -> [String] {
        var classes: [String] = []

        // Background color (only apply if specified)
        if let backgroundColor = backgroundColor {
            classes.append(backgroundColor.tailwindBgClass)
        }

        // Corner radius
        if cornerRadius > 0 {
            classes.append("rounded-[\(formatPx(cornerRadius))]")
        }

        // Border
        if let border = border {
            classes.append(contentsOf: border.tailwindClasses)
        }

        return classes
    }

    // MARK: - Typography Classes

    /// Generate typography classes
    public static func typography(
        fontSize: CGFloat,
        fontWeight: IR.FontWeight,
        textColor: IR.Color,
        textAlignment: IR.TextAlignment
    ) -> [String] {
        var classes: [String] = []

        // Font size
        classes.append("text-[\(formatPx(fontSize))]")

        // Font weight
        classes.append(fontWeight.tailwindClass)

        // Text color
        if textColor != .clear {
            classes.append(textColor.tailwindTextClass)
        }

        // Text alignment
        classes.append(textAlignment.tailwindClass)

        return classes
    }

    // MARK: - Helper Methods

    /// Format CGFloat as px value for Tailwind arbitrary values
    private static func formatPx(_ value: CGFloat) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(value))px"
        }
        return String(format: "%.1fpx", value)
    }

    /// Build class attribute string from array of classes
    public static func buildClassAttribute(_ classes: [String]) -> String {
        let filtered = classes.filter { !$0.isEmpty }
        if filtered.isEmpty {
            return ""
        }
        return "class=\"\(filtered.joined(separator: " "))\""
    }

    /// Build style attribute string from inline style declarations
    public static func buildStyleAttribute(_ styles: [String]) -> String {
        let filtered = styles.filter { !$0.isEmpty }
        if filtered.isEmpty {
            return ""
        }
        return "style=\"\(filtered.joined(separator: "; "))\""
    }
}
