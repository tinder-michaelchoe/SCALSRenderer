//
//  ShapeBundle.swift
//  ScalsModules
//
//  Bundle for the Shape component.
//

import SCALS

/// Bundle for the Shape component.
public enum ShapeBundle: ComponentBundle {
    public typealias Node = ShapeNode

    public static let componentKind = Document.ComponentKind.shape
    public static let nodeKind = RenderNodeKind.shape

    public static func makeResolver() -> any ComponentResolving {
        ShapeResolver()
    }

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        ShapeSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> any UIKitNodeRendering {
        ShapeUIKitRenderer()
    }
}
