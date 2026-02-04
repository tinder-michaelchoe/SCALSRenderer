//
//  TextComponentResolver.swift
//  ScalsModules
//
//  Resolves label/text components.
//

import SCALS
import Foundation

/// Resolves `label` components into TextNode
public struct TextComponentResolver: ComponentResolving {

    public static let componentKind: Document.ComponentKind = .label

    public init() {}

    @MainActor
    public func resolve(_ component: Document.Component, context: ResolutionContext) throws -> ComponentResolutionResult {
        // Resolve style to get flattened properties
        let resolvedStyle = context.styleResolver.resolve(component.styleId)
        let nodeId = component.id ?? UUID().uuidString

        // Create view node if tracking
        let viewNode: ViewNode?
        if context.isTracking {
            viewNode = ViewNode(
                id: nodeId,
                nodeType: .text(TextNodeData(content: ""))
            )
            viewNode?.parent = context.parentViewNode

            // Track dependencies during content resolution
            context.tracker?.beginTracking(for: viewNode!)
        } else {
            viewNode = nil
        }

        // Resolve content (may record dependencies)
        let contentResult = ContentResolver.resolve(component, context: context, viewNode: viewNode)

        if context.isTracking {
            context.tracker?.endTracking()
        }

        // Initialize local state if declared
        if let viewNode = viewNode, let localState = component.state {
            initializeLocalState(on: viewNode, from: localState)
        }

        // Resolve padding by merging node-level padding with style padding
        let padding = IR.EdgeInsets(
            from: component.padding,
            mergingTop: resolvedStyle.paddingTop ?? 0,
            mergingBottom: resolvedStyle.paddingBottom ?? 0,
            mergingLeading: resolvedStyle.paddingLeading ?? 0,
            mergingTrailing: resolvedStyle.paddingTrailing ?? 0
        )

        // Create TextNode with flattened properties (no .style)
        let renderNode = RenderNode(TextNode(
            id: component.id,
            content: contentResult.content,
            styleId: component.styleId,
            bindingPath: contentResult.bindingPath,
            bindingTemplate: contentResult.bindingTemplate,
            padding: padding,
            textColor: resolvedStyle.textColor ?? .black,
            fontSize: resolvedStyle.fontSize ?? 17,
            fontWeight: resolvedStyle.fontWeight ?? .regular,
            textAlignment: resolvedStyle.textAlignment ?? .leading,
            backgroundColor: resolvedStyle.backgroundColor,
            cornerRadius: resolvedStyle.cornerRadius ?? 0,
            shadow: IR.Shadow(from: resolvedStyle),
            border: IR.Border(from: resolvedStyle),
            width: resolvedStyle.width,
            height: resolvedStyle.height
        ))

        return ComponentResolutionResult(renderNode: renderNode, viewNode: viewNode)
    }

    private func initializeLocalState(on viewNode: ViewNode, from localState: Document.LocalStateDeclaration) {
        var stateDict: [String: Any] = [:]
        for (key, value) in localState.initialValues {
            stateDict[key] = StateValueConverter.unwrap(value)
        }
        viewNode.localState = stateDict
    }
}
