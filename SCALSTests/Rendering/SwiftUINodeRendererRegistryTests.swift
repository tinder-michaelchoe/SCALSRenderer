//
//  SwiftUINodeRendererRegistryTests.swift
//  SCALSTests
//
//  Unit tests for SwiftUINodeRendererRegistry - registration and resolution of SwiftUI node renderers.
//

import Foundation
import Testing
import SwiftUI
@testable import SCALS
@testable import ScalsModules

// MARK: - Test Mock SwiftUI Renderers

/// Mock SwiftUI renderer for testing text node rendering
struct MockSwiftUITextRenderer: SwiftUINodeRendering {
    static let nodeKind: RenderNodeKind = RenderNodeKind.text

    @MainActor
    func render(_ node: RenderNode, context: SwiftUIRenderContext) -> AnyView {
        AnyView(Text("MockText").accessibilityIdentifier("mock_swiftui_text"))
    }
}

/// Mock SwiftUI renderer for testing button node rendering
struct MockSwiftUIButtonRenderer: SwiftUINodeRendering {
    static let nodeKind: RenderNodeKind = RenderNodeKind.button

    @MainActor
    func render(_ node: RenderNode, context: SwiftUIRenderContext) -> AnyView {
        AnyView(Button("MockButton") {}.accessibilityIdentifier("mock_swiftui_button"))
    }
}

/// Mock SwiftUI renderer for testing container node rendering
struct MockSwiftUIContainerRenderer: SwiftUINodeRendering {
    static let nodeKind: RenderNodeKind = RenderNodeKind.container

    @MainActor
    func render(_ node: RenderNode, context: SwiftUIRenderContext) -> AnyView {
        AnyView(VStack {}.accessibilityIdentifier("mock_swiftui_container"))
    }
}

/// Mock SwiftUI renderer for custom node kind
struct MockSwiftUICustomRenderer: SwiftUINodeRendering {
    static let nodeKind: RenderNodeKind = RenderNodeKind.testCustom

    @MainActor
    func render(_ node: RenderNode, context: SwiftUIRenderContext) -> AnyView {
        AnyView(EmptyView().accessibilityIdentifier("mock_swiftui_custom"))
    }
}

// MARK: - Test Helpers

/// Creates a test SwiftUIRenderContext
@MainActor
func createSwiftUITestContext(registry: SwiftUINodeRendererRegistry) -> SwiftUIRenderContext {
    let registries = CoreManifest.createRegistries()
    let stateStore = StateStore()
    let document = Document.Definition(
        id: "test",
        root: Document.RootComponent(children: [])
    )
    let actionResolver = ActionResolver(registry: registries.actionResolverRegistry)
    let actionContext = ActionContext(
        stateStore: stateStore,
        actionDefinitions: [:],
        registry: registries.actionRegistry,
        actionResolver: actionResolver,
        document: document
    )
    let renderTree = RenderTree(
        root: RootNode(children: []),
        stateStore: stateStore,
        actions: [:]
    )
    return SwiftUIRenderContext(
        tree: renderTree,
        actionContext: actionContext,
        rendererRegistry: registry
    )
}

// MARK: - Registration Tests

struct SwiftUINodeRendererRegistryRegistrationTests {
    
    @Test func registersRenderer() {
        let registry = SwiftUINodeRendererRegistry()
        registry.register(MockSwiftUITextRenderer())
        
        #expect(registry.hasRenderer(for: RenderNodeKind.text))
    }
    
    @Test func registersMultipleRenderers() {
        let registry = SwiftUINodeRendererRegistry()
        registry.register(MockSwiftUITextRenderer())
        registry.register(MockSwiftUIButtonRenderer())
        registry.register(MockSwiftUIContainerRenderer())
        
        #expect(registry.hasRenderer(for: RenderNodeKind.text))
        #expect(registry.hasRenderer(for: RenderNodeKind.button))
        #expect(registry.hasRenderer(for: RenderNodeKind.container))
    }
    
    @Test func registersCustomNodeKindRenderer() {
        let registry = SwiftUINodeRendererRegistry()
        registry.register(MockSwiftUICustomRenderer())
        
        #expect(registry.hasRenderer(for: .testCustom))
    }
    
    @Test func replacesExistingRenderer() {
        let registry = SwiftUINodeRendererRegistry()
        registry.register(MockSwiftUITextRenderer())
        registry.register(MockSwiftUITextRenderer()) // Re-register
        
        #expect(registry.hasRenderer(for: RenderNodeKind.text))
    }
    
    @Test func unregistersRenderer() async throws {
        let registry = SwiftUINodeRendererRegistry()
        registry.register(MockSwiftUITextRenderer())
        
        #expect(registry.hasRenderer(for: RenderNodeKind.text))
        
        registry.unregister(.text)
        
        // Wait for async barrier to complete
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(!registry.hasRenderer(for: RenderNodeKind.text))
    }
}

// MARK: - Lookup Tests

struct SwiftUINodeRendererRegistryLookupTests {
    
    @Test func hasRendererReturnsFalseForUnregistered() {
        let registry = SwiftUINodeRendererRegistry()
        
        #expect(!registry.hasRenderer(for: RenderNodeKind.text))
        #expect(!registry.hasRenderer(for: RenderNodeKind.button))
        #expect(!registry.hasRenderer(for: RenderNodeKind.container))
    }
    
    @Test func hasRendererReturnsTrueForRegistered() {
        let registry = SwiftUINodeRendererRegistry()
        registry.register(MockSwiftUITextRenderer())
        
        #expect(registry.hasRenderer(for: RenderNodeKind.text))
        #expect(!registry.hasRenderer(for: RenderNodeKind.button))
    }
    
