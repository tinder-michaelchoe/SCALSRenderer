//
//  DividerNodeRenderer.swift
//  ScalsModules
//
//  Renders divider nodes to UIView.
//

import SCALS
import SwiftUI
import UIKit

/// Renders divider nodes to a UIView
public struct DividerNodeRenderer: UIKitNodeRendering {

    public static let nodeKind: RenderNodeKind = .divider

    public init() {}

    public func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard let dividerNode = node.data(DividerNode.self) else {
            return UIView()
        }

        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false

        // Set background color - directly on node
        divider.backgroundColor = dividerNode.color.toUIKit

        // Set height constraint - directly on node
        divider.heightAnchor.constraint(equalToConstant: dividerNode.thickness).isActive = true

        return divider
    }
}
