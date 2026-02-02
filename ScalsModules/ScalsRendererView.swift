//
//  ScalsRendererView.swift
//  ScalsRendererFramework
//
//  Main entry point for rendering a document using the LLVM-inspired pipeline:
//  Document (AST) → Resolver → RenderTree (IR) → SwiftUIRenderer → View
//

import Combine
import SCALS
import SwiftUI

/// Main entry point for rendering a document
public struct ScalsRendererView: View {
    private let renderTree: RenderTree
    @StateObject private var observableActionContext: ObservableActionContext

    @Environment(\.dismiss) private var dismiss

    private let swiftuiRendererRegistry: SwiftUINodeRendererRegistry
    private let designSystemProvider: (any DesignSystemProvider)?

    /// Resolution error (only stored in DEBUG builds for error view)
    #if DEBUG
    private let resolutionError: Error?
    #endif

    /// Initialize with a document and registries.
    ///
    /// - Parameters:
    ///   - document: The document definition to render
    ///   - actionRegistry: Registry for action handlers (may include merged custom actions)
    ///   - componentRegistry: Registry for component resolvers
    ///   - swiftuiRendererRegistry: Registry for SwiftUI renderers
    ///   - customComponents: Array of custom component types to register
    ///   - actionDelegate: Delegate for handling custom actions
    ///   - designSystemProvider: Optional design system provider for style resolution and native components
    public init(
        document: Document.Definition,
        actionRegistry: ActionRegistry,
        componentRegistry: ComponentResolverRegistry,
        swiftuiRendererRegistry: SwiftUINodeRendererRegistry,
        customComponents: [any CustomComponent.Type] = [],
        actionDelegate: ScalsActionDelegate? = nil,
        designSystemProvider: (any DesignSystemProvider)? = nil
    ) {
        // Set up custom components if provided
        if !customComponents.isEmpty {
            let customRegistry = CustomComponentRegistry()
            customRegistry.register(customComponents)
            componentRegistry.setCustomComponentRegistry(customRegistry)

            // Register the custom component SwiftUI renderer
            let customRenderer = CustomComponentSwiftUIRenderer(customComponentRegistry: customRegistry)
            swiftuiRendererRegistry.register(customRenderer)
        }

        self.swiftuiRendererRegistry = swiftuiRendererRegistry
        self.designSystemProvider = designSystemProvider

        // Resolve Document (AST) into RenderTree (IR)
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            designSystemProvider: designSystemProvider
        )
        let tree: RenderTree
        var capturedError: Error? = nil
        do {
            tree = try resolver.resolve()
        } catch {
            capturedError = error
            #if DEBUG
            print("⚠️  SCALS: Resolution failed - \(error)")
            #endif
            tree = RenderTree(
                root: RootNode(),
                stateStore: StateStore(),
                actions: [:]
            )
        }
        self.renderTree = tree
        #if DEBUG
        self.resolutionError = capturedError
        #endif

        // Log version information in DEBUG builds
        #if DEBUG
        Self.logVersionInfo(document: document, renderTree: tree)
        #endif

        // Create ActionContext with the resolved state store
        let ctx = ActionContext(
            stateStore: tree.stateStore,
            actionDefinitions: document.actions ?? [:],
            registry: actionRegistry,
            actionDelegate: actionDelegate
        )
        // Wrap in ObservableActionContext for SwiftUI integration
        _observableActionContext = StateObject(wrappedValue: ObservableActionContext(wrapping: ctx))
    }

    public var body: some View {
        #if DEBUG
        if let error = resolutionError {
            ResolutionErrorView(error: error)
        } else {
            renderContent()
        }
        #else
        renderContent()
        #endif
    }

    @ViewBuilder
    private func renderContent() -> some View {
        // Use SwiftUIRenderer to render the RenderTree
        let renderer = SwiftUIRenderer(
            actionContext: observableActionContext.context,
            rendererRegistry: swiftuiRendererRegistry,
            designSystemProvider: designSystemProvider
        )
        renderer.render(renderTree)
            .onAppear {
                setupContext()
            }
    }

    private func setupContext() {
        observableActionContext.context.dismissHandler = { [dismiss] in
            dismiss()
        }

        observableActionContext.context.alertHandler = { config in
            AlertPresenter.present(config)
        }
    }

    // MARK: - Version Logging

    /// Logs version information for debugging
    private static func logVersionInfo(document: Document.Definition, renderTree: RenderTree) {
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📄 SCALS Version Info")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

        // Document version
        if let docVersion = document.version {
            print("   Document: v\(docVersion)")
        } else {
            print("   Document: ⚠️  No version specified (defaulting to v0.1.0)")
        }

        // Renderer version
        print("   Renderer: v\(DocumentVersion.current.string)")

        // IR version
        print("   IR:       v\(renderTree.irVersion.string)")

        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
}

