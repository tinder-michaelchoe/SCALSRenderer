//
//  SpacerNodeRenderer.swift
//  ScalsModules
//
//  Renders spacer nodes to flexible UIView.
//

import SCALS
import UIKit

/// Renders spacer nodes to a flexible UIView
public struct SpacerNodeRenderer: UIKitNodeRendering {

    public static let nodeKind: RenderNodeKind = .spacer

    public init() {}

    public func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard let spacerNode = node.data(SpacerNode.self) else {
            return UIView()
        }

        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        // Apply fixed width/height constraints
        if let width = spacerNode.width {
            spacer.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = spacerNode.height {
            spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        // Apply minimum size constraints if specified
        if let minLength = spacerNode.minLength {
            spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: minLength).isActive = true
            spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: minLength).isActive = true
        }

        return spacer
    }
}
