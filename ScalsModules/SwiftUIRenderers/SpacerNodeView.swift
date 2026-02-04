//
//  SpacerNodeView.swift
//  ScalsModules
//
//  SwiftUI renderer for Spacer.
//

import SCALS
import SwiftUI

// MARK: - Spacer Node SwiftUI Renderer

public struct SpacerNodeSwiftUIRenderer: SwiftUINodeRendering {
    public static let nodeKind = RenderNodeKind.spacer

    public init() {}

    @MainActor
    public func render(_ node: RenderNode, context: SwiftUIRenderContext) -> AnyView {
        guard let spacerNode = node.data(SpacerNode.self) else {
            return AnyView(EmptyView())
        }

        // Create spacer with minLength if specified
        let spacer = Spacer(minLength: spacerNode.minLength ?? 0)

        // Apply fixed sizing if specified
        let sized = spacer
            .frame(width: spacerNode.width, height: spacerNode.height)

        return AnyView(sized)
    }
}
