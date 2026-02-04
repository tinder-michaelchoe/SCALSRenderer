//
//  DividerComponentResolver.swift
//  ScalsModules
//
//  Resolves divider components.
//

import SCALS
import Foundation

/// Resolves `divider` components into DividerNode
public struct DividerComponentResolver: ComponentResolving {

    public static let componentKind: Document.ComponentKind = .divider

    public init() {}

    @MainActor
    public func resolve(_ component: Document.Component, context: ResolutionContext) throws -> ComponentResolutionResult {
        // Resolve style to get flattened properties
        let resolvedStyle = context.styleResolver.resolve(component.styleId)

        // Resolve padding by merging node-level padding with style padding
        let padding = IR.EdgeInsets(
            from: component.padding,
            mergingTop: resolvedStyle.paddingTop ?? 0,
            mergingBottom: resolvedStyle.paddingBottom ?? 0,
            mergingLeading: resolvedStyle.paddingLeading ?? 0,
            mergingTrailing: resolvedStyle.paddingTrailing ?? 0
        )

        // Create DividerNode with flattened properties (no .style)
        let renderNode = RenderNode(DividerNode(
            id: component.id,
            color: resolvedStyle.backgroundColor ?? IR.Color(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0),
            thickness: resolvedStyle.height?.resolvedAbsolute ?? 1,
            padding: padding
        ))

        return ComponentResolutionResult(renderNode: renderNode, viewNode: nil)
    }
}
