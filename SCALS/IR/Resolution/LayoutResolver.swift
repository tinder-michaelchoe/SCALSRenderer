//
//  LayoutResolver.swift
//  ScalsRendererFramework
//
//  Resolves layout containers (VStack, HStack, ZStack).
//
//  **Important**: This file should remain platform-agnostic. Do NOT import
//  SwiftUI or UIKit here. Platform-specific conversions belong in the
//  renderer layer (see `Renderers/SwiftUI/IRTypeConversions.swift`).
//

import Foundation

/// Resolves Layout nodes into ContainerNode
public struct LayoutResolver: LayoutResolving {

    private let componentRegistry: ComponentResolverRegistry

    public init(componentRegistry: ComponentResolverRegistry) {
        self.componentRegistry = componentRegistry
    }

    @MainActor
    public func resolve(_ layout: Document.Layout, context: ResolutionContext) throws -> NodeResolutionResult {
        let (layoutType, alignment) = resolveLayoutTypeAndAlignment(layout)

        // Resolve style FIRST to get individual style values for merging
        let resolvedStyle = context.styleResolver.resolve(layout.styleId, inline: layout.style)

        // Resolve padding by merging node-level padding with style padding
        let padding = IR.EdgeInsets(
            from: layout.padding,
            mergingTop: resolvedStyle.paddingTop ?? 0,
            mergingBottom: resolvedStyle.paddingBottom ?? 0,
            mergingLeading: resolvedStyle.paddingLeading ?? 0,
            mergingTrailing: resolvedStyle.paddingTrailing ?? 0
        )

        // Create view node if tracking
        let viewNode: ViewNode?
        if context.isTracking {
            viewNode = ViewNode(
                id: UUID().uuidString,
                nodeType: .container(ContainerNodeData(
                    layoutType: layoutType,
                    alignment: alignment,
                    spacing: layout.spacing ?? 0,
                    padding: padding
                ))
            )
            viewNode?.parent = context.parentViewNode

            // Initialize local state if declared
            if let localState = layout.state {
                initializeLocalState(on: viewNode!, from: localState)
            }
        } else {
            viewNode = nil
        }

        // Resolve children with updated context
        let childContext = viewNode.map { context.withParent($0) } ?? context
        let (renderChildren, viewChildren) = try resolveChildren(layout.children, context: childContext)

        // Attach view children
        if let viewNode = viewNode {
            viewNode.children = viewChildren
        }

        // Create ContainerNode with flattened properties (no .style)
        let containerNode = ContainerNode(
            id: nil,
            layoutType: layoutType,
            alignment: alignment,
            spacing: layout.spacing ?? 0,
            children: renderChildren,
            padding: padding,
            backgroundColor: resolvedStyle.backgroundColor,
            cornerRadius: resolvedStyle.cornerRadius ?? 0,
            shadow: IR.Shadow(from: resolvedStyle),
            border: IR.Border(from: resolvedStyle),
            width: resolvedStyle.width,
            height: resolvedStyle.height,
            minWidth: resolvedStyle.minWidth,
            minHeight: resolvedStyle.minHeight,
            maxWidth: resolvedStyle.maxWidth,
            maxHeight: resolvedStyle.maxHeight
        )

        return NodeResolutionResult(
            renderNode: RenderNode(containerNode),
            viewNode: viewNode
        )
    }

    // MARK: - Private Helpers

    private func resolveLayoutTypeAndAlignment(_ layout: Document.Layout) -> (ContainerNode.LayoutType, IR.Alignment) {
        switch layout.type {
        case .vstack:
            return (.vstack, IR.Alignment(forVStack: layout.horizontalAlignment))
        case .hstack:
            return (.hstack, IR.Alignment(forHStack: layout.alignment?.vertical))
        case .zstack:
            return (.zstack, IR.Alignment(forZStack: layout.alignment))
        }
    }

    @MainActor
    private func resolveChildren(
        _ children: [Document.LayoutNode],
        context: ResolutionContext
    ) throws -> ([RenderNode], [ViewNode]) {
        var renderChildren: [RenderNode] = []
        var viewChildren: [ViewNode] = []

        for child in children {
            let result = try resolveNode(child, context: context)
            renderChildren.append(result.renderNode)
            if let viewNode = result.viewNode {
                viewChildren.append(viewNode)
            }
        }

        return (renderChildren, viewChildren)
    }

    @MainActor
    public func resolveNode(_ node: Document.LayoutNode, context: ResolutionContext) throws -> NodeResolutionResult {
        switch node {
        case .layout(let layout):
            return try resolve(layout, context: context)

        case .sectionLayout(let sectionLayout):
            let sectionResolver = SectionLayoutResolver(componentRegistry: componentRegistry)
            return try sectionResolver.resolve(sectionLayout, context: context)

        case .forEach(let forEach):
            return try resolveForEach(forEach, context: context)

        case .component(let component):
            let result = try componentRegistry.resolve(component, context: context)
            return NodeResolutionResult(renderNode: result.renderNode, viewNode: result.viewNode)

        case .spacer(let spacer):
            let spacerNode = SpacerNode(
                minLength: spacer.minLength,
                width: spacer.width,
                height: spacer.height
            )

            let viewNode: ViewNode?
            if context.isTracking {
                viewNode = ViewNode(id: UUID().uuidString, nodeType: .spacer)
                viewNode?.parent = context.parentViewNode
            } else {
                viewNode = nil
            }

            return NodeResolutionResult(
                renderNode: RenderNode(spacerNode),
                viewNode: viewNode
            )
        }
    }

