//
//  StyleResolver.swift
//  CladsRendererFramework
//

import Foundation
import SwiftUI

/// Resolves styles with single-parent inheritance support and optional design system integration.
///
/// Style IDs can be:
/// - Local references (e.g., "primaryButton") - looked up in document's styles dictionary
/// - Design system references (e.g., "@button.primary") - delegated to DesignSystemProvider
///
/// Design system styles use the `@` prefix convention to distinguish them from local styles.
public struct StyleResolver {
    private let styles: [String: Document.Style]
    private let designSystemProvider: (any DesignSystemProvider)?

    public init(
        styles: [String: Document.Style]?,
        designSystemProvider: (any DesignSystemProvider)? = nil
    ) {
        self.styles = styles ?? [:]
        self.designSystemProvider = designSystemProvider
    }

    /// Resolve a style by ID, following the inheritance chain.
    ///
    /// For `@`-prefixed styleIds, delegates to the design system provider.
    /// For local styleIds, looks up in the document's styles dictionary.
    ///
    /// - Parameter styleId: Style identifier (may have `@` prefix for design system)
    /// - Returns: Resolved IR.Style
    public func resolve(_ styleId: String?) -> IR.Style {
        guard let styleId = styleId else {
            return IR.Style()
        }

        // Check for design system reference (@-prefixed)
        if styleId.hasPrefix("@") {
            let reference = String(styleId.dropFirst())
            if let dsStyle = designSystemProvider?.resolveStyle(reference) {
                return dsStyle
            }
            // Design system style not found, return empty style
            return IR.Style()
        }

        // Local document style
        guard let style = styles[styleId] else {
            return IR.Style()
        }
        return resolve(style: style, visited: [])
    }

    /// Resolve a style by ID with inline style overrides.
    ///
    /// Inline styles always take precedence over resolved styles.
    ///
    /// - Parameters:
    ///   - styleId: Style identifier (may have `@` prefix for design system)
    ///   - inline: Inline style overrides
    /// - Returns: Resolved IR.Style with inline overrides merged
    public func resolve(_ styleId: String?, inline: Document.Style?) -> IR.Style {
        var resolved = resolve(styleId)

        // Merge inline overrides (inline wins)
        if let inline = inline {
            resolved.merge(from: inline)
        }

        return resolved
    }

    private func resolve(style: Document.Style, visited: Set<String>) -> IR.Style {
        // Start with parent style if inheriting
        var resolved: IR.Style
        if let parentId = style.inherits,
           !visited.contains(parentId),
           let parentStyle = styles[parentId] {
            var newVisited = visited
            newVisited.insert(parentId)
            resolved = resolve(style: parentStyle, visited: newVisited)
        } else {
            resolved = IR.Style()
        }

        // Override with current style values
        resolved.merge(from: style)
        return resolved
    }
}

// MARK: - SwiftUI Conversions

extension Document.FontWeight {
    func toSwiftUI() -> Font.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        }
    }
}

extension Document.TextAlignment {
    func toSwiftUI() -> SwiftUI.TextAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
}

// MARK: - Color Extension

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
