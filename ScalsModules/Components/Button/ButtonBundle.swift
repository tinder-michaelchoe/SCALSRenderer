//
//  ButtonBundle.swift
//  ScalsModules
//
//  Bundle for the Button component.
//  Groups ButtonNode, ButtonResolver, and platform renderers.
//

import SCALS

/// Bundle for the Button component.
public enum ButtonBundle: ComponentBundle {
    public typealias Node = ButtonNode

    public static let componentKind = Document.ComponentKind.button
    public static let nodeKind = RenderNodeKind.button

    public static func makeResolver() -> any ComponentResolving {
        ButtonResolver()
    }

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        ButtonSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> any UIKitNodeRendering {
        ButtonUIKitRenderer()
    }
}
