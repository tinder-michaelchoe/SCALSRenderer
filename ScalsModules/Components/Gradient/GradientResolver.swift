//
//  GradientResolver.swift
//  ScalsModules
//
//  Resolves gradient components.
//

import SCALS
import Foundation

/// Resolves `gradient` components into GradientNode
public struct GradientResolver: ComponentResolving {

    public static let componentKind: Document.ComponentKind = .gradient

    public init() {}

    @MainActor
    public func resolve(_ component: Document.Component, context: ResolutionContext) throws -> ComponentResolutionResult {
        // Resolve style to get flattened properties
        let resolvedStyle = context.styleResolver.resolve(component.styleId)
        let nodeId = component.id ?? UUID().uuidString
        let gradientNode = buildGradientNode(from: component, resolvedStyle: resolvedStyle)

        // Create view node if tracking
        let viewNode: ViewNode?
        if context.isTracking {
            viewNode = ViewNode(id: nodeId)
            viewNode?.parent = context.parentViewNode
        } else {
            viewNode = nil
        }

        // Initialize local state if declared
        if let viewNode = viewNode, let localState = component.state {
            initializeLocalState(on: viewNode, from: localState)
        }

        return ComponentResolutionResult(
            renderNode: RenderNode(gradientNode),
            viewNode: viewNode
        )
    }

    // MARK: - Private Helpers

    private func buildGradientNode(from component: Document.Component, resolvedStyle: ResolvedStyle) -> GradientNode {
        let colors = (component.gradientColors ?? []).map { (config: Document.GradientColorConfig) -> GradientColorStop in
            let color: GradientColor
            if let lightHex = config.lightColor, let darkHex = config.darkColor {
                color = .adaptive(light: IR.Color(hex: lightHex), dark: IR.Color(hex: darkHex))
            } else if let hex = config.color {
                color = .fixed(IR.Color(hex: hex))
            } else {
                color = .fixed(IR.Color(red: 0, green: 0, blue: 0, alpha: 0)) // clear
            }
            return GradientColorStop(color: color, location: config.location)
        }

        let startPoint = GradientPointConverter.convert(component.gradientStart)
        let endPoint = GradientPointConverter.convert(component.gradientEnd)

        // Resolve padding by merging node-level padding with style padding
        let padding = IR.EdgeInsets(
            from: component.padding,
            mergingTop: resolvedStyle.paddingTop ?? 0,
            mergingBottom: resolvedStyle.paddingBottom ?? 0,
            mergingLeading: resolvedStyle.paddingLeading ?? 0,
            mergingTrailing: resolvedStyle.paddingTrailing ?? 0
        )

        // Create GradientNode with flattened properties (no .style)
        return GradientNode(
            id: component.id,
            gradientType: .linear,
            colors: colors,
            startPoint: startPoint,
            endPoint: endPoint,
            cornerRadius: resolvedStyle.cornerRadius ?? 0,
            padding: padding,
            width: resolvedStyle.width,
            height: resolvedStyle.height
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
