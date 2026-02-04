//
//  DividerNodeView.swift
//  ScalsModules
//
//  SwiftUI renderer for Divider.
//

import SCALS
import SwiftUI

// MARK: - Divider Node SwiftUI Renderer

public struct DividerNodeSwiftUIRenderer: SwiftUINodeRendering {
    public static let nodeKind = RenderNodeKind.divider

    public init() {}

    @MainActor
    public func render(_ node: RenderNode, context: SwiftUIRenderContext) -> AnyView {
        guard let dividerNode = node.data(DividerNode.self) else {
            return AnyView(EmptyView())
        }
        return AnyView(DividerNodeView(node: dividerNode))
    }
}

// MARK: - Divider Node View

struct DividerNodeView: View {
    let node: DividerNode

    var body: some View {
        Rectangle()
            .fill(node.color.swiftUI)
            .frame(height: node.thickness)
            .frame(maxWidth: .infinity)
    }
}
