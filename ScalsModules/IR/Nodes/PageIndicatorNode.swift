//
//  PageIndicatorNode.swift
//  ScalsModules
//
//  Page indicator (pagination dots) component node.
//

import Foundation
import SCALS

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Page indicator node
    public static let pageIndicator = RenderNodeKind(rawValue: "pageIndicator")
}

// MARK: - Page Indicator Node

/// A page indicator component showing dots for pagination.
///
/// Used to indicate the current page in a paged interface.
public struct PageIndicatorNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.pageIndicator

    public let id: String?
    public var styleId: String? { nil }

    /// State path to read current page
    public let currentPagePath: String

    /// State path to read page count (optional)
    public let pageCountPath: String?

    /// Static page count (if not from state)
    public let pageCountStatic: Int?

    /// Dot diameter in points
    public let dotSize: CGFloat

    /// Space between dots
    public let dotSpacing: CGFloat

    /// Inactive dot color
    public let dotColor: IR.Color

    /// Active dot color
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
