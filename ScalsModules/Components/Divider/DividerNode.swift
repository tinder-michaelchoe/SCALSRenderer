//
//  DividerNode.swift
//  ScalsModules
//
//  Divider/separator node for visual separation.
//

import Foundation
import SCALS

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Divider node
    public static let divider = RenderNodeKind(rawValue: "divider")
}

// MARK: - Divider Node

/// A divider/separator component.
///
/// Used to create visual separation between content areas.
public struct DividerNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.divider

    public let id: String?
    public var styleId: String? { nil }

    // MARK: - Flattened Style Properties

    /// Line color
    public let color: IR.Color

    /// Line thickness in points
    public let thickness: CGFloat

    /// Padding around the divider
    public let padding: IR.EdgeInsets

    public init(
        id: String? = nil,
        color: IR.Color = IR.Color(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0),
        thickness: CGFloat = 1,
        padding: IR.EdgeInsets = .zero
    ) {
        self.id = id
        self.color = color
        self.thickness = thickness
        self.padding = padding
    }
}
