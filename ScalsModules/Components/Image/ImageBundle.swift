//
//  ImageBundle.swift
//  ScalsModules
//
//  Bundle for the Image component.
//

import SCALS

/// Bundle for the Image component.
public enum ImageBundle: ComponentBundle {
    public typealias Node = ImageNode

    public static let componentKind = Document.ComponentKind.image
    public static let nodeKind = RenderNodeKind.image

    public static func makeResolver() -> any ComponentResolving {
        ImageResolver()
    }

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        ImageSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> any UIKitNodeRendering {
        ImageUIKitRenderer()
    }
}
