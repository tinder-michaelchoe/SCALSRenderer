//
//  CustomComponentUIKitRenderer.swift
//  ScalsModules
//
//  UIKit renderer for custom components.
//  Wraps SwiftUI custom components in UIHostingController for UIKit integration.
//

import Foundation
import SCALS
import SwiftUI
import UIKit

/// UIKit renderer for custom components.
///
/// This renderer handles `CustomComponentRenderNode` by looking up the registered
/// `CustomComponent` implementation and wrapping its SwiftUI view in a UIHostingController.
public struct CustomComponentUIKitRenderer: UIKitNodeRendering {
    public static let nodeKind: RenderNodeKind = .customComponent

    private let customComponentRegistry: CustomComponentRegistry

    public init(customComponentRegistry: CustomComponentRegistry) {
        self.customComponentRegistry = customComponentRegistry
    }

    @MainActor
    public func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        // Extract the CustomComponentRenderNode
        guard let componentNode = node.data(CustomComponentRenderNode.self) else {
            return createErrorLabel("Invalid custom component node")
        }

        // Look up the registered CustomComponent type
        guard let componentType = customComponentRegistry.componentType(for: componentNode.typeName) else {
            return createErrorLabel("Unknown custom component: \(componentNode.typeName)")
        }

        // Create the context for the custom component
        let customContext = CustomComponentContext(
            resolvedStyle: componentNode.resolvedStyle,
            stateStore: context.stateStore,
            actionContext: context.actionContext,
            tree: context.tree,
            component: componentNode.component
        )

        // Call the static makeView method on the registered component type
        let swiftUIView = componentType.makeView(context: customContext)

        // Wrap the SwiftUI view in a hosting controller
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear

        // Return a wrapper view that manages the hosting controller's view
        let wrapperView = CustomComponentHostingView(hostingController: hostingController)
        return wrapperView
    }

    private func createErrorLabel(_ message: String) -> UILabel {
        let label = UILabel()
        label.text = message
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

/// Wrapper view that hosts a UIHostingController's view
private class CustomComponentHostingView: UIView {
    private let hostingController: UIHostingController<AnyView>

    init(hostingController: UIHostingController<AnyView>) {
        self.hostingController = hostingController
        super.init(frame: .zero)
        setupHostedView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHostedView() {
        let hostedView = hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        hostedView.backgroundColor = .clear
        addSubview(hostedView)

        NSLayoutConstraint.activate([
            hostedView.topAnchor.constraint(equalTo: topAnchor),
            hostedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hostedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    override var intrinsicContentSize: CGSize {
        return hostingController.view.intrinsicContentSize
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return hostingController.view.sizeThatFits(size)
    }
}
