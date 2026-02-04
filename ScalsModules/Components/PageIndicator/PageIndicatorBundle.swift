//
//  PageIndicatorBundle.swift
//  ScalsModules
//
//  Bundle for the PageIndicator component.
//

import SCALS

/// Bundle for the PageIndicator component.
public enum PageIndicatorBundle: ComponentBundle {
    public typealias Node = PageIndicatorNode

    public static let componentKind = Document.ComponentKind.pageIndicator
    public static let nodeKind = RenderNodeKind.pageIndicator

    public static func makeResolver() -> any ComponentResolving {
        PageIndicatorResolver()
    }

    public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
        PageIndicatorSwiftUIRenderer()
    }

    public static func makeUIKitRenderer() -> any UIKitNodeRendering {
        PageIndicatorUIKitRenderer()
    }
}
