//
//  SliderComponentResolver.swift
//  ScalsModules
//
//  Resolves slider components.
//

import SCALS
import Foundation

/// Resolves `slider` components into SliderNode
public struct SliderComponentResolver: ComponentResolving {

    public static let componentKind: Document.ComponentKind = .slider

    public init() {}

    @MainActor
    public func resolve(_ component: Document.Component, context: ResolutionContext) throws -> ComponentResolutionResult {
        // Resolve style to get flattened properties
        let resolvedStyle = context.styleResolver.resolve(component.styleId)
        let nodeId = component.id ?? UUID().uuidString

        // Resolve binding path (global or local)
        let bindingPath = component.bind ?? component.localBind.map { "local.\($0)" }

        // Get min/max values with defaults
        let minValue = component.minValue ?? 0.0
        let maxValue = component.maxValue ?? 1.0

        // Create view node if tracking
        let viewNode: ViewNode?
        if context.isTracking {
            viewNode = ViewNode(
                id: nodeId,
                nodeType: .slider(SliderNodeData(
                    bindingPath: bindingPath,
                    minValue: minValue,
                    maxValue: maxValue
                ))
            )
            viewNode?.parent = context.parentViewNode

            // Track binding as both read and write
            context.tracker?.beginTracking(for: viewNode!)
            if let path = component.bind {
                context.tracker?.recordRead(path)
                context.tracker?.recordWrite(path)
            }
            if let localPath = component.localBind {
                context.tracker?.recordLocalRead(localPath)
                context.tracker?.recordLocalWrite(localPath)
            }
            context.tracker?.endTracking()
        } else {
            viewNode = nil
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

        // Create SliderNode with flattened properties (no .style)
        let renderNode = RenderNode.slider(SliderNode(
            id: component.id,
            styleId: component.styleId,
            bindingPath: component.bind,
            minValue: minValue,
            maxValue: maxValue,
            tintColor: resolvedStyle.tintColor,
            padding: padding,
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
