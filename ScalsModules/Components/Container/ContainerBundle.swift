//
//  ContainerBundle.swift
//  ScalsModules
//
//  Bundle for the Container layout node.
//

import SCALS

/// Bundle for the Container layout node.
/// Containers are resolved via LayoutResolver, not ComponentResolving.
public enum ContainerBundle: LayoutBundle {
    public typealias Node = ContainerNode

    public static let nodeKind = RenderNodeKind.container

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        ContainerSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> (any UIKitNodeRendering)? {
        ContainerUIKitRenderer()
    }
}
