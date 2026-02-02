//
//  TextNodeRenderer.swift
//  ScalsModules
//
//  Renders TextNode to UILabel.
//

import SCALS
import UIKit

/// Renders text nodes to UILabel
public struct TextNodeRenderer: UIKitNodeRendering {

    public static let nodeKind: RenderNodeKind = .text

    public init() {}

    public func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard case .text(let textNode) = node else {
            return UIView()
        }

        let label = UILabel()
        label.text = textNode.content
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.applyStyle(from: textNode)

        // If there's padding or background color, wrap in a container
        if textNode.padding != .zero || textNode.style.backgroundColor != nil {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)

            // Apply background color
            if let bgColor = textNode.style.backgroundColor {
                container.backgroundColor = bgColor.uiColor
            }

            // Apply padding constraints
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor, constant: textNode.padding.top),
                label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -textNode.padding.bottom),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: textNode.padding.leading),
                label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -textNode.padding.trailing)
            ])

            return container
        }

        return label
    }
}
