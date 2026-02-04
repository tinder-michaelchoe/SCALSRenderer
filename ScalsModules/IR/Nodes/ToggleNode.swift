//
//  ToggleNode.swift
//  ScalsModules
//
//  Toggle/switch component node.
//

import Foundation
import SCALS

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Toggle node
    public static let toggle = RenderNodeKind(rawValue: "toggle")
}

// MARK: - Toggle Node

/// A toggle/switch component.
///
/// Toggles provide on/off state control bound to state.
public struct ToggleNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.toggle

    public let id: String?
    public let styleId: String?

    /// State path to bind to (Boolean value)
    public let bindingPath: String?

    // MARK: - Flattened Style Properties

    public let tintColor: IR.Color?
    public let padding: IR.EdgeInsets
    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?

    public init(
        id: String? = nil,
        styleId: String? = nil,
        bindingPath: String? = nil,
        tintColor: IR.Color? = nil,
        padding: IR.EdgeInsets = .zero,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.styleId = styleId
        self.bindingPath = bindingPath
        self.tintColor = tintColor
        self.padding = padding
        self.width = width
        self.height = height
    }
}
