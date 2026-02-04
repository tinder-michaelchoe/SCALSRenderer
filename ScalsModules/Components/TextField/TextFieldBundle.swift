//
//  TextFieldBundle.swift
//  ScalsModules
//
//  Bundle for the TextField component.
//

import SCALS

/// Bundle for the TextField component.
public enum TextFieldBundle: ComponentBundle {
    public typealias Node = TextFieldNode

    public static let componentKind = Document.ComponentKind.textfield
    public static let nodeKind = RenderNodeKind.textField

    public static func makeResolver() -> any ComponentResolving {
        TextFieldResolver()
    }

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        TextFieldSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> any UIKitNodeRendering {
        TextFieldUIKitRenderer()
    }
}
