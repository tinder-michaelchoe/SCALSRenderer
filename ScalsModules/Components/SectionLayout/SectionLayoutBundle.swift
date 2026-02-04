//
//  SectionLayoutBundle.swift
//  ScalsModules
//
//  Bundle for the SectionLayout node.
//

import SCALS

/// Bundle for the SectionLayout node.
/// SectionLayouts are resolved via SectionLayoutResolver, not ComponentResolving.
public enum SectionLayoutBundle: LayoutBundle {
    public typealias Node = SectionLayoutNode

    public static let nodeKind = RenderNodeKind.sectionLayout

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        SectionLayoutSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> (any UIKitNodeRendering)? {
        SectionLayoutUIKitRenderer()
    }
}
