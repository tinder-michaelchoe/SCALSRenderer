//
//  ToggleBundle.swift
//  ScalsModules
//
//  Bundle for the Toggle component.
//

import SCALS
import UIKit

/// Bundle for the Toggle component.
/// Note: Toggle does not have a UIKit renderer - returns a placeholder.
public enum ToggleBundle: ComponentBundle {
    public typealias Node = ToggleNode

    public static let componentKind = Document.ComponentKind.toggle
    public static let nodeKind = RenderNodeKind.toggle

    public static func makeResolver() -> any ComponentResolving {
        ToggleResolver()
    }

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        ToggleSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> any UIKitNodeRendering {
        TogglePlaceholderUIKitRenderer()
    }
}

/// Placeholder UIKit renderer for Toggle (not implemented).
struct TogglePlaceholderUIKitRenderer: UIKitNodeRendering {
    static let nodeKind = RenderNodeKind.toggle

    init() {}

    func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        // Toggle UIKit rendering not implemented
        return UIView()
    }
}
