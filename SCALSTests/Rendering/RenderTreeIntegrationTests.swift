//
//  RenderTreeIntegrationTests.swift
//  SCALSTests
//
//  Integration tests for full RenderTree to UIKit/SwiftUI view rendering pipeline.
//  Uses mock renderers to test the pipeline without depending on concrete implementations.
//

import Foundation
import Testing
import UIKit
import SwiftUI
@testable import SCALS
@testable import ScalsModules

// MARK: - Mock Renderers for Integration Tests

/// Mock text renderer for integration testing
private struct IntegrationTextRenderer: UIKitNodeRendering {
    static let nodeKind: RenderNodeKind = .text

    init() {}

    func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard let textNode = node.data(TextNode.self) else {
            return UIView()
        }
        let label = UILabel()
        label.text = textNode.content
        return label
    }
}

/// Mock button renderer for integration testing
private struct IntegrationButtonRenderer: UIKitNodeRendering {
    static let nodeKind: RenderNodeKind = .button

    init() {}

    func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard let buttonNode = node.data(ButtonNode.self) else {
            return UIView()
        }
        let button = UIButton()
        button.setTitle(buttonNode.label, for: .normal)
        return button
    }
}

/// Mock container renderer for integration testing
private struct IntegrationContainerRenderer: UIKitNodeRendering {
    static let nodeKind: RenderNodeKind = .container

    init() {}

    func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard let containerNode = node.data(ContainerNode.self) else {
            return UIView()
        }
        let stackView = UIStackView()
        stackView.axis = containerNode.layoutType == .vstack ? .vertical : .horizontal
        stackView.spacing = containerNode.spacing

        for child in containerNode.children {
            let childView = context.render(child)
            stackView.addArrangedSubview(childView)
        }

        return stackView
    }
}

/// Mock text field renderer for integration testing
private struct IntegrationTextFieldRenderer: UIKitNodeRendering {
    static let nodeKind: RenderNodeKind = .textField

    init() {}

    func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard let textFieldNode = node.data(TextFieldNode.self) else {
            return UIView()
        }
        let textField = UITextField()
        textField.placeholder = textFieldNode.placeholder
        return textField
    }
}

/// Mock image renderer for integration testing
private struct IntegrationImageRenderer: UIKitNodeRendering {
    static let nodeKind: RenderNodeKind = .image

    init() {}

    func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard let imageNode = node.data(ImageNode.self) else {
            return UIView()
        }
        let imageView = UIImageView()
        if case .sfsymbol(let name) = imageNode.source {
            imageView.image = UIImage(systemName: name)
        }
        return imageView
    }
}

/// Mock spacer renderer for integration testing
private struct IntegrationSpacerRenderer: UIKitNodeRendering {
    static let nodeKind: RenderNodeKind = .spacer
    
    init() {}
    
    func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }
}

/// Mock gradient renderer for integration testing
private struct IntegrationGradientRenderer: UIKitNodeRendering {
    static let nodeKind: RenderNodeKind = .gradient
    
    init() {}
    
    func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        return UIView()
    }
}

/// Mock section layout renderer for integration testing
private struct IntegrationSectionLayoutRenderer: UIKitNodeRendering {
    static let nodeKind: RenderNodeKind = .sectionLayout
    
    init() {}
    
    func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        let scrollView = UIScrollView()
        return scrollView
    }
}

// MARK: - Test Helpers

/// Creates a test ActionContext
@MainActor
func createIntegrationActionContext(stateStore: StateStore) -> ActionContext {
    let document = Document.Definition(
        id: "test",
        root: Document.RootComponent(children: [])
    )
    let actionResolver = ActionResolver(registry: ActionResolverRegistry.default)
    return ActionContext(
        stateStore: stateStore,
        actionDefinitions: [:],
        registry: ActionRegistry(),
        actionResolver: actionResolver,
        document: document
    )
}

