//
//  ComponentBundle.swift
//  ScalsModules
//
//  Protocol that groups all artifacts for a component type.
//  Provides a single entry point that vends resolver and renderers.
//

import SCALS

/// Groups all artifacts for a component type.
/// Provides a single entry point that vends resolver and renderers.
///
/// Example:
/// ```swift
/// public enum ButtonBundle: ComponentBundle {
///     public typealias Node = ButtonNode
///
///     public static let componentKind = Document.ComponentKind(rawValue: "button")
///     public static let nodeKind = RenderNodeKind.button
///
///     public static func makeResolver() -> any ComponentResolving {
///         ButtonResolver()
///     }
///
///     public static func makeSwiftUIRenderer() -> any SwiftUINodeRendering {
///         ButtonSwiftUIRenderer()
///     }
///
///     public static func makeUIKitRenderer() -> any UIKitNodeRendering {
///         ButtonUIKitRenderer()
///     }
/// }
/// ```
public protocol ComponentBundle {
    associatedtype Node: RenderNodeData

    /// The Document.ComponentKind this bundle handles
    static var componentKind: Document.ComponentKind { get }

    /// The RenderNodeKind for the IR node
    static var nodeKind: RenderNodeKind { get }

    /// Creates the resolver (Document -> IR)
    static func makeResolver() -> any ComponentResolving

    /// Creates the SwiftUI renderer (IR -> SwiftUI)
    static func makeSwiftUIRenderer() -> any SwiftUINodeRendering

    /// Creates the UIKit renderer (IR -> UIKit)
    static func makeUIKitRenderer() -> any UIKitNodeRendering

    /// Renders to HTML (optional)
    static func renderHTML(_ node: RenderNode) -> String?
}

extension ComponentBundle {
    /// Default HTML implementation returns nil
    public static func renderHTML(_ node: RenderNode) -> String? { nil }
}

/// A bundle for layout nodes (Container, Spacer, SectionLayout).
/// These don't have component resolvers since they're resolved via LayoutResolving.
public protocol LayoutBundle {
    associatedtype Node: RenderNodeData

    /// The RenderNodeKind for the IR node
    static var nodeKind: RenderNodeKind { get }

    /// Creates the SwiftUI renderer (IR -> SwiftUI)
    static func makeSwiftUIRenderer() -> any SwiftUINodeRendering

    /// Creates the UIKit renderer (IR -> UIKit), if supported
    static func makeUIKitRenderer() -> (any UIKitNodeRendering)?

    /// Renders to HTML (optional)
    static func renderHTML(_ node: RenderNode) -> String?
}

extension LayoutBundle {
    /// Default HTML implementation returns nil
    public static func renderHTML(_ node: RenderNode) -> String? { nil }

    /// Default UIKit implementation returns nil (not all layouts support UIKit)
    public static func makeUIKitRenderer() -> (any UIKitNodeRendering)? { nil }
}
