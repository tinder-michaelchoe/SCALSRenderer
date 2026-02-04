//
//  SliderNode.swift
//  ScalsModules
//
//  Slider component node.
//

import Foundation
import SCALS

// MARK: - RenderNodeKind Extension

extension RenderNodeKind {
    /// Slider node
    public static let slider = RenderNodeKind(rawValue: "slider")
}

// MARK: - Slider Node

/// A slider component.
///
/// Sliders provide continuous value selection bound to state.
public struct SliderNode: RenderNodeData {
    public static let nodeKind = RenderNodeKind.slider

    public let id: String?
    public let styleId: String?

    /// State path to bind to (Double value)
    public let bindingPath: String?

    /// Minimum value
    public let minValue: Double

    /// Maximum value
    public let maxValue: Double

    // MARK: - Flattened Style Properties

    public let tintColor: IR.Color?
    public let padding: IR.EdgeInsets
    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?

    public init(
        id: String? = nil,
        styleId: String? = nil,
        bindingPath: String? = nil,
        minValue: Double = 0.0,
        maxValue: Double = 1.0,
        tintColor: IR.Color? = nil,
        padding: IR.EdgeInsets = .zero,
        width: IR.DimensionValue? = nil,
        height: IR.DimensionValue? = nil
    ) {
        self.id = id
        self.styleId = styleId
        self.bindingPath = bindingPath
        self.minValue = minValue
        self.maxValue = maxValue
        self.tintColor = tintColor
        self.padding = padding
        self.width = width
        self.height = height
    }
}