/// Creates a fully configured UIKit render context with mock renderers
@MainActor
func createIntegrationUIKitContext() -> UIKitRenderContext {
    let registry = UIKitNodeRendererRegistry()
    registry.register(IntegrationTextRenderer())
    registry.register(IntegrationButtonRenderer())
    registry.register(IntegrationContainerRenderer())
    registry.register(IntegrationTextFieldRenderer())
    registry.register(IntegrationImageRenderer())
    registry.register(IntegrationSpacerRenderer())
    registry.register(IntegrationGradientRenderer())
    registry.register(IntegrationSectionLayoutRenderer())
    
    let stateStore = StateStore()
    let actionContext = createIntegrationActionContext(stateStore: stateStore)
    
    return UIKitRenderContext(
        actionContext: actionContext,
        stateStore: stateStore,
        colorScheme: .light,
        registry: registry
    )
}

/// Creates a fully configured SwiftUI render context
@MainActor
func createIntegrationSwiftUIContext(tree: RenderTree) -> SwiftUIRenderContext {
    let registry = SwiftUINodeRendererRegistry()
    
    let actionContext = createIntegrationActionContext(stateStore: tree.stateStore)
    
    return SwiftUIRenderContext(
        tree: tree,
        actionContext: actionContext,
        rendererRegistry: registry
    )
}

// MARK: - UIKit Integration Tests

struct UIKitRenderTreeIntegrationTests {
    
    @Test @MainActor func rendersSimpleTextNode() {
        let context = createIntegrationUIKitContext()

        let node = RenderNode(TextNode(content: "Hello Integration Test"))

        let view = context.render(node)

        #expect(view is UILabel)
        #expect((view as? UILabel)?.text == "Hello Integration Test")
    }

    @Test @MainActor func rendersNestedContainerStructure() {
        let context = createIntegrationUIKitContext()

        // Build a nested structure: VStack > HStack > [Text, Button]
        let node = RenderNode(ContainerNode(
            layoutType: .vstack,
            alignment: .center,
            spacing: 8,
            children: [
                RenderNode(ContainerNode(
                    layoutType: .hstack,
                    alignment: .center,
                    spacing: 4,
                    children: [
                        RenderNode(TextNode(content: "Label")),
                        RenderNode(ButtonNode(label: "Action", styles: ButtonStyles()))
                    ]
                ))
            ]
        ))

        let view = context.render(node)
        let stackView = view as? UIStackView

        #expect(stackView?.axis == .vertical)
        #expect(stackView?.arrangedSubviews.count == 1)

        let innerStack = stackView?.arrangedSubviews.first as? UIStackView
        #expect(innerStack?.axis == .horizontal)
        #expect(innerStack?.arrangedSubviews.count == 2)
    }

    @Test @MainActor func rendersFormStructure() {
        let context = createIntegrationUIKitContext()

        // Form-like structure: VStack > [TextField, Button]
        let node = RenderNode(ContainerNode(
            layoutType: .vstack,
            alignment: .leading,
            spacing: 16,
            children: [
                RenderNode(TextFieldNode(placeholder: "Enter name")),
                RenderNode(ButtonNode(
                    label: "Submit",
                    styles: ButtonStyles()
                ))
            ]
        ))

        let view = context.render(node)
        let stackView = view as? UIStackView

        #expect(stackView?.arrangedSubviews.count == 2)
        #expect(stackView?.arrangedSubviews[0] is UITextField)
        #expect(stackView?.arrangedSubviews[1] is UIButton)
    }

    @Test @MainActor func rendersContentWithSpacers() {
        let context = createIntegrationUIKitContext()

        // VStack with spacers: [Text, Spacer, Button]
        let node = RenderNode(ContainerNode(
            layoutType: .vstack,
            children: [
                RenderNode(TextNode(content: "Title")),
                RenderNode(SpacerNode()),
                RenderNode(ButtonNode(label: "Bottom Button", styles: ButtonStyles()))
            ]
        ))

        let view = context.render(node)
        let stackView = view as? UIStackView

        #expect(stackView?.arrangedSubviews.count == 3)

        // Middle view should be spacer (flexible UIView)
        let spacer = stackView?.arrangedSubviews[1]
        #expect(spacer?.contentHuggingPriority(for: NSLayoutConstraint.Axis.vertical) == UILayoutPriority.defaultLow)
    }
    
    @Test @MainActor func rendersImageNode() {
        let context = createIntegrationUIKitContext()

        let node = RenderNode(ImageNode(source: .sfsymbol(name: "star.fill")))

        let view = context.render(node)
        let imageView = view as? UIImageView

        #expect(imageView != nil)
        #expect(imageView?.image != nil)
    }

