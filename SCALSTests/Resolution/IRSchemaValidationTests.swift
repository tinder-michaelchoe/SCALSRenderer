//
//  IRSchemaValidationTests.swift
//  SCALSTests
//
//  Tests that verify the resolved IR output conforms to the clads-ir-schema.json structure.
//  These tests ensure cross-platform compatibility by validating that resolution produces
//  output matching the expected schema structure.
//
//  Note: Full JSON schema validation requires Codable conformance on all IR types.
//  Until then, these tests validate structural requirements manually.
//

import Foundation
import Testing
import SwiftUI

@testable import SCALS
@testable import ScalsModules

// MARK: - RenderTree Schema Compliance Tests

/// Tests that RenderTree has all required top-level properties per schema:
/// - root: RootNode
/// - state: Dictionary of state values
/// - actions: Dictionary of ActionDefinition
struct RenderTreeSchemaTests {
    
    @Test @MainActor func renderTreeHasRequiredProperties() throws {
        let document = Document.Definition(
            id: "test",
            state: ["count": .intValue(0)],
            actions: ["dismiss": Document.Action(type: .dismiss, parameters: [:])],
            root: Document.RootComponent(children: [])
        )

        let componentRegistry = ComponentResolverRegistry()
        let layoutResolver = LayoutResolver(componentRegistry: componentRegistry)
        let sectionLayoutResolver = SectionLayoutResolver(componentRegistry: componentRegistry)
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            actionResolverRegistry: CoreManifest.createRegistries().actionResolverRegistry,
            layoutResolver: layoutResolver,
            sectionLayoutResolver: sectionLayoutResolver
        )
        let renderTree = try resolver.resolve()
        
        // Schema requires: root, state (via stateStore), actions
        // Verify root exists
        _ = renderTree.root
        
        // Verify state store has values
        #expect(renderTree.stateStore.get("count") != nil)
        
        // Verify actions dictionary exists with resolved actions
        #expect(renderTree.actions["dismiss"] != nil)
    }
    
    @Test @MainActor func renderTreeActionsAreResolved() throws {
        let document = Document.Definition(
            id: "test",
            actions: [
                "close": Document.Action(type: .dismiss, parameters: [:]),
                "toggle": Document.Action(type: .toggleState, parameters: ["path": .stringValue("isOn")]),
                "navigate": Document.Action(type: .navigate, parameters: ["destination": .stringValue("settings"), "presentation": .stringValue("push")])
            ],
            root: Document.RootComponent(children: [])
        )

        let componentRegistry = ComponentResolverRegistry()
        let layoutResolver = LayoutResolver(componentRegistry: componentRegistry)
        let sectionLayoutResolver = SectionLayoutResolver(componentRegistry: componentRegistry)
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            actionResolverRegistry: CoreManifest.createRegistries().actionResolverRegistry,
            layoutResolver: layoutResolver,
            sectionLayoutResolver: sectionLayoutResolver
        )
        let renderTree = try resolver.resolve()
        
        // Per schema, actions are ActionDefinition with type discriminator
        if let closeAction = renderTree.actions["close"] {
            // matches schema: { "type": "dismiss" }
            #expect(closeAction.kind == .dismiss)
        } else {
            Issue.record("Expected dismiss action")
        }

        if let toggleAction = renderTree.actions["toggle"] {
            // matches schema: { "type": "toggleState", "path": "..." }
            #expect(toggleAction.kind == .toggleState)
            let path: String = try toggleAction.requiredParameter("path")
            #expect(path == "isOn")
        } else {
            Issue.record("Expected toggleState action")
        }

        if let navigateAction = renderTree.actions["navigate"] {
            // matches schema: { "type": "navigate", "destination": "...", "presentation": "..." }
            #expect(navigateAction.kind == .navigate)
            let dest: String = try navigateAction.requiredParameter("destination")
            let pres: Document.NavigationPresentation = try navigateAction.requiredParameter("presentation")
            #expect(dest == "settings")
            #expect(pres == .push)
        } else {
            Issue.record("Expected navigate action")
        }
    }
}

// MARK: - RootNode Schema Compliance Tests

/// Tests that RootNode conforms to schema requirements:
/// - required: colorScheme, style, actions, children
/// - optional: backgroundColor, edgeInsets
struct RootNodeSchemaTests {
    
