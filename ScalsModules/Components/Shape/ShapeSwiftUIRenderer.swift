//
//  ShapeSwiftUIRenderer.swift
//  ScalsModules
//
//  SwiftUI renderer for ShapeNode.
//

import SCALS
import SwiftUI

// MARK: - Shape Node SwiftUI Renderer

public struct ShapeSwiftUIRenderer: SwiftUINodeRendering {
    public static let nodeKind = RenderNodeKind.shape

    public init() {}

    @MainActor
    public func render(_ node: RenderNode, context: SwiftUIRenderContext) -> AnyView {
        guard let shapeNode = node.data(ShapeNode.self) else {
            return AnyView(EmptyView())
        }
        return AnyView(
            ShapeNodeView(node: shapeNode, context: context)
                .environmentObject(context.observableStateStore)
                .environmentObject(context.observableActionContext)
        )
    }
}

// MARK: - Shape Node View

struct ShapeNodeView: View {
    let node: ShapeNode
    let context: SwiftUIRenderContext

    var body: some View {
        Group {
            switch node.shapeType {
            case .rectangle:
                Rectangle()
                    .fill(node.fillColor.swiftUI)
                    .overlay(
                        Rectangle()
                            .stroke(node.strokeColor?.swiftUI ?? Color.clear,
                                   lineWidth: node.strokeWidth)
                    )
            case .circle:
                Circle()
                    .fill(node.fillColor.swiftUI)
                    .overlay(
                        Circle()
                            .stroke(node.strokeColor?.swiftUI ?? Color.clear,
                                   lineWidth: node.strokeWidth)
                    )
            case .roundedRectangle(let cornerRadius):
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(node.fillColor.swiftUI)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(node.strokeColor?.swiftUI ?? Color.clear,
                                   lineWidth: node.strokeWidth)
                    )
            case .capsule:
                Capsule()
                    .fill(node.fillColor.swiftUI)
                    .overlay(
                        Capsule()
                            .stroke(node.strokeColor?.swiftUI ?? Color.clear,
                                   lineWidth: node.strokeWidth)
                    )
            case .ellipse:
                Ellipse()
                    .fill(node.fillColor.swiftUI)
                    .overlay(
                        Ellipse()
                            .stroke(node.strokeColor?.swiftUI ?? Color.clear,
                                   lineWidth: node.strokeWidth)
                    )
            }
        }
        .modifier(DimensionFrameModifier(
            width: node.width,
            height: node.height,
            minWidth: nil,
            minHeight: nil,
            maxWidth: node.width == nil ? .absolute(.infinity) : nil,
            maxHeight: node.height == nil ? .absolute(.infinity) : nil
        ))
        .padding(strokePadding)
    }

    // Add padding to prevent stroke from being clipped
    private var strokePadding: CGFloat {
        if node.strokeWidth > 0 {
            // Add padding equal to half the stroke width to prevent clipping
            return node.strokeWidth / 2
        }
        return 0
    }
}
