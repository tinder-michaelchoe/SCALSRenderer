//
//  SpacerBundle.swift
//  ScalsModules
//
//  Bundle for the Spacer layout node.
//

import SCALS

/// Bundle for the Spacer layout node.
/// Spacers are resolved via LayoutResolver, not ComponentResolving.
public enum SpacerBundle: LayoutBundle {
    public typealias Node = SpacerNode

    public static let nodeKind = RenderNodeKind.spacer

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        SpacerSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> (any UIKitNodeRendering)? {
        SpacerUIKitRenderer()
    }
}