    @Test func rendererForKindReturnsNilForUnregistered() {
        let registry = SwiftUINodeRendererRegistry()
        
        #expect(registry.renderer(for: RenderNodeKind.text) == nil)
    }
    
    @Test func rendererForKindReturnsRendererForRegistered() {
        let registry = SwiftUINodeRendererRegistry()
        registry.register(MockSwiftUITextRenderer())
        
        let renderer = registry.renderer(for: RenderNodeKind.text)
        #expect(renderer != nil)
    }
}

// MARK: - Rendering Tests

struct SwiftUINodeRendererRegistryRenderingTests {
    
    @Test @MainActor func rendersTextNode() {
        let registry = SwiftUINodeRendererRegistry()
        registry.register(MockSwiftUITextRenderer())

        let context = createSwiftUITestContext(registry: registry)
        let textNode = RenderNode(TextNode(
            content: "Test"
        ))

        let view = registry.render(textNode, context: context)

        #expect(view != nil)
    }

    @Test @MainActor func rendersButtonNode() {
        let registry = SwiftUINodeRendererRegistry()
        registry.register(MockSwiftUIButtonRenderer())

        let context = createSwiftUITestContext(registry: registry)
        let buttonNode = RenderNode(ButtonNode(
            label: "Tap Me",
            styles: ButtonStyles()
        ))

        let view = registry.render(buttonNode, context: context)

        #expect(view != nil)
    }

    @Test @MainActor func rendersContainerNode() {
        let registry = SwiftUINodeRendererRegistry()
        registry.register(MockSwiftUIContainerRenderer())

        let context = createSwiftUITestContext(registry: registry)
        let containerNode = RenderNode(ContainerNode(
            layoutType: .vstack,
            children: []
        ))

        let view = registry.render(containerNode, context: context)

        #expect(view != nil)
    }

    @Test @MainActor func returnsNilForUnregisteredKind() {
        let registry = SwiftUINodeRendererRegistry()
        // Don't register any renderers

        let context = createSwiftUITestContext(registry: registry)
        let textNode = RenderNode(TextNode(
            content: "Test"
        ))

        let view = registry.render(textNode, context: context)

        #expect(view == nil)
    }
}

// MARK: - Protocol Conformance Tests

struct SwiftUIMockRenderersProtocolTests {
    
    @Test func swiftUIMockRendererProvidesNodeKind() {
        #expect(MockSwiftUITextRenderer.nodeKind == RenderNodeKind.text)
        #expect(MockSwiftUIButtonRenderer.nodeKind == RenderNodeKind.button)
        #expect(MockSwiftUIContainerRenderer.nodeKind == RenderNodeKind.container)
        #expect(MockSwiftUICustomRenderer.nodeKind == .testCustom)
    }
    
    @Test @MainActor func rendererReturnsAnyView() {
        let registry = SwiftUINodeRendererRegistry()
        registry.register(MockSwiftUITextRenderer())

        let context = createSwiftUITestContext(registry: registry)
        let textNode = RenderNode(TextNode(
            content: "Test"
        ))

        let renderer = MockSwiftUITextRenderer()
        let view = renderer.render(textNode, context: context)

        // Verify it returns an AnyView (type check)
        _ = view // AnyView type
    }
}

// MARK: - Edge Case Tests

struct SwiftUINodeRendererRegistryEdgeCaseTests {
    
    @Test func emptyRegistryHasNoRenderers() {
        let registry = SwiftUINodeRendererRegistry()
        
        #expect(!registry.hasRenderer(for: RenderNodeKind.text))
        #expect(!registry.hasRenderer(for: RenderNodeKind.button))
        #expect(!registry.hasRenderer(for: RenderNodeKind.container))
        #expect(!registry.hasRenderer(for: RenderNodeKind.sectionLayout))
        #expect(!registry.hasRenderer(for: RenderNodeKind.textField))
        #expect(!registry.hasRenderer(for: RenderNodeKind.toggle))
        #expect(!registry.hasRenderer(for: RenderNodeKind.slider))
        #expect(!registry.hasRenderer(for: RenderNodeKind.image))
        #expect(!registry.hasRenderer(for: RenderNodeKind.gradient))
        #expect(!registry.hasRenderer(for: RenderNodeKind.spacer))
    }
    
    @Test func registerSameKindMultipleTimes() {
        let registry = SwiftUINodeRendererRegistry()
        
        registry.register(MockSwiftUITextRenderer())
        registry.register(MockSwiftUITextRenderer())
        registry.register(MockSwiftUITextRenderer())
        
        #expect(registry.hasRenderer(for: RenderNodeKind.text))
    }
    
    @Test func unregisterNonExistentKind() {
        let registry = SwiftUINodeRendererRegistry()
        
        // Should not crash
        registry.unregister(RenderNodeKind.text)
        registry.unregister(RenderNodeKind.button)

        #expect(!registry.hasRenderer(for: RenderNodeKind.text))
    }
    
    @Test @MainActor func contextRenderMethodUsesRegistry() {
        let registry = SwiftUINodeRendererRegistry()
        registry.register(MockSwiftUITextRenderer())

        let context = createSwiftUITestContext(registry: registry)
        let textNode = RenderNode(TextNode(
            content: "Test"
        ))

        // Context.render should delegate to registry
        let view = context.render(textNode)

        // If no renderer, it returns EmptyView wrapped in AnyView
        // If renderer exists, it returns the rendered view
        _ = view // Should not crash
    }
}
