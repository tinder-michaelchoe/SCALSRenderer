//
//  GradientNodeRenderer.swift
//  ScalsModules
//
//  Renders GradientNode to GradientView.
//

import SCALS
import SwiftUI
import UIKit

/// Renders gradient nodes to GradientView
public struct GradientNodeRenderer: UIKitNodeRendering {

    public static let nodeKind: RenderNodeKind = .gradient

    public init() {}

    public func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard case .gradient(let gradientNode) = node else {
            return UIView()
        }

        let gradientView = GradientView(
            node: gradientNode,
            colorScheme: context.colorScheme
        )
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        if let width = gradientNode.style.width {
            gradientView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = gradientNode.style.height {
            gradientView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        return gradientView
    }
}