// MARK: - Convenience Initializers

extension ScalsRendererView {
    /// Initialize from a JSON string
    public init?(
        jsonString: String,
        actionRegistry: ActionRegistry,
        componentRegistry: ComponentResolverRegistry,
        swiftuiRendererRegistry: SwiftUINodeRendererRegistry,
        customComponents: [any CustomComponent.Type] = [],
        actionDelegate: ScalsActionDelegate? = nil,
        designSystemProvider: (any DesignSystemProvider)? = nil,
        debugMode: Bool = false
    ) {
        guard let document = try? Document.Definition(jsonString: jsonString) else {
            return nil
        }
        self.init(
            document: document,
            actionRegistry: actionRegistry,
            componentRegistry: componentRegistry,
            swiftuiRendererRegistry: swiftuiRendererRegistry,
            customComponents: customComponents,
            actionDelegate: actionDelegate,
            designSystemProvider: designSystemProvider,
            debugMode: debugMode
        )
    }

    /// Initialize from a Document with optional debug output
    public init(
        document: Document.Definition,
        actionRegistry: ActionRegistry,
        componentRegistry: ComponentResolverRegistry,
        swiftuiRendererRegistry: SwiftUINodeRendererRegistry,
        customComponents: [any CustomComponent.Type] = [],
        actionDelegate: ScalsActionDelegate? = nil,
        designSystemProvider: (any DesignSystemProvider)? = nil,
        debugMode: Bool
    ) {
        // Set up custom components if provided
        if !customComponents.isEmpty {
            let customRegistry = CustomComponentRegistry()
            customRegistry.register(customComponents)
            componentRegistry.setCustomComponentRegistry(customRegistry)

            // Register the custom component SwiftUI renderer
            let customRenderer = CustomComponentSwiftUIRenderer(customComponentRegistry: customRegistry)
            swiftuiRendererRegistry.register(customRenderer)
        }

        self.swiftuiRendererRegistry = swiftuiRendererRegistry
        self.designSystemProvider = designSystemProvider

        // Resolve Document (AST) into RenderTree (IR)
        let resolver = Resolver(
            document: document,
            componentRegistry: componentRegistry,
            designSystemProvider: designSystemProvider
        )
        let tree: RenderTree
        var capturedError: Error? = nil
        do {
            tree = try resolver.resolve()
        } catch {
            capturedError = error
            print("ScalsRendererView: Resolution failed - \(error)")
            tree = RenderTree(
                root: RootNode(),
                stateStore: StateStore(),
                actions: [:]
            )
        }
        self.renderTree = tree
        #if DEBUG
        self.resolutionError = capturedError
        #endif

        // Print version and debug output if enabled
        if debugMode {
            Self.logVersionInfo(document: document, renderTree: tree)
            let debugRenderer = DebugRenderer()
            print(debugRenderer.render(tree))
        }

        // Create ActionContext with the resolved state store
        let ctx = ActionContext(
            stateStore: tree.stateStore,
            actionDefinitions: document.actions ?? [:],
            registry: actionRegistry,
            actionDelegate: actionDelegate
        )
        // Wrap in ObservableActionContext for SwiftUI integration
        _observableActionContext = StateObject(wrappedValue: ObservableActionContext(wrapping: ctx))
    }
}

// MARK: - Binding-based API

/// Configuration for ScalsRendererBindingView with external state binding
public struct ScalsRendererBindingConfiguration<State: Codable> {
    /// Initial typed state (will be merged with document state)
    public var initialState: State?

    /// Called when state changes (for analytics, persistence, etc.)
    public var onStateChange: ((_ path: String, _ oldValue: Any?, _ newValue: Any?) -> Void)?

    /// Called when an action is executed
    public var onAction: ((_ actionId: String, _ parameters: [String: Any]) -> Void)?

