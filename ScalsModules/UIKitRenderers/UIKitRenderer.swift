//
//  UIKitRenderer.swift
//  ScalsRendererFramework
//
//  Renders a RenderTree into UIKit views.
//

import SCALS
import UIKit

// MARK: - UIKit Renderer

/// Renders a RenderTree into a UIKit view hierarchy.
///
/// Uses `UIKitNodeRendererRegistry` to delegate rendering to specialized node renderers.
public struct UIKitRenderer: Renderer {
    private let actionContext: ActionContext
    private let registry: UIKitNodeRendererRegistry

    public init(
        actionContext: ActionContext,
        registry: UIKitNodeRendererRegistry
    ) {
        self.actionContext = actionContext
        self.registry = registry
    }

    public func render(_ tree: RenderTree) -> UIView {
        RenderTreeUIView(
            tree: tree,
            actionContext: actionContext,
            registry: registry
        )
    }
}

// MARK: - Render Tree UIView

/// Root UIView that renders a RenderTree
final class RenderTreeUIView: UIView {
    private let tree: RenderTree
    private let context: UIKitRenderContext

    init(tree: RenderTree, actionContext: ActionContext, registry: UIKitNodeRendererRegistry) {
        self.tree = tree
        self.context = UIKitRenderContext(
            actionContext: actionContext,
            stateStore: tree.stateStore,
            colorScheme: tree.root.colorScheme,
            registry: registry
        )
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // Background color - convert IR.Color to UIColor (non-optional)
        backgroundColor = tree.root.backgroundColor.uiColor

        // Content container
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 0
        contentStack.alignment = .fill  // Changed from .leading to .fill so subviews expand to full width
        contentStack.distribution = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStack)

        // Apply edge insets with positioning-aware constraints
        let edgeInsets = tree.root.edgeInsets

        NSLayoutConstraint.activate([
            // Top constraint
            contentStack.topAnchor.constraint(
                equalTo: anchorGuide(for: edgeInsets?.top).topAnchor,
                constant: edgeInsets?.top?.value ?? 0
            ),
            // Bottom constraint - use <= to allow top alignment
            contentStack.bottomAnchor.constraint(
                lessThanOrEqualTo: anchorGuide(for: edgeInsets?.bottom).bottomAnchor,
                constant: -(edgeInsets?.bottom?.value ?? 0)
            ),
            // Leading constraint
            contentStack.leadingAnchor.constraint(
                equalTo: anchorGuide(for: edgeInsets?.leading).leadingAnchor,
                constant: edgeInsets?.leading?.value ?? 0
            ),
            // Trailing constraint
            contentStack.trailingAnchor.constraint(
                equalTo: anchorGuide(for: edgeInsets?.trailing).trailingAnchor,
                constant: -(edgeInsets?.trailing?.value ?? 0)
            )
        ])

        // Add children using the registry
        for child in tree.root.children {
            let childView = context.render(child)
            contentStack.addArrangedSubview(childView)
        }
    }

    /// Returns the appropriate layout guide based on the edge inset's positioning mode
    private func anchorGuide(for inset: IR.PositionedEdgeInset?) -> UILayoutGuide {
        switch inset?.positioning ?? .safeArea {
        case .safeArea:
            return safeAreaLayoutGuide
        case .absolute:
            return frameLayoutGuide
        }
    }

    /// A layout guide that represents the view's frame (ignoring safe area)
    private var frameLayoutGuide: UILayoutGuide {
        // Create a layout guide that matches the view's bounds
        if let existing = layoutGuides.first(where: { $0.identifier == "frameLayoutGuide" }) {
            return existing
        }
        let guide = UILayoutGuide()
        guide.identifier = "frameLayoutGuide"
        addLayoutGuide(guide)
        NSLayoutConstraint.activate([
            guide.topAnchor.constraint(equalTo: topAnchor),
            guide.bottomAnchor.constraint(equalTo: bottomAnchor),
            guide.leadingAnchor.constraint(equalTo: leadingAnchor),
            guide.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        return guide
    }
}

// MARK: - UIKit Style Extensions

public extension UILabel {
    /// Apply text style from a TextNode's flattened properties
    func applyStyle(from node: TextNode) {
        textColor = node.textColor.uiColor
        font = UIFont.systemFont(ofSize: node.fontSize, weight: node.fontWeight.uiKit)
        textAlignment = node.textAlignment.uiKit
    }
}

public extension UIButton {
    /// Apply style from a ButtonStateStyle's flattened properties
    func applyStyle(_ style: ButtonStateStyle) {
        setTitleColor(style.textColor.uiColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: style.fontSize, weight: style.fontWeight.uiKit)
        backgroundColor = style.backgroundColor.uiColor
        layer.cornerRadius = style.cornerRadius
        if style.cornerRadius > 0 {
            clipsToBounds = true
        }

        // Apply border
        if let border = style.border {
            layer.borderColor = border.color.uiColor.cgColor
            layer.borderWidth = border.width
        }

        // Apply shadow
        if let shadow = style.shadow {
            layer.shadowColor = shadow.color.uiColor.cgColor
            layer.shadowRadius = shadow.radius
            layer.shadowOffset = CGSize(width: shadow.x, height: shadow.y)
            layer.shadowOpacity = Float(shadow.color.alpha)
        }
    }
}

public extension UITextField {
    /// Apply style from a TextFieldNode's flattened properties
    func applyStyle(from node: TextFieldNode) {
        textColor = node.textColor.uiColor
        font = UIFont.systemFont(ofSize: node.fontSize)
        backgroundColor = node.backgroundColor.uiColor
        layer.cornerRadius = node.cornerRadius
        if node.cornerRadius > 0 {
            clipsToBounds = true
        }

        // Apply border
        if let border = node.border {
            layer.borderColor = border.color.uiColor.cgColor
            layer.borderWidth = border.width
        }
    }
}