    @Test @MainActor func rootNodeHasRequiredColorScheme() throws {
        let document = Document.Definition(
            id: "test",
            root: Document.RootComponent(colorScheme: "dark", children: [])
        )

        let componentRegistry = ComponentResolverRegistry()
        let layoutResolver = LayoutResolver(componentRegistry: componentRegistry)
        let sectionLayoutResolver = SectionLayoutResolver(componentRegistry: componentRegistry)
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            actionResolverRegistry: CoreManifest.createRegistries().actionResolverRegistry,
            layoutResolver: layoutResolver,
            sectionLayoutResolver: sectionLayoutResolver
        )
        let renderTree = try resolver.resolve()
        
        // Schema: colorScheme is required, enum: ["light", "dark", "system"]
        #expect(renderTree.root.colorScheme == .dark)
    }
    
    @Test @MainActor func rootNodeColorSchemeDefaults() throws {
        let document = Document.Definition(
            id: "test",
            root: Document.RootComponent(children: [])
        )

        let componentRegistry = ComponentResolverRegistry()
        let layoutResolver = LayoutResolver(componentRegistry: componentRegistry)
        let sectionLayoutResolver = SectionLayoutResolver(componentRegistry: componentRegistry)
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            actionResolverRegistry: CoreManifest.createRegistries().actionResolverRegistry,
            layoutResolver: layoutResolver,
            sectionLayoutResolver: sectionLayoutResolver
        )
        let renderTree = try resolver.resolve()
        
        // Schema: should default to "system"
        #expect(renderTree.root.colorScheme == .system)
    }
    
    @Test @MainActor func rootNodeHasChildrenArray() throws {
        let document = Document.Definition(
            id: "test",
            root: Document.RootComponent(children: [.spacer(Document.Spacer()), .spacer(Document.Spacer())])
        )

        let componentRegistry = ComponentResolverRegistry()
        let layoutResolver = LayoutResolver(componentRegistry: componentRegistry)
        let sectionLayoutResolver = SectionLayoutResolver(componentRegistry: componentRegistry)
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            actionResolverRegistry: CoreManifest.createRegistries().actionResolverRegistry,
            layoutResolver: layoutResolver,
            sectionLayoutResolver: sectionLayoutResolver
        )
        let renderTree = try resolver.resolve()
        
        // Schema: children is required array of renderNode
        #expect(renderTree.root.children.count == 2)
    }
    
    @Test @MainActor func rootNodeHasActionsObject() throws {
        let document = Document.Definition(
            id: "test",
            actions: ["onLoad": Document.Action(type: .dismiss, parameters: [:])],
            root: Document.RootComponent(
                actions: Document.LifecycleActions(onAppear: .reference("onLoad")),
                children: []
            )
        )

        let componentRegistry = ComponentResolverRegistry()
        let layoutResolver = LayoutResolver(componentRegistry: componentRegistry)
        let sectionLayoutResolver = SectionLayoutResolver(componentRegistry: componentRegistry)
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            actionResolverRegistry: CoreManifest.createRegistries().actionResolverRegistry,
            layoutResolver: layoutResolver,
            sectionLayoutResolver: sectionLayoutResolver
        )
        let renderTree = try resolver.resolve()
        
        // Schema: lifecycleActions has optional onAppear/onDisappear
        #expect(renderTree.root.actions.action(for: .onAppear) != nil)
    }
    
    @Test @MainActor func rootNodeEdgeInsetsMatchSchema() throws {
        let document = Document.Definition(
            id: "test",
            root: Document.RootComponent(
                edgeInsets: Document.EdgeInsets(
                    top: Document.EdgeInset(positioning: .safeArea, value: 10),
                    bottom: Document.EdgeInset(positioning: .absolute, value: 20)
                ),
                children: []
            )
        )

        let componentRegistry = ComponentResolverRegistry()
        let layoutResolver = LayoutResolver(componentRegistry: componentRegistry)
        let sectionLayoutResolver = SectionLayoutResolver(componentRegistry: componentRegistry)
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            actionResolverRegistry: CoreManifest.createRegistries().actionResolverRegistry,
            layoutResolver: layoutResolver,
            sectionLayoutResolver: sectionLayoutResolver
        )
        let renderTree = try resolver.resolve()
        
        // Schema: edgeInsets has positioning enum: ["safeArea", "absolute"]
        #expect(renderTree.root.edgeInsets?.top?.positioning == .safeArea)
        #expect(renderTree.root.edgeInsets?.top?.value == 10)
        #expect(renderTree.root.edgeInsets?.bottom?.positioning == .absolute)
        #expect(renderTree.root.edgeInsets?.bottom?.value == 20)
    }
}