    /// Registry for action handlers (may include merged custom actions)
    public var actionRegistry: ActionRegistry

    /// Registry for component resolvers
    public var componentRegistry: ComponentResolverRegistry

    /// Registry for SwiftUI renderers
    public var swiftuiRendererRegistry: SwiftUINodeRendererRegistry

    /// Custom component types to register
    public var customComponents: [any CustomComponent.Type]

    /// Delegate for handling custom actions
    public weak var actionDelegate: ScalsActionDelegate?

    /// Enable debug mode
    public var debugMode: Bool

    public init(
        initialState: State? = nil,
        onStateChange: ((_ path: String, _ oldValue: Any?, _ newValue: Any?) -> Void)? = nil,
        onAction: ((_ actionId: String, _ parameters: [String: Any]) -> Void)? = nil,
        actionRegistry: ActionRegistry,
        componentRegistry: ComponentResolverRegistry,
        swiftuiRendererRegistry: SwiftUINodeRendererRegistry,
        customComponents: [any CustomComponent.Type] = [],
        actionDelegate: ScalsActionDelegate? = nil,
        debugMode: Bool = false
    ) {
        self.initialState = initialState
        self.onStateChange = onStateChange
        self.onAction = onAction
        self.actionRegistry = actionRegistry
        self.componentRegistry = componentRegistry
        self.swiftuiRendererRegistry = swiftuiRendererRegistry
        self.customComponents = customComponents
        self.actionDelegate = actionDelegate
        self.debugMode = debugMode

        // Set up custom components if provided
        if !customComponents.isEmpty {
            let customRegistry = CustomComponentRegistry()
            customRegistry.register(customComponents)
            componentRegistry.setCustomComponentRegistry(customRegistry)

            // Register the custom component SwiftUI renderer
            let customRenderer = CustomComponentSwiftUIRenderer(customComponentRegistry: customRegistry)
            swiftuiRendererRegistry.register(customRenderer)
        }
    }
}

/// View wrapper that syncs state with an external Binding
public struct ScalsRendererBindingView<State: Codable & Equatable>: View {
    private let document: Document.Definition
    private let configuration: ScalsRendererBindingConfiguration<State>
    @Binding private var state: State

    @StateObject private var renderContext: BindingRenderContext<State>
    @Environment(\.dismiss) private var dismiss

    public init(
        document: Document.Definition,
        state: Binding<State>,
        configuration: ScalsRendererBindingConfiguration<State>
    ) {
        self.document = document
        self._state = state
        self.configuration = configuration

        // Create render context
        let context = BindingRenderContext<State>(
            document: document,
            configuration: configuration
        )
        _renderContext = StateObject(wrappedValue: context)
    }

    public var body: some View {
        Group {
            if let renderTree = renderContext.renderTree {
                let renderer = SwiftUIRenderer(actionContext: renderContext.actionContext, rendererRegistry: configuration.swiftuiRendererRegistry)
                renderer.render(renderTree)
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            setupContext()
            renderContext.syncFromExternal(state)
        }
        .onChange(of: state) { _, newValue in
            renderContext.syncFromExternal(newValue)
        }
        .onReceive(renderContext.$internalState) { newState in
            if let newState = newState {
                state = newState
            }
        }
    }

    private func setupContext() {
        renderContext.actionContext.dismissHandler = { [dismiss] in
            dismiss()
        }
        renderContext.actionContext.alertHandler = { config in
            AlertPresenter.present(config)
        }
    }
}

/// Internal context for binding-based rendering
class BindingRenderContext<State: Codable>: ObservableObject {
    @Published var internalState: State?
    @Published var renderTree: RenderTree?

    @MainActor
    var actionContext: ActionContext {
        _actionContext
    }
    private var _actionContext: ActionContext!
    private var stateStore: StateStore!
    private var stateCallbackId: UUID?
    private let configuration: ScalsRendererBindingConfiguration<State>