    @Test @MainActor func rendersGradientNode() {
        let context = createIntegrationUIKitContext()

        let node = RenderNode(GradientNode(
            colors: [
                GradientNode.ColorStop(color: .fixed(IR.Color.blue), location: 0),
                GradientNode.ColorStop(color: .fixed(IR.Color(red: 0.5, green: 0, blue: 0.5, alpha: 1)), location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        ))

        let view = context.render(node)

        // Verify view was created
        _ = view
    }

    @Test @MainActor func rendersSectionLayout() {
        let context = createIntegrationUIKitContext()

        let section = IR.Section(
            id: "section1",
            layoutType: .list,
            header: RenderNode(TextNode(content: "Header")),
            footer: nil,
            config: IR.SectionConfig(),
            children: [
                RenderNode(TextNode(content: "Item 1")),
                RenderNode(TextNode(content: "Item 2"))
            ]
        )

        let node = RenderNode(SectionLayoutNode(
            sectionSpacing: 16,
            sections: [section]
        ))

        let view = context.render(node)

        #expect(view is UIScrollView)
    }
}

// MARK: - SwiftUI Integration Tests

struct SwiftUIRenderTreeIntegrationTests {
    
    @Test @MainActor func createsSwiftUIRenderer() {
        let stateStore = StateStore()
        let registry = SwiftUINodeRendererRegistry()
        let actionContext = createIntegrationActionContext(stateStore: stateStore)
        
        let renderer = SwiftUIRenderer(
            actionContext: actionContext,
            rendererRegistry: registry
        )
        
        let tree = RenderTree(
            root: RootNode(children: []),
            stateStore: stateStore,
            actions: [:]
        )
        
        let view = renderer.render(tree)
        _ = view // Verify it renders without crashing
    }
    
    @Test @MainActor func rendersTreeWithBackgroundColor() {
        let stateStore = StateStore()
        let registry = SwiftUINodeRendererRegistry()
        let actionContext = createIntegrationActionContext(stateStore: stateStore)
        
        let renderer = SwiftUIRenderer(
            actionContext: actionContext,
            rendererRegistry: registry
        )
        
        let tree = RenderTree(
            root: RootNode(
                backgroundColor: .blue,
                children: []
            ),
            stateStore: stateStore,
            actions: [:]
        )
        
        let view = renderer.render(tree)
        _ = view
    }
    
    @Test @MainActor func rendersTreeWithColorScheme() {
        let stateStore = StateStore()
        let registry = SwiftUINodeRendererRegistry()
        let actionContext = createIntegrationActionContext(stateStore: stateStore)
        
        let renderer = SwiftUIRenderer(
            actionContext: actionContext,
            rendererRegistry: registry
        )
        
        let lightTree = RenderTree(
            root: RootNode(colorScheme: .light, children: []),
            stateStore: stateStore,
            actions: [:]
        )
        
        let darkTree = RenderTree(
            root: RootNode(colorScheme: .dark, children: []),
            stateStore: stateStore,
            actions: [:]
        )
        
        _ = renderer.render(lightTree)
        _ = renderer.render(darkTree)
    }
    
    @Test @MainActor func rendersTreeWithMultipleChildren() {
        let stateStore = StateStore()
        let registry = SwiftUINodeRendererRegistry()
        let actionContext = createIntegrationActionContext(stateStore: stateStore)
        
        let renderer = SwiftUIRenderer(
            actionContext: actionContext,
            rendererRegistry: registry
        )
        
        let tree = RenderTree(
            root: RootNode(children: [
                RenderNode(TextNode(content: "First")),
                RenderNode(TextNode(content: "Second")),
                RenderNode(TextNode(content: "Third"))
            ]),
            stateStore: stateStore,
            actions: [:]
        )
        
        let view = renderer.render(tree)
        _ = view
    }
}

// MARK: - Full Pipeline Integration Tests

@Suite(.disabled("Investigating test hang"))
struct FullPipelineIntegrationTests {
    
    @Test @MainActor func resolvesDocumentAndRendersToUIKit() throws {
        // Create a simple document
        let document = Document.Definition(
            id: "test",
            root: Document.RootComponent(children: [
                .layout(Document.Layout(
                    type: .vstack,
                    spacing: 8,
                    children: [
                        .component(Document.Component(
                            type: Document.ComponentKind(rawValue: "label"),
                            text: "Hello World"
                        ))
                    ]
                ))
            ])
        )
        
        // Resolve to RenderTree
        let componentRegistry = ComponentResolverRegistry()
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            actionResolverRegistry: ActionResolverRegistry.default
        )
        let renderTree = try resolver.resolve()
        
        // Verify tree structure
        #expect(renderTree.root.children.count == 1)
        
        // Create UIKit renderer with mock renderers
        let uikitRegistry = UIKitNodeRendererRegistry()
        uikitRegistry.register(IntegrationTextRenderer())
        uikitRegistry.register(IntegrationContainerRenderer())
        
        let actionContext = createIntegrationActionContext(stateStore: renderTree.stateStore)
        
        let context = UIKitRenderContext(
            actionContext: actionContext,
            stateStore: renderTree.stateStore,
            colorScheme: IR.ColorScheme.light,
            registry: uikitRegistry
        )
        
        // Render root children
        for child in renderTree.root.children {
            let view = context.render(child)
            // Verify view is created (view is always UIView or a subclass)
            #expect(view is UIStackView || view is UILabel)
        }
    }
    
    @Test @MainActor func resolvesDocumentAndRendersToSwiftUI() throws {
        // Create a simple document
        let document = Document.Definition(
            id: "test",
            root: Document.RootComponent(children: [
                .component(Document.Component(
                    type: Document.ComponentKind(rawValue: "label"),
                    text: "SwiftUI Test"
                ))
            ])
        )
        
        // Resolve to RenderTree
        let componentRegistry = ComponentResolverRegistry()
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            actionResolverRegistry: ActionResolverRegistry.default
        )
        let renderTree = try resolver.resolve()
        
        // Create SwiftUI renderer
        let registry = SwiftUINodeRendererRegistry()
        let actionContext = createIntegrationActionContext(stateStore: renderTree.stateStore)
        
        let renderer = SwiftUIRenderer(
            actionContext: actionContext,
            rendererRegistry: registry
        )
        
        // Render the tree
        let view = renderer.render(renderTree)
        _ = view // Verify no crash
    }
}