// MARK: - RenderNode Schema Compliance Tests

/// Tests that RenderNode discriminated union matches schema oneOf structure
struct RenderNodeSchemaTests {
    
    @Test @MainActor func spacerNodeMatchesSchema() throws {
        let document = Document.Definition(
            id: "test",
            root: Document.RootComponent(children: [.spacer(Document.Spacer())])
        )

        let componentRegistry = ComponentResolverRegistry()
        let layoutResolver = LayoutResolver(componentRegistry: componentRegistry)
        let sectionLayoutResolver = SectionLayoutResolver(componentRegistry: componentRegistry)
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            actionResolverRegistry: CoreManifest.createRegistries().actionResolverRegistry,
            layoutResolver: layoutResolver,
            sectionLayoutResolver: sectionLayoutResolver
        )
        let renderTree = try resolver.resolve()
        
        // Schema: spacerNode = { nodeType: "spacer" }
        if renderTree.root.children[0].data(SpacerNode.self) != nil {
            // RenderNode.spacer maps to { "nodeType": "spacer" }
        } else {
            Issue.record("Expected spacer node")
        }
    }
    
    @Test @MainActor func containerNodeHasRequiredProperties() throws {
        let document = Document.Definition(
            id: "test",
            root: Document.RootComponent(
                children: [
                    .layout(Document.Layout(
                        type: .vstack,
                        horizontalAlignment: .leading,
                        spacing: 16,
                        padding: Document.Padding(top: 8, bottom: 8, leading: 8, trailing: 8),
                        children: [.spacer(Document.Spacer())]
                    ))
                ]
            )
        )

        let componentRegistry = ComponentResolverRegistry()
        let layoutResolver = LayoutResolver(componentRegistry: componentRegistry)
        let sectionLayoutResolver = SectionLayoutResolver(componentRegistry: componentRegistry)
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            actionResolverRegistry: CoreManifest.createRegistries().actionResolverRegistry,
            layoutResolver: layoutResolver,
            sectionLayoutResolver: sectionLayoutResolver
        )
        let renderTree = try resolver.resolve()
        
        // Schema containerNode requires:
        // nodeType: "container", layoutType, alignment, spacing, padding, style, children
        if let container = renderTree.root.children[0].data(ContainerNode.self) {
            // layoutType: enum ["vstack", "hstack", "zstack"]
            #expect(container.layoutType == .vstack)
            
            // spacing: number
            #expect(container.spacing == 16)
            
            // alignment: SwiftUI.Alignment (for VStack, this is horizontal alignment)
            #expect(container.alignment == .leading)
            
            // padding: directionalEdgeInsets { top, leading, bottom, trailing }
            #expect(container.padding.top == 8)
            #expect(container.padding.leading == 8)
            #expect(container.padding.bottom == 8)
            #expect(container.padding.trailing == 8)
            
            // children: array of renderNode
            #expect(container.children.count == 1)
        } else {
            Issue.record("Expected container node")
        }
    }
    
    @Test @MainActor func textNodeHasRequiredProperties() throws {
        // TextNode schema requires: nodeType, content, style, padding, isDynamic
        let textNode = TextNode(
            id: "label",
            content: "Hello",
            padding: IR.EdgeInsets.zero
        )
        
        // Schema: nodeType = "text"
        #expect(RenderNode(textNode).kind == RenderNodeKind.text)
        
        // Schema: content is string
        #expect(textNode.content == "Hello")
        
        // Schema: isDynamic is boolean
        #expect(textNode.isDynamic == false)
    }
    
    @Test @MainActor func textNodeWithBindingIsDynamic() throws {
        let textNode = TextNode(
            id: "dynamic",
            content: "Value",
            bindingPath: "state.value"
        )
        
        // Schema: bindingPath is optional string, isDynamic reflects this
        #expect(textNode.bindingPath == "state.value")
        #expect(textNode.isDynamic == true)
    }
    
    @Test @MainActor func buttonNodeHasRequiredProperties() throws {
        // Schema buttonNode requires: nodeType, label, styles, fillWidth
        let normalStyle = ButtonStateStyle(backgroundColor: .blue)

        let buttonNode = ButtonNode(
            id: "btn",
            label: "Click",
            styles: ButtonStyles(normal: normalStyle),
            fillWidth: false
        )

        // Schema: nodeType = "button"
        #expect(RenderNode(buttonNode).kind == RenderNodeKind.button)

        // Schema: label is string
        #expect(buttonNode.label == "Click")

        // Schema: fillWidth is boolean
        #expect(buttonNode.fillWidth == false)

        // Schema: styles.normal is required
        #expect(buttonNode.styles.normal.backgroundColor == .blue)
    }
    
    @Test @MainActor func imageNodeSourceMatchesSchema() throws {
        // Schema imageSource oneOf: sfsymbol, asset, url
        
        // SFSymbol: { type: "sfsymbol", name: string }
        let sfsymbolImage = ImageNode(
            id: "icon",
            source: .sfsymbol(name: "star.fill")
        )
        if case .sfsymbol(let name) = sfsymbolImage.source {
            #expect(name == "star.fill")
        } else {
            Issue.record("Expected sfsymbol image")
        }
        
        // Asset: { type: "asset", name: string }
        let assetImage = ImageNode(
            id: "logo",
            source: .asset(name: "AppLogo")
        )
        if case .asset(let name) = assetImage.source {
            #expect(name == "AppLogo")
        } else {
            Issue.record("Expected asset image")
        }
        
        // URL: { type: "url", url: string (uri format) }
        let urlImage = ImageNode(
            id: "remote",
            source: .url(URL(string: "https://example.com/image.png")!)
        )
        if case .url(let url) = urlImage.source {
            #expect(url.absoluteString == "https://example.com/image.png")
        } else {
            Issue.record("Expected URL image")
        }
    }
    
    @Test @MainActor func sliderNodeHasMinMaxValues() throws {
        // Schema sliderNode requires: nodeType, minValue, maxValue, style
        let sliderNode = SliderNode(
            id: "slider",
            minValue: 0,
            maxValue: 100
        )
        
        #expect(RenderNode(sliderNode).kind == RenderNodeKind.slider)
        #expect(sliderNode.minValue == 0)
        #expect(sliderNode.maxValue == 100)
    }
    
    @Test @MainActor func gradientNodeMatchesSchema() throws {
        // Schema gradientNode requires: nodeType, gradientType, colors, startPoint, endPoint, style
        let gradientNode = GradientNode(
            id: "gradient",
            gradientType: .linear,
            colors: [
                GradientNode.ColorStop(color: .fixed(IR.Color.red), location: 0),
                GradientNode.ColorStop(color: .fixed(IR.Color.blue), location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        
        #expect(RenderNode(gradientNode).kind == RenderNodeKind.gradient)
        
        // Schema: gradientType enum ["linear", "radial"]
        #expect(gradientNode.gradientType == .linear)
        
        // Schema: colors array of colorStop { color, location }
        #expect(gradientNode.colors.count == 2)
        #expect(gradientNode.colors[0].location == 0)
        #expect(gradientNode.colors[1].location == 1)
        
        // Schema: startPoint/endPoint are unitPoint { x, y }
        #expect(gradientNode.startPoint == .top)
        #expect(gradientNode.endPoint == .bottom)
    }
}

// MARK: - SectionLayout Schema Compliance Tests

struct SectionLayoutSchemaTests {
    
    @Test @MainActor func sectionLayoutNodeHasRequiredProperties() throws {
        let registry = ComponentResolverRegistry()
        let resolver = SectionLayoutResolver(componentRegistry: registry)
        let context = createTestContext()
        
        let sectionLayout = Document.SectionLayout(
            id: "sections",
            sectionSpacing: 24,
            sections: [
                Document.SectionDefinition(
                    layout: Document.SectionLayoutConfig(type: .horizontal),
                    children: [.spacer(Document.Spacer())]
                )
            ]
        )
        
        let result = try resolver.resolve(sectionLayout, context: context)
        
        // Schema sectionLayoutNode requires: nodeType, sectionSpacing, sections
        if let node = result.renderNode.data(SectionLayoutNode.self) {
            #expect(node.id == "sections")
            #expect(node.sectionSpacing == 24)
            #expect(node.sections.count == 1)
        } else {
            Issue.record("Expected sectionLayout node")
        }
    }
    
    @Test @MainActor func sectionTypeMatchesSchemaOneOf() throws {
        let registry = ComponentResolverRegistry()
        let resolver = SectionLayoutResolver(componentRegistry: registry)
        let context = createTestContext()
        
        // Schema sectionType oneOf: horizontal, list, grid (with columns), flow
        
        // Horizontal: { type: "horizontal" }
        let horizontalLayout = Document.SectionLayout(
            sections: [Document.SectionDefinition(
                layout: Document.SectionLayoutConfig(type: .horizontal),
                children: []
            )]
        )
        let horizontalResult = try resolver.resolve(horizontalLayout, context: context)
        if let node = horizontalResult.renderNode.data(SectionLayoutNode.self) {
            if case .horizontal = node.sections[0].layoutType {
                // Matches schema
            } else {
                Issue.record("Expected horizontal type")
            }
        }
        
        // Grid: { type: "grid", columns: { type: "fixed", count: N } }
        let gridLayout = Document.SectionLayout(
            sections: [Document.SectionDefinition(
                layout: Document.SectionLayoutConfig(type: .grid, columns: .fixed(3)),
                children: []
            )]
        )
        let gridResult = try resolver.resolve(gridLayout, context: context)
        if let node = gridResult.renderNode.data(SectionLayoutNode.self) {
            if case .grid(let columns) = node.sections[0].layoutType {
                if case .fixed(let count) = columns {
                    #expect(count == 3)
                } else {
                    Issue.record("Expected fixed columns")
                }
            } else {
                Issue.record("Expected grid type")
            }
        }
    }
    
    @Test @MainActor func sectionConfigMatchesSchema() throws {
        let registry = ComponentResolverRegistry()
        let resolver = SectionLayoutResolver(componentRegistry: registry)
        let context = createTestContext()
        
        // Schema sectionConfig requires: alignment, itemSpacing, lineSpacing,
        // contentInsets, showsIndicators, isPagingEnabled, snapBehavior, showsDividers
        
        let sectionLayout = Document.SectionLayout(
            sections: [Document.SectionDefinition(
                layout: Document.SectionLayoutConfig(
                    type: .list,
                    alignment: .center,
                    itemSpacing: 12,
                    lineSpacing: 16,
                    contentInsets: Document.Padding(top: 8, bottom: 8, leading: 8, trailing: 8),
                    showsIndicators: true,
                    snapBehavior: .viewAligned,
                    showsDividers: false
                ),
                children: []
            )]
        )
        
        let result = try resolver.resolve(sectionLayout, context: context)
        
        if let node = result.renderNode.data(SectionLayoutNode.self) {
            let config = node.sections[0].config
            
            // Schema: alignment enum ["leading", "center", "trailing"]
            #expect(config.alignment == .center)
            
            // Schema: itemSpacing number
            #expect(config.itemSpacing == 12)
            
            // Schema: lineSpacing number
            #expect(config.lineSpacing == 16)
            
            // Schema: contentInsets directionalEdgeInsets
            #expect(config.contentInsets.top == 8)
            #expect(config.contentInsets.leading == 8)
            
            // Schema: showsIndicators boolean
            #expect(config.showsIndicators == true)
            
            // Schema: showsDividers boolean
            #expect(config.showsDividers == false)
            
            // Schema: snapBehavior enum ["none", "viewAligned", "paging"]
            #expect(config.snapBehavior == .viewAligned)
        } else {
            Issue.record("Expected sectionLayout node")
        }
    }
}

// MARK: - ActionDefinition Schema Compliance Tests

struct ActionDefinitionSchemaTests {
    
    @Test func dismissActionMatchesSchema() throws {
        // Schema: { type: "dismiss" }
        let document = Document.Definition(id: "test", root: Document.RootComponent(children: []))
        let context = ResolutionContext.withoutTracking(document: document, stateStore: StateStore())
        let resolver = ActionResolver(registry: CoreManifest.createRegistries().actionResolverRegistry)

        let documentAction = Document.Action(type: .dismiss, parameters: [:])
        let action = try resolver.resolve(documentAction, context: context)

        #expect(action.kind == .dismiss)
    }
    
    @Test func setStateActionMatchesSchema() throws {
        // Schema: { type: "setState", path: string, value: any }
        let document = Document.Definition(id: "test", root: Document.RootComponent(children: []))
        let context = ResolutionContext.withoutTracking(document: document, stateStore: StateStore())
        let resolver = ActionResolver(registry: CoreManifest.createRegistries().actionResolverRegistry)

        let documentAction = Document.Action(
            type: .setState,
            parameters: ["path": .stringValue("user.name"), "value": .stringValue("John")]
        )
        let action = try resolver.resolve(documentAction, context: context)

        #expect(action.kind == .setState)
        let path: String = try action.requiredParameter("path")
        let value: String = try action.requiredParameter("value")
        #expect(path == "user.name")
        #expect(value == "John")
    }
    
    @Test func navigateActionMatchesSchema() throws {
        // Schema: { type: "navigate", destination: string, presentation: enum }
        let document = Document.Definition(id: "test", root: Document.RootComponent(children: []))
        let context = ResolutionContext.withoutTracking(document: document, stateStore: StateStore())
        let resolver = ActionResolver(registry: CoreManifest.createRegistries().actionResolverRegistry)

        let documentAction = Document.Action(
            type: .navigate,
            parameters: ["destination": .stringValue("profile"), "presentation": .stringValue("fullScreen")]
        )
        let action = try resolver.resolve(documentAction, context: context)

        #expect(action.kind == .navigate)
        let dest: String = try action.requiredParameter("destination")
        let pres: Document.NavigationPresentation = try action.requiredParameter("presentation")
        #expect(dest == "profile")
        // Schema: presentation enum ["push", "present", "fullScreen"]
        #expect(pres == .fullScreen)
    }
    
    @Test func sequenceActionMatchesSchema() throws {
        // Schema: { type: "sequence", steps: [actionDefinition] }
        let document = Document.Definition(id: "test", root: Document.RootComponent(children: []))
        let context = ResolutionContext.withoutTracking(document: document, stateStore: StateStore())
        let resolver = ActionResolver(registry: CoreManifest.createRegistries().actionResolverRegistry)

        let dismissAction1 = Document.Action(type: .dismiss, parameters: [:])
        let dismissAction2 = Document.Action(type: .dismiss, parameters: [:])
        let documentAction = Document.Action(
            type: .sequence,
            parameters: ["steps": .arrayValue([dismissAction1, dismissAction2].map { action in
                // Convert Document.Action to StateValue representation
                var dict: [String: Document.StateValue] = ["type": .stringValue(action.type.rawValue)]
                for (key, value) in action.parameters {
                    dict[key] = value
                }
                return .objectValue(dict)
            })]
        )
        let action = try resolver.resolve(documentAction, context: context)

        #expect(action.kind == .sequence)
        let steps: [IR.ActionDefinition] = try action.requiredParameter("steps")
        #expect(steps.count == 2)
    }
    
    @Test func showAlertActionMatchesSchema() throws {
        // Schema: { type: "showAlert", title: string, message?: string, buttons: array }
        let document = Document.Definition(id: "test", root: Document.RootComponent(children: []))
        let context = ResolutionContext.withoutTracking(document: document, stateStore: StateStore())
        let resolver = ActionResolver(registry: CoreManifest.createRegistries().actionResolverRegistry)

        let documentAction = Document.Action(
            type: .showAlert,
            parameters: [
                "title": .stringValue("Confirm"),
                "message": .stringValue("Are you sure?"),
                "buttons": .arrayValue([
                    .objectValue([
                        "label": .stringValue("Yes"),
                        "style": .stringValue("default"),
                        "action": .stringValue("confirm")
                    ]),
                    .objectValue([
                        "label": .stringValue("No"),
                        "style": .stringValue("cancel")
                    ])
                ])
            ]
        )
        let action = try resolver.resolve(documentAction, context: context)

        #expect(action.kind == .showAlert)
        let title: String = try action.requiredParameter("title")
        let message: String? = action.parameter("message")
        let isTemplate: Bool = action.parameter("messageIsTemplate") ?? false
        let buttons: [[String: Any]] = try action.requiredParameter("buttons")

        #expect(title == "Confirm")
        #expect(message == "Are you sure?")
        #expect(isTemplate == false)

        // Schema: buttons array of alertButton { label, style, action? }
        #expect(buttons.count == 2)
        #expect(buttons[0]["label"] as? String == "Yes")
        #expect(buttons[0]["style"] as? String == "default")
        #expect(buttons[0]["action"] as? String == "confirm")
        #expect(buttons[1]["label"] as? String == "No")
        #expect(buttons[1]["style"] as? String == "cancel")
    }
    
    @Test func customActionMatchesSchema() throws {
        // Schema: { type: string (not reserved), parameters?: object }
        let document = Document.Definition(id: "test", root: Document.RootComponent(children: []))
        let context = ResolutionContext.withoutTracking(document: document, stateStore: StateStore())

        // Register a custom resolver for analytics.track
        let registry = CoreManifest.createRegistries().actionResolverRegistry
        let customKind = Document.ActionKind(rawValue: "analytics.track")
        struct AnalyticsResolver: ActionResolving {
            static let actionKind = Document.ActionKind(rawValue: "analytics.track")
            func resolve(_ action: Document.Action, context: ResolutionContext) throws -> IR.ActionDefinition {
                // Pass through all parameters as execution data
                var executionData: [String: AnySendable] = [:]
                for (key, value) in action.parameters {
                    executionData[key] = AnySendable(StateValueConverter.unwrap(value))
                }
                return IR.ActionDefinition(kind: Self.actionKind, executionData: executionData)
            }
        }
        registry.register(AnalyticsResolver())

        let resolver = ActionResolver(registry: registry)

        let documentAction = Document.Action(
            type: customKind,
            parameters: [
                "event": .stringValue("button_tap"),
                "count": .intValue(1)
            ]
        )
        let action = try resolver.resolve(documentAction, context: context)

        #expect(action.kind.rawValue == "analytics.track")
        // Custom actions store their parameters directly
        let event: String = try action.requiredParameter("event")
        let count: Int = try action.requiredParameter("count")
        #expect(event == "button_tap")
        #expect(count == 1)
    }
}

// MARK: - Style Schema Compliance Tests

@Suite(.disabled("IR.Style eliminated in flat IR refactoring"))
struct StyleSchemaTests {
    
    @Test func stylePropertiesMatchSchema() {
        // IR.Style eliminated - properties now directly on nodes
        // This test is no longer applicable with flat IR architecture
    }

    @Test func fontWeightMatchesSchemaEnum() {
        // Schema: fontWeight enum ["ultraLight", "thin", "light", "regular", "medium", "semibold", "bold", "heavy", "black"]
        let allWeights: [IR.FontWeight] = [
            .ultraLight, .thin, .light, .regular, .medium,
            .semibold, .bold, .heavy, .black
        ]

        for weight in allWeights {
            var style = ResolvedStyle()
            style.fontWeight = weight
            #expect(style.fontWeight == weight)
        }
    }
}

// MARK: - Cross-Platform Serialization Tests (Infrastructure)

/// Tests for JSON serialization - requires Codable conformance on IR types.
/// These tests document the expected serialization format for cross-platform use.
///
/// Note: With the fully dynamic action system, ActionDefinition stores parameters
/// as [String: AnySendable] which is not directly Codable. Serialization would
/// require custom encoding logic to convert AnySendable values to JSON-compatible types.
struct IRSerializationTests {

    // Serialization tests removed - ActionDefinition now uses dynamic dictionary
    // with AnySendable wrapper which is not directly Codable. For cross-platform
    // serialization, custom encoding logic would be needed to convert the
    // executionData dictionary to JSON-compatible types.

    // TODO: Add tests for RenderTree, RootNode, RenderNode once Codable conformance is added
    // These would validate the full IR output against the JSON schema
}
