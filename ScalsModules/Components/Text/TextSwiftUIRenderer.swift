//
//  TextSwiftUIRenderer.swift
//  ScalsModules
//
//  SwiftUI renderer and view for TextNode.
//

import SCALS
import SwiftUI

// MARK: - Text Node SwiftUI Renderer

public struct TextSwiftUIRenderer: SwiftUINodeRendering {
    public static let nodeKind = RenderNodeKind.text

    public init() {}

    @MainActor
    public func render(_ node: RenderNode, context: SwiftUIRenderContext) -> AnyView {
        guard let textNode = node.data(TextNode.self) else {
            return AnyView(EmptyView())
        }
        // Wrap the StateStore in ObservableStateStore for SwiftUI observation
        let observableStore = ObservableStateStore(wrapping: context.stateStore)
        return AnyView(
            TextNodeView(node: textNode, stateStore: observableStore)
        )
    }
}

// MARK: - Text Node View

struct TextNodeView: View {
    let node: TextNode
    @ObservedObject var stateStore: ObservableStateStore

    var body: some View {
        Text(displayContent)
            .applyTextStyle(from: node)
            // When width is specified, expand text to fill container with alignment
            // This must come BEFORE DimensionFrameModifier so the text fills the constrained width
            .frame(
                maxWidth: node.width != nil ? .infinity : nil,
                alignment: frameAlignment
            )
            .padding(.top, node.padding.top)
            .padding(.bottom, node.padding.bottom)
            .padding(.leading, node.padding.leading)
            .padding(.trailing, node.padding.trailing)
            .modifier(OptionalBackgroundModifier(color: node.backgroundColor))
            // Apply dimension constraints to control outer size
            .modifier(DimensionFrameModifier(
                width: node.width,
                height: node.height
            ))
    }

    /// Convert text alignment to frame alignment for single-line text positioning
    private var frameAlignment: SwiftUI.Alignment {
        switch node.textAlignment {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }

    /// Compute the content to display, reading from StateStore if dynamic
    private var displayContent: String {
        // If there's a binding path, read directly from state
        if let path = node.bindingPath {
            return stateStore.get(path) as? String ?? node.content
        }

        // If there's a template, interpolate with state
        if let template = node.bindingTemplate {
            return stateStore.interpolate(template)
        }

        // Otherwise, use static content
        return node.content
    }
}
