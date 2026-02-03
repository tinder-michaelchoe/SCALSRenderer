//
//  TextNodeRenderer.swift
//  ScalsModules
//
//  Renders TextNode to UILabel.
//

import SCALS
import UIKit

// MARK: - Fractional Width Container

/// A container view that sets its width as a fraction of its superview's width.
/// This enables fractional sizing in UIKit similar to SwiftUI's containerRelativeFrame.
private class FractionalWidthContainer: UIView {
    private var widthFraction: CGFloat?
    private var widthConstraint: NSLayoutConstraint?

    func setWidthFraction(_ fraction: CGFloat) {
        widthFraction = fraction
        updateWidthConstraint()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateWidthConstraint()
    }

    private func updateWidthConstraint() {
        // Remove existing fractional constraint
        widthConstraint?.isActive = false
        widthConstraint = nil

        guard let fraction = widthFraction, let superview = superview else { return }

        // Create constraint relative to superview width
        let constraint = widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: fraction)
        constraint.isActive = true
        widthConstraint = constraint
    }
}

// MARK: - Text Node Renderer

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

        // Determine if we need a container
        let needsContainer = textNode.padding != .zero ||
                            textNode.backgroundColor != nil ||
                            textNode.width != nil ||
                            textNode.height != nil

        guard needsContainer else {
            return label
        }

        // Create appropriate container based on width type
        let container: UIView
        var hasFractionalWidth = false

        if case .fractional(let fraction) = textNode.width {
            let fractionalContainer = FractionalWidthContainer()
            fractionalContainer.setWidthFraction(fraction)
            container = fractionalContainer
            hasFractionalWidth = true
        } else {
            container = UIView()
        }

        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        // Apply background color if specified
        if let backgroundColor = textNode.backgroundColor {
            container.backgroundColor = backgroundColor.uiColor
        }

        // Apply padding constraints
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: textNode.padding.top),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -textNode.padding.bottom),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: textNode.padding.leading),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -textNode.padding.trailing)
        ])

        // Apply absolute width constraint if specified
        if case .absolute(let value) = textNode.width, !hasFractionalWidth {
            container.widthAnchor.constraint(equalToConstant: value).isActive = true
        }

        // Apply height constraint if specified
        if let height = textNode.height {
            switch height {
            case .absolute(let value):
                container.heightAnchor.constraint(equalToConstant: value).isActive = true
            case .fractional:
                // Fractional height would need similar treatment - not implemented yet
                break
            }
        }

        return container
    }
}
