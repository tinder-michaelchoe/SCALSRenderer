//
//  SectionLayoutNode.swift
//  ScalsModules
//
//  Section-based layout container node.
//

import Foundation
import SCALS

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Section-based layout node
    public static let sectionLayout = RenderNodeKind(rawValue: "sectionLayout")
}

// MARK: - Section Layout Node

/// A section-based layout container for heterogeneous sections.
///
/// Used when content needs to be organized into distinct sections,
/// each with potentially different layout configurations.
public struct SectionLayoutNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.sectionLayout

    public let id: String?
    public var styleId: String? { nil }

    /// Spacing between sections
    public let sectionSpacing: CGFloat

    /// The sections to render
    public let sections: [IR.Section]

    public init(
        id: String? = nil,
        sectionSpacing: CGFloat = 0,
        sections: [IR.Section] = []
    ) {
        self.id = id
        self.sectionSpacing = sectionSpacing
        self.sections = sections
    }
}
