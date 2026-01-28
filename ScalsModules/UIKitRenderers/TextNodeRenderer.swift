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
        label.applyStyle(textNode.style)

        // Wrap in container to add natural text spacing to match SwiftUI
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        // Add top padding to match SwiftUI's natural text spacing (approximately 2-3pt)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }
}