    // MARK: - ForEach Resolution

    @MainActor
    private func resolveForEach(_ forEach: Document.ForEach, context: ResolutionContext) throws -> NodeResolutionResult {
        // Get the array from state
        guard let array = context.stateStore.getArray(forEach.items) else {
            // Array not found or empty - show empty view if provided
            if let emptyView = forEach.emptyView {
                return try resolveNode(emptyView, context: context)
            }
            // Return empty container
            return createEmptyContainer(forEach: forEach, context: context)
        }

        // If array is empty, show empty view
        if array.isEmpty {
            if let emptyView = forEach.emptyView {
                return try resolveNode(emptyView, context: context)
            }
            return createEmptyContainer(forEach: forEach, context: context)
        }

        // Resolve layout type and alignment
        let (layoutType, alignment) = resolveForEachLayoutType(forEach)
        let padding = IR.EdgeInsets(from: forEach.padding)

        // Create view node for the container
        let containerViewNode: ViewNode?
        if context.isTracking {
            containerViewNode = ViewNode(
                id: "forEach_\(forEach.items)",
                nodeType: .container(ContainerNodeData(
                    layoutType: layoutType,
                    alignment: alignment,
                    spacing: forEach.spacing ?? 0,
                    padding: padding
                ))
            )
            containerViewNode?.parent = context.parentViewNode
        } else {
            containerViewNode = nil
        }

        // Resolve each item
        var renderChildren: [RenderNode] = []
        var viewChildren: [ViewNode] = []

        for (index, item) in array.enumerated() {
            // Create context with iteration variables
            let itemContext = context
                .withIterationVariables([
                    forEach.itemVariable: item,
                    forEach.indexVariable: index
                ])

            // Update parent if tracking
            let resolveContext = containerViewNode.map { itemContext.withParent($0) } ?? itemContext

            // Resolve the template
            let result = try resolveNode(forEach.template, context: resolveContext)
            renderChildren.append(result.renderNode)
            if let viewNode = result.viewNode {
                viewChildren.append(viewNode)
            }
        }

        // Attach view children
        if let containerViewNode = containerViewNode {
            containerViewNode.children = viewChildren
        }

        // Create ContainerNode with flattened properties (no .style)
        let containerNode = ContainerNode(
            id: "forEach_\(forEach.items)",
            layoutType: layoutType,
            alignment: alignment,
            spacing: forEach.spacing ?? 0,
            children: renderChildren,
            padding: padding
        )

        return NodeResolutionResult(
            renderNode: RenderNode(containerNode),
            viewNode: containerViewNode
        )
    }

    private func resolveForEachLayoutType(_ forEach: Document.ForEach) -> (ContainerNode.LayoutType, IR.Alignment) {
        switch forEach.layout {
        case .vstack:
            return (.vstack, IR.Alignment(forVStack: forEach.alignment))
        case .hstack:
            return (.hstack, .center)
        case .zstack:
            return (.zstack, .center)
        }
    }

    private func createEmptyContainer(forEach: Document.ForEach, context: ResolutionContext) -> NodeResolutionResult {
        let (layoutType, alignment) = resolveForEachLayoutType(forEach)
        let padding = IR.EdgeInsets(from: forEach.padding)

        let viewNode: ViewNode?
        if context.isTracking {
            viewNode = ViewNode(
                id: "forEach_\(forEach.items)_empty",
                nodeType: .container(ContainerNodeData(
                    layoutType: layoutType,
                    alignment: alignment,
                    spacing: forEach.spacing ?? 0,
                    padding: padding
                ))
            )
            viewNode?.parent = context.parentViewNode
        } else {
            viewNode = nil
        }

        // Create ContainerNode with flattened properties (no .style)
        let containerNode = ContainerNode(
            id: "forEach_\(forEach.items)_empty",
            layoutType: layoutType,
            alignment: alignment,
            spacing: forEach.spacing ?? 0,
            children: [],
            padding: padding
        )

        return NodeResolutionResult(
            renderNode: RenderNode(containerNode),
            viewNode: viewNode
        )
    }

    private func initializeLocalState(on viewNode: ViewNode, from localState: Document.LocalStateDeclaration) {
        var stateDict: [String: Any] = [:]
        for (key, value) in localState.initialValues {
            stateDict[key] = StateValueConverter.unwrap(value)
        }
        viewNode.localState = stateDict
    }
}