    @MainActor
    init(document: Document.Definition, configuration: ScalsRendererBindingConfiguration<State>) {
        self.configuration = configuration

        // Resolve document
        let resolver = Resolver(document: document, componentRegistry: configuration.componentRegistry)
        let tree: RenderTree
        do {
            tree = try resolver.resolve()
        } catch {
            print("BindingRenderContext: Resolution failed - \(error)")
            tree = RenderTree(root: RootNode(), stateStore: StateStore(), actions: [:])
        }

        self.renderTree = tree
        self.stateStore = tree.stateStore

        // Create action context
        self._actionContext = ActionContext(
            stateStore: tree.stateStore,
            actionDefinitions: document.actions ?? [:],
            registry: configuration.actionRegistry,
            actionDelegate: configuration.actionDelegate
        )

        // Set up state change callback
        if let onStateChange = configuration.onStateChange {
            stateCallbackId = stateStore.onStateChange { path, oldValue, newValue in
                onStateChange(path, oldValue, newValue)
            }
        }

        // Also sync internal state on every change
        _ = stateStore.onStateChange { [weak self] _, _, _ in
            Task { @MainActor in
                self?.syncToExternal()
            }
        }

        // Initialize with external state if provided
        if let initialState = configuration.initialState {
            stateStore.setTyped(initialState)
        }

        // Print debug if enabled
        if configuration.debugMode {
            let debugRenderer = DebugRenderer()
            print(debugRenderer.render(tree))
        }
    }

    @MainActor
    func syncFromExternal(_ state: State) {
        stateStore.setTyped(state)
    }

    @MainActor
    func syncToExternal() {
        internalState = stateStore.getTyped(State.self)
    }

    @MainActor
    func cleanup() {
        if let id = stateCallbackId {
            stateStore.removeStateChangeCallback(id)
        }
    }
}

// MARK: - Convenience Extensions for Binding API

extension ScalsRendererBindingView where State: Equatable {
    /// Initialize from a JSON string with state binding
    public init?(
        jsonString: String,
        state: Binding<State>,
        configuration: ScalsRendererBindingConfiguration<State>
    ) {
        guard let document = try? Document.Definition(jsonString: jsonString) else {
            return nil
        }
        self.init(document: document, state: state, configuration: configuration)
    }
}

// MARK: - Snapshot API

extension ScalsRendererView {
    /// Get a snapshot of the current state
    public var stateSnapshot: [String: Any] {
        return renderTree.stateStore.snapshot()
    }
}

// MARK: - Size Measurement

extension ScalsRendererView {
    /// Measures the size of this renderer view and binds it to the provided binding.
    ///
    /// Useful for dynamic bottom sheet sizing based on content.
    ///
    /// - Parameter size: Binding to store the measured size
    /// - Returns: A view that measures and reports its size
    public func measuringSize(_ size: Binding<CGSize>) -> some View {
        self.modifier(SizeMeasuringModifier(size: size))
    }
}

/// Internal view modifier for size measurement
/// This is defined here to match the ScalsRendererView context
private struct SizeMeasuringModifier: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geometry.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                DispatchQueue.main.async {
                    self.size = newSize
                }
            }
    }
}

/// Preference key for size propagation
private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// MARK: - Resolution Error View (DEBUG only)

#if DEBUG
/// Displays resolution errors in DEBUG builds for easier debugging
struct ResolutionErrorView: View {
    let error: Error

    @State private var isExpanded = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.yellow)

                    VStack(alignment: .leading) {
                        Text("SCALS Resolution Failed")
                            .font(.headline)
                        Text("DEBUG BUILD ONLY")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(12)

                // Error details
                VStack(alignment: .leading, spacing: 8) {
                    Button {
                        withAnimation { isExpanded.toggle() }
                    } label: {
                        HStack {
                            Text("Error Details")
                                .font(.subheadline.bold())
                            Spacer()
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        }
                    }
                    .buttonStyle(.plain)

                    if isExpanded {
                        Text(error.localizedDescription)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.red)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        if let resolutionError = error as? ResolutionError {
                            Text("Type: ResolutionError")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("Type: \(String(describing: type(of: error)))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)

                // Help text
                VStack(alignment: .leading, spacing: 8) {
                    Text("Common Causes")
                        .font(.subheadline.bold())

                    VStack(alignment: .leading, spacing: 4) {
                        Label("Invalid JSON structure", systemImage: "doc.badge.ellipsis")
                        Label("Unknown style reference", systemImage: "paintbrush")
                        Label("Invalid action definition", systemImage: "bolt.slash")
                        Label("Missing required fields", systemImage: "exclamationmark.circle")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)

                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}
#endif

