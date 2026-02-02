//
//  ContainerNodeView.swift
//  ScalsModules
//
//  SwiftUI renderer and view for ContainerNode.
//

import SCALS
import SwiftUI

// MARK: - Container Node SwiftUI Renderer

public struct ContainerNodeSwiftUIRenderer: SwiftUINodeRendering {
    public static let nodeKind = RenderNodeKind.container

    public init() {}

    @MainActor
    public func render(_ node: RenderNode, context: SwiftUIRenderContext) -> AnyView {
        guard case .container(let containerNode) = node else {
            return AnyView(EmptyView())
        }
        return AnyView(
            ContainerNodeView(node: containerNode, context: context)
                .environmentObject(context.observableStateStore)
                .environmentObject(context.observableActionContext)
        )
    }
}

// MARK: - Container Node View

struct ContainerNodeView: View {
    let node: ContainerNode
    let context: SwiftUIRenderContext

    var body: some View {
        Group {
            switch node.layoutType {
            case .vstack:
                VStack(alignment: horizontalAlignment, spacing: node.spacing) {
                    ForEach(Array(node.children.enumerated()), id: \.offset) { _, child in
                        renderChild(child)
                    }
                }
            case .hstack:
                HStack(alignment: verticalAlignment, spacing: node.spacing) {
                    ForEach(Array(node.children.enumerated()), id: \.offset) { _, child in
                        renderChild(child)
                    }
                }
            case .zstack:
                ZStack(alignment: zstackAlignment) {
                    ForEach(Array(node.children.enumerated()), id: \.offset) { _, child in
                        renderChild(child)
                    }
                }
            }
        }
        // Padding already resolved - use directly
        .padding(.top, node.padding.top)
        .padding(.bottom, node.padding.bottom)
        .padding(.leading, node.padding.leading)
        .padding(.trailing, node.padding.trailing)
        // Background and corner radius (non-optional in flattened IR)
        .background(node.backgroundColor.swiftUI)
        .cornerRadius(node.cornerRadius)
        // Border (optional)
        .overlay(
            Group {
                if let border = node.border {
                    RoundedRectangle(cornerRadius: node.cornerRadius)
                        .stroke(border.color.swiftUI, lineWidth: border.width)
                }
            }
        )
        // Shadow (optional - apply if present)
        .shadow(
            color: node.shadow?.color.swiftUI ?? .clear,
            radius: node.shadow?.radius ?? 0,
            x: node.shadow?.x ?? 0,
            y: node.shadow?.y ?? 0
        )
        .modifier(DimensionFrameModifier(
            width: node.width,
            height: node.height
        ))
    }

    @ViewBuilder
    private func renderChild(_ child: RenderNode) -> some View {
        context.render(child)
    }

    // Convert IR.HorizontalAlignment to SwiftUI.HorizontalAlignment
    private var horizontalAlignment: SwiftUI.HorizontalAlignment {
        node.alignment.horizontal.swiftUI
    }

    // Convert IR.VerticalAlignment to SwiftUI.VerticalAlignment
    private var verticalAlignment: SwiftUI.VerticalAlignment {
        node.alignment.vertical.swiftUI
    }

    // Convert IR.Alignment to SwiftUI.Alignment
    private var zstackAlignment: SwiftUI.Alignment {
        node.alignment.swiftUI
    }
}
