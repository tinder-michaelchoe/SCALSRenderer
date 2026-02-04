//
//  DividerBundle.swift
//  ScalsModules
//
//  Bundle for the Divider component.
//

import SCALS

/// Bundle for the Divider component.
public enum DividerBundle: ComponentBundle {
    public typealias Node = DividerNode

    public static let componentKind = Document.ComponentKind.divider
    public static let nodeKind = RenderNodeKind.divider

    public static func makeResolver() -> any ComponentResolving {
        DividerResolver()
    }

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        DividerSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> any UIKitNodeRendering {
        DividerUIKitRenderer()
    }
}
