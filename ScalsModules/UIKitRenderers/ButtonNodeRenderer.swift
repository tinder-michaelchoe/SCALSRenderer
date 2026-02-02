//
//  ButtonNodeRenderer.swift
//  ScalsModules
//
//  Renders ButtonNode to UIButton.
//

import SCALS
import UIKit

/// Renders button nodes to ActionButton (UIButton subclass)
public struct ButtonNodeRenderer: UIKitNodeRendering {

    public static let nodeKind: RenderNodeKind = .button

    public init() {}

    public func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard case .button(let buttonNode) = node else {
            return UIView()
        }

        let button = ActionButton(
            actionBinding: buttonNode.onTap,
            actionContext: context.actionContext
        )
        button.translatesAutoresizingMaskIntoConstraints = false

        // Configure button with UIButton.Configuration (iOS 17+ minimum)
        var config = UIButton.Configuration.plain()

        // Apply attributed title with font styling
        let normalStyle = buttonNode.styles.normal
        let font = UIFont.systemFont(ofSize: normalStyle.fontSize, weight: normalStyle.fontWeight.uiKit)
        var attributes = AttributeContainer()
        attributes.font = font
        config.attributedTitle = AttributedString(buttonNode.label, attributes: attributes)

        // Apply text color from normal style
        config.baseForegroundColor = normalStyle.textColor.uiColor

        // Apply background color from normal style
        config.background.backgroundColor = normalStyle.backgroundColor.uiColor

        // Configure image if present
        if let imageSource = buttonNode.image {
            config.image = resolveUIImage(imageSource, context: context)
            config.imagePlacement = uiImagePlacement(buttonNode.imagePlacement)
            config.imagePadding = buttonNode.imageSpacing
        }

        // Apply corner radius to configuration background
        config.background.cornerRadius = normalStyle.cornerRadius

        button.configuration = config

        // Apply corner radius to layer as well
        button.layer.cornerRadius = normalStyle.cornerRadius
        button.clipsToBounds = true

        // Apply border from normal style
        if let border = normalStyle.border {
            button.layer.borderWidth = border.width
            button.layer.borderColor = border.color.uiColor.cgColor
        }

        // Apply button shape if specified (overrides style corner radius)
        applyButtonShape(button, node: buttonNode)

        if buttonNode.fillWidth {
            button.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        if let width = normalStyle.width {
            switch width {
            case .absolute(let value):
                button.widthAnchor.constraint(equalToConstant: value).isActive = true
            case .fractional(let fraction):
                if let superview = button.superview {
                    button.widthAnchor.constraint(
                        equalTo: superview.widthAnchor,
                        multiplier: fraction
                    ).isActive = true
                } else {
                    print("Warning: Cannot apply fractional width - view has no superview")
                }
            }
        }

        if let height = normalStyle.height {
            switch height {
            case .absolute(let value):
                button.heightAnchor.constraint(equalToConstant: value).isActive = true
            case .fractional(let fraction):
                if let superview = button.superview {
                    button.heightAnchor.constraint(
                        equalTo: superview.heightAnchor,
                        multiplier: fraction
                    ).isActive = true
                } else {
                    print("Warning: Cannot apply fractional height - view has no superview")
                }
            }
        }

        return button
    }

    private func applyButtonShape(_ button: UIButton, node: ButtonNode) {
        let normalStyle = node.styles.normal

        guard let shape = node.buttonShape else {
            // No shape specified, use style's cornerRadius
            let cornerRadius = normalStyle.cornerRadius
            if cornerRadius > 0 {
                button.layer.cornerRadius = cornerRadius
                button.clipsToBounds = true
            }
            return
        }

        // Calculate corner radius based on shape
        switch shape {
        case .circle:
            let width: CGFloat
            if case .absolute(let value) = normalStyle.width {
                width = value
            } else {
                width = 44
            }
            let height: CGFloat
            if case .absolute(let value) = normalStyle.height {
                height = value
            } else {
                height = 44
            }
            button.layer.cornerRadius = min(width, height) / 2

        case .capsule:
            let height: CGFloat
            if case .absolute(let value) = normalStyle.height {
                height = value
            } else {
                height = 44
            }
            button.layer.cornerRadius = height / 2

        case .roundedSquare:
            button.layer.cornerRadius = 10
        }

        button.clipsToBounds = true
    }

    private func uiImagePlacement(_ placement: ButtonNode.ImagePlacement) -> NSDirectionalRectEdge {
        switch placement {
        case .leading: return .leading
        case .trailing: return .trailing
        case .top: return .top
        case .bottom: return .bottom
        @unknown default: return .leading
        }
    }

    private func resolveUIImage(_ source: ImageNode.Source, context: UIKitRenderContext) -> UIImage? {
        switch source {
        case .sfsymbol(let name):
            return UIImage(systemName: name)
        case .asset(let name):
            return UIImage(named: name)
        case .url(_):
            // For URLs, we'd need async loading - return placeholder for now
            return UIImage(systemName: "photo")
        case .statePath(_):
            // For dynamic templates, we'd need to resolve from state - return placeholder for now
            return UIImage(systemName: "photo")

        case .activityIndicator:
            // Activity indicators can't be used as button images in UIKit
            // Return nil - button will be text-only
            return nil
        }
    }
}

// MARK: - Action Button

/// UIButton subclass that executes an action on tap
public final class ActionButton: UIButton {
    private let actionBinding: Document.Component.ActionBinding?
    private let actionContext: ActionContext

    public init(actionBinding: Document.Component.ActionBinding?, actionContext: ActionContext) {
        self.actionBinding = actionBinding
        self.actionContext = actionContext
        super.init(frame: .zero)
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func handleTap() {
        guard let binding = actionBinding else { return }
        Task { @MainActor in
            switch binding {
            case .reference(let actionId):
                await actionContext.executeAction(id: actionId)
            case .inline(let action):
                await actionContext.executeAction(action)
            }
        }
    }
}
