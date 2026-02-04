//
//  GradientBundle.swift
//  ScalsModules
//
//  Bundle for the Gradient component.
//

import SCALS

/// Bundle for the Gradient component.
public enum GradientBundle: ComponentBundle {
    public typealias Node = GradientNode

    public static let componentKind = Document.ComponentKind.gradient
    public static let nodeKind = RenderNodeKind.gradient

    public static func makeResolver() -> any ComponentResolving {
        GradientResolver()
    }

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        GradientSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> any UIKitNodeRendering {
        GradientUIKitRenderer()
    }
}
