//
//  SliderBundle.swift
//  ScalsModules
//
//  Bundle for the Slider component.
//

import SCALS
import UIKit

/// Bundle for the Slider component.
/// Note: Slider does not have a UIKit renderer - returns a placeholder.
public enum SliderBundle: ComponentBundle {
    public typealias Node = SliderNode

    public static let componentKind = Document.ComponentKind.slider
    public static let nodeKind = RenderNodeKind.slider

    public static func makeResolver() -> any ComponentResolving {
        SliderResolver()
    }

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        SliderSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> any UIKitNodeRendering {
        SliderPlaceholderUIKitRenderer()
    }
}

/// Placeholder UIKit renderer for Slider (not implemented).
struct SliderPlaceholderUIKitRenderer: UIKitNodeRendering {
    static let nodeKind = RenderNodeKind.slider

    init() {}

    func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        // Slider UIKit rendering not implemented
        return UIView()
    }
}
