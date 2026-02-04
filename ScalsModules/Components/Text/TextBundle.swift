//
//  TextBundle.swift
//  ScalsModules
//
//  Bundle for the Text component.
//

import SCALS

/// Bundle for the Text (label) component.
public enum TextBundle: ComponentBundle {
    public typealias Node = TextNode

    public static let componentKind = Document.ComponentKind.label
    public static let nodeKind = RenderNodeKind.text

    public static func makeResolver() -> any ComponentResolving {
        TextResolver()
    }

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        TextSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> any UIKitNodeRendering {
        TextUIKitRenderer()
    }
}
