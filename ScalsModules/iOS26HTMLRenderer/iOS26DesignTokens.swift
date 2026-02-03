//
//  iOS26DesignTokens.swift
//  ScalsRendererFramework
//
//  iOS 26 design tokens and HTML document template with Tailwind CSS.
//

import Foundation
import SCALS

/// iOS 26 design system tokens and HTML document generation
public enum iOS26DesignTokens {

    // MARK: - Color Palette

    /// iOS 26 system colors mapped to Tailwind-compatible values
    public enum SystemColors {
        /// Blue - Primary interactive color
        public static let blue = "rgb(0, 122, 255)"

        /// Green - Success, positive actions
        public static let green = "rgb(52, 199, 89)"

        /// Red - Destructive, errors
        public static let red = "rgb(255, 59, 48)"

        /// Orange - Warning
        public static let orange = "rgb(255, 149, 0)"

        /// Yellow - Attention
        public static let yellow = "rgb(255, 204, 0)"

        /// Gray - Neutral backgrounds
        public static let gray = "rgb(142, 142, 147)"

        /// System background colors
        public static let systemBackground = "rgb(242, 242, 247)"
        public static let secondarySystemBackground = "rgb(255, 255, 255)"
        public static let tertiarySystemBackground = "rgb(242, 242, 247)"

        /// Label colors
        public static let label = "rgb(0, 0, 0)"
        public static let secondaryLabel = "rgb(142, 142, 147)"
        public static let tertiaryLabel = "rgb(199, 199, 204)"
    }

    // MARK: - Typography

    /// iOS 26 typography scale (SF Pro)
    public enum Typography {
        /// Large title - 34pt
        public static let largeTitle: CGFloat = 34

        /// Title 1 - 28pt
        public static let title1: CGFloat = 28

        /// Title 2 - 22pt
        public static let title2: CGFloat = 22

        /// Title 3 - 20pt
        public static let title3: CGFloat = 20

        /// Headline - 17pt semibold
        public static let headline: CGFloat = 17

        /// Body - 17pt regular
        public static let body: CGFloat = 17

        /// Callout - 16pt
        public static let callout: CGFloat = 16

        /// Subheadline - 15pt
        public static let subheadline: CGFloat = 15

        /// Footnote - 13pt
        public static let footnote: CGFloat = 13

        /// Caption 1 - 12pt
        public static let caption1: CGFloat = 12

        /// Caption 2 - 11pt
        public static let caption2: CGFloat = 11
    }

    // MARK: - Spacing

    /// iOS 26 spacing scale
    public enum Spacing {
        /// Extra small - 4pt
        public static let xs: CGFloat = 4

        /// Small - 8pt
        public static let sm: CGFloat = 8

        /// Medium - 16pt
        public static let md: CGFloat = 16

        /// Large - 24pt
        public static let lg: CGFloat = 24

        /// Extra large - 32pt
        public static let xl: CGFloat = 32
    }

    // MARK: - Corner Radius

    /// iOS 26 corner radius values
    public enum CornerRadius {
        /// Small - 8pt (cards, buttons)
        public static let sm: CGFloat = 8

        /// Medium - 12pt (grouped lists)
        public static let md: CGFloat = 12

        /// Large - 16pt (sheets, modals)
        public static let lg: CGFloat = 16

        /// Extra large - 20pt
        public static let xl: CGFloat = 20
    }

    // MARK: - HTML Document Template

    /// Wraps HTML content in a complete iOS 26-styled document
    ///
    /// - Parameters:
    ///   - html: The body content HTML
    ///   - colorScheme: The color scheme (light/dark/system)
    ///   - backgroundColor: The background color
    /// - Returns: Complete HTML document string
    public static func wrapInDocument(
        html: String,
        colorScheme: IR.ColorScheme = .system,
        backgroundColor: IR.Color? = nil
    ) -> String {
        let darkClass = colorScheme == .dark ? "dark" : ""
        let bgColor = backgroundColor?.ios26CssRGBA ?? SystemColors.systemBackground

        return """
        <!DOCTYPE html>
        <html lang="en" class="\(darkClass)">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
            <meta name="apple-mobile-web-app-capable" content="yes">
            <meta name="apple-mobile-web-app-status-bar-style" content="default">
            <meta name="color-scheme" content="\(colorScheme.htmlValue)">
            <title>SCALS iOS 26</title>
            <script src="https://cdn.tailwindcss.com"></script>
            <style>
                /* iOS 26 Base Styles */
                * {
                    -webkit-tap-highlight-color: transparent;
                }

                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'SF Pro Text', system-ui, sans-serif;
                    -webkit-font-smoothing: antialiased;
                    -moz-osx-font-smoothing: grayscale;
                    background-color: \(bgColor);
                }

                /* iOS Toggle Switch */
                .ios-toggle-track {
                    transition: background-color 0.2s ease;
                }

                .ios-toggle-knob {
                    transition: transform 0.2s ease;
                }

                input:checked + .ios-toggle-track {
                    background-color: rgb(52, 199, 89);
                }

                input:checked + .ios-toggle-track .ios-toggle-knob {
                    transform: translateX(20px);
                }

                /* iOS Range Slider */
                input[type="range"] {
                    -webkit-appearance: none;
                    appearance: none;
                    height: 2px;
                    background: rgb(199, 199, 204);
                    border-radius: 1px;
                }

                input[type="range"]::-webkit-slider-thumb {
                    -webkit-appearance: none;
                    appearance: none;
                    width: 28px;
                    height: 28px;
                    border-radius: 50%;
                    background: white;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                    cursor: pointer;
                }

                input[type="range"]::-moz-range-thumb {
                    width: 28px;
                    height: 28px;
                    border-radius: 50%;
                    background: white;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                    cursor: pointer;
                    border: none;
                }

                /* iOS Button Active State */
                button:active {
                    opacity: 0.7;
                }

                /* Safe area insets */
                .safe-area-inset {
                    padding-top: env(safe-area-inset-top);
                    padding-bottom: env(safe-area-inset-bottom);
                    padding-left: env(safe-area-inset-left);
                    padding-right: env(safe-area-inset-right);
                }
            </style>
        </head>
        <body class="min-h-screen">
            <div id="ios26-root" class="safe-area-inset">
        \(html.indented(by: 8))
            </div>
        </body>
        </html>
        """
    }
}

// MARK: - Helper Extensions

extension IR.ColorScheme {
    /// HTML color-scheme meta tag value
    var htmlValue: String {
        switch self {
        case .light: return "light"
        case .dark: return "dark"
        case .system: return "light dark"
        @unknown default: return "light dark"
        }
    }
}