// MARK: - Edge Case Tests

@Suite(.disabled("Investigating test hang"))
struct RenderTreeEdgeCaseTests {
    
    @Test @MainActor func rendersEmptyContainer() {
        let context = createIntegrationUIKitContext()

        let node = RenderNode(ContainerNode(
            layoutType: .vstack,
            children: []
        ))

        let view = context.render(node)
        let stackView = view as? UIStackView

        #expect(stackView?.arrangedSubviews.isEmpty == true)
    }

    @Test @MainActor func rendersDeeplyNestedStructure() {
        let context = createIntegrationUIKitContext()

        // Create deeply nested structure (5 levels)
        func createNestedContainer(depth: Int) -> RenderNode {
            if depth == 0 {
                return RenderNode(TextNode(content: "Leaf"))
            }
            return RenderNode(ContainerNode(
                layoutType: .vstack,
                children: [createNestedContainer(depth: depth - 1)]
            ))
        }

        let node = createNestedContainer(depth: 5)
        let view = context.render(node)

        #expect(view is UIStackView)

        // Traverse to find the leaf
        var current: UIView? = view
        for _ in 0..<5 {
            current = (current as? UIStackView)?.arrangedSubviews.first
        }

        #expect(current is UILabel)
    }

    @Test @MainActor func rendersContainerWithMixedChildren() {
        let context = createIntegrationUIKitContext()

        let node = RenderNode(ContainerNode(
            layoutType: .vstack,
            children: [
                RenderNode(TextNode(content: "Text")),
                RenderNode(ButtonNode(label: "Button", styles: ButtonStyles())),
                RenderNode(ImageNode(source: .sfsymbol(name: "star"))),
                RenderNode(SpacerNode()),
                RenderNode(TextFieldNode(placeholder: "Input"))
            ]
        ))

        let view = context.render(node)
        let stackView = view as? UIStackView

        #expect(stackView?.arrangedSubviews.count == 5)
        let views = stackView?.arrangedSubviews ?? []
        #expect(views[0] is UILabel)
        #expect(views[1] is UIButton)
        #expect(views[2] is UIImageView)
        #expect(views[4] is UITextField)
    }
}
