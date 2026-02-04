//
//  GradientUIKitRenderer.swift
//  ScalsModules
//
//  Renders GradientNode to GradientView.
//

import SCALS
import SwiftUI
import UIKit

/// Renders gradient nodes to GradientView
public struct GradientUIKitRenderer: UIKitNodeRendering {

    public static let nodeKind: RenderNodeKind = .gradient

    public init() {}

    public func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard let gradientNode = node.data(GradientNode.self) else {
            return UIView()
        }

        let gradientView = GradientView(
            node: gradientNode,
            colorScheme: context.colorScheme
        )
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        // Apply width constraint - directly on node
        if let width = gradientNode.width {
            switch width {
            case .absolute(let value):
                gradientView.widthAnchor.constraint(equalToConstant: value).isActive = true
            case .fractional(let fraction):
                if let superview = gradientView.superview {
                    gradientView.widthAnchor.constraint(
                        equalTo: superview.widthAnchor,
                        multiplier: fraction
                    ).isActive = true
                } else {
                    print("Warning: Cannot apply fractional width - view has no superview")
                }
            }
        }

        // Apply height constraint - directly on node
        if let height = gradientNode.height {
            switch height {
            case .absolute(let value):
                gradientView.heightAnchor.constraint(equalToConstant: value).isActive = true
            case .fractional(let fraction):
                if let superview = gradientView.superview {
                    gradientView.heightAnchor.constraint(
                        equalTo: superview.heightAnchor,
                        multiplier: fraction
                    ).isActive = true
                } else {
                    print("Warning: Cannot apply fractional height - view has no superview")
                }
            }
        }

        return gradientView
    }
}
