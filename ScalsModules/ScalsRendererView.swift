//
//  ScalsRendererView.swift
//  ScalsRendererFramework
//
//  Main entry point for rendering a document using the LLVM-inspired pipeline:
//  Document (AST) -> Resolver -> RenderTree (IR) -> SwiftUIRenderer -> View
//

import Combine
import SCALS
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Main entry point for rendering a document
public struct ScalsRendererView: View {
    private let renderTree: RenderTree
    @StateObject private var observableActionContext: ObservableActionContext
    @StateObject private var alertPresenter = SwiftUIAlertPresenter()

    @Environment(\.dismiss) private var dismissAction

    private let swiftuiRendererRegistry: SwiftUINodeRendererRegistry
    private let designSystemProvider: (any DesignSystemProvider)?

    // Store the presentation handler for view controller updates
    @State private var presentationHandler: SwiftUIPresentationHandler?

    // Callbacks for observation modifiers
    private var onStateChangeCallback: ((_ path: String, _ oldValue: Any?, _ newValue: Any?) -> Void)?
    private var onActionWillExecuteCallback: ((String) -> Void)?
    private var onActionDidExecuteCallback: ((String) -> Void)?
    private var onDismissRequestCallback: (() -> Void)?
    private var onNavigationRequestCallback: ((String, Document.NavigationPresentation?) -> Void)?
    private var onAlertRequestCallback: ((AlertConfiguration) -> Void)?

    /// Resolution error (only stored in DEBUG builds for error view)
    #if DEBUG
    private let resolutionError: Error?
    #endif

    // MARK: - Configuration-based Initializers

    /// Initialize with a Document and configuration.
    ///
    /// - Parameters:
    ///   - document: The document definition to render
    ///   - configuration: Configuration containing registries and settings
    ///
    /// Example:
    /// ```swift
    /// // Simplest usage
    /// ScalsRendererView(document: doc)
    ///
    /// // With configuration
    /// let config = SwiftUIRendererConfiguration(
    ///     customComponents: [MyComponent.self],
    ///     designSystemProvider: myDesignSystem,
    ///     debugMode: true
    /// )
    /// ScalsRendererView(document: doc, configuration: config)
    /// ```
    public init(
        document: Document.Definition,
        configuration: SwiftUIRendererConfiguration = SwiftUIRendererConfiguration()
    ) {
        // Set up custom components if provided
        if !configuration.customComponents.isEmpty {
            let customRegistry = CustomComponentRegistry()
            customRegistry.register(configuration.customComponents)
            configuration.componentRegistry.setCustomComponentRegistry(customRegistry)

            // Register the custom component SwiftUI renderer
            let customRenderer = CustomComponentSwiftUIRenderer(customComponentRegistry: customRegistry)
            configuration.rendererRegistry.register(customRenderer)
        }

        self.swiftuiRendererRegistry = configuration.rendererRegistry
        self.designSystemProvider = configuration.designSystemProvider

        // Resolve Document (AST) into RenderTree (IR)
        let layoutResolver = LayoutResolver(componentRegistry: configuration.componentRegistry)
        let sectionLayoutResolver = SectionLayoutResolver(componentRegistry: configuration.componentRegistry)
        let resolver = Resolver(
            document: document,
            componentRegistry: configuration.componentRegistry,
            actionResolverRegistry: configuration.actionResolverRegistry,
            layoutResolver: layoutResolver,
            sectionLayoutResolver: sectionLayoutResolver,
            designSystemProvider: configuration.designSystemProvider
        )
        let tree: RenderTree
        var capturedError: Error? = nil
        do {
            tree = try resolver.resolve()
        } catch {
            capturedError = error
            #if DEBUG
            print("[SCALS] Resolution failed - \(error)")
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

        // Print version and debug output if enabled
        if configuration.debugMode {
            Self.logVersionInfo(document: document, renderTree: tree)
            let debugRenderer = DebugRenderer()
            print(debugRenderer.render(tree))
        }

        // Create ActionResolver for runtime action resolution
        let actionResolver = ActionResolver(registry: configuration.actionResolverRegistry)

        // Create ActionContext with the resolved state store
        let ctx = ActionContext(
            stateStore: tree.stateStore,
            actionDefinitions: document.actions ?? [:],
            registry: configuration.actionRegistry,
            actionResolver: actionResolver,
            document: document,
            actionDelegate: configuration.actionDelegate
        )
        // Wrap in ObservableActionContext for SwiftUI integration
        _observableActionContext = StateObject(wrappedValue: ObservableActionContext(wrapping: ctx))
    }

    /// Initialize from a JSON string with configuration.
    ///
    /// - Parameters:
    ///   - jsonString: JSON string defining the document
    ///   - configuration: Configuration containing registries and settings
    ///
    /// Example:
    /// ```swift
    /// ScalsRendererView(jsonString: myJSON)
    /// ```
    public init?(
        jsonString: String,
        configuration: SwiftUIRendererConfiguration = SwiftUIRendererConfiguration()
    ) {
        do {
            let document = try Document.Definition(jsonString: jsonString)
            self.init(document: document, configuration: configuration)
        } catch {
            #if DEBUG
            print("[SCALS] JSON Parse Error:")
            print(DocumentParseError.detailedDescription(error: error, jsonString: jsonString))
            #endif
            return nil
        }
    }

    // Private initializer for creating modified copies
    private init(
        renderTree: RenderTree,
        observableActionContext: StateObject<ObservableActionContext>,
        swiftuiRendererRegistry: SwiftUINodeRendererRegistry,
        designSystemProvider: (any DesignSystemProvider)?,
        resolutionError: Error?,
        onStateChangeCallback: ((_ path: String, _ oldValue: Any?, _ newValue: Any?) -> Void)?,
        onActionWillExecuteCallback: ((String) -> Void)?,
        onActionDidExecuteCallback: ((String) -> Void)?,
        onDismissRequestCallback: (() -> Void)?,
        onNavigationRequestCallback: ((String, Document.NavigationPresentation?) -> Void)?,
        onAlertRequestCallback: ((AlertConfiguration) -> Void)?
    ) {
        self.renderTree = renderTree
        self._observableActionContext = observableActionContext
        self.swiftuiRendererRegistry = swiftuiRendererRegistry
        self.designSystemProvider = designSystemProvider
        #if DEBUG
        self.resolutionError = resolutionError
        #endif
        self.onStateChangeCallback = onStateChangeCallback
        self.onActionWillExecuteCallback = onActionWillExecuteCallback
        self.onActionDidExecuteCallback = onActionDidExecuteCallback
        self.onDismissRequestCallback = onDismissRequestCallback
        self.onNavigationRequestCallback = onNavigationRequestCallback
        self.onAlertRequestCallback = onAlertRequestCallback
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
                setupStateObservation()
            }
            .modifier(alertPresenter.modifier())
            .background(ViewControllerExtractor(onExtract: { viewController in
                // Update the presentation handler with extracted view controller
                presentationHandler?.setExtractedViewController(viewController)
            }))
    }

    private func setupContext() {
        // Create unified presentation handler
        let handler = SwiftUIPresentationHandler(
            dismissAction: dismissAction,
            alertPresenter: alertPresenter,
            extractedViewController: nil,
            navigationHandler: onNavigationRequestCallback ?? { destination, _ in
                print("ScalsRendererView: Navigation to '\(destination)' not implemented")
            },
            dismissCallback: onDismissRequestCallback,
            alertCallback: onAlertRequestCallback
        )

        // Store handler for view controller updates
        presentationHandler = handler

        // Inject unified handler
        observableActionContext.context.setPresenter(handler, for: PresenterKey.presentation)
    }

    private func setupStateObservation() {
        guard let callback = onStateChangeCallback else { return }
        _ = renderTree.stateStore.onStateChange { path, oldValue, newValue in
            callback(path, oldValue, newValue)
        }
    }

    // MARK: - Version Logging

    /// Logs version information for debugging
    private static func logVersionInfo(document: Document.Definition, renderTree: RenderTree) {
        print("----------------------------------------")
        print("SCALS Version Info")
        print("----------------------------------------")

        // Document version
        if let docVersion = document.version {
            print("   Document: v\(docVersion)")
        } else {
            print("   Document: [!] No version specified (defaulting to v0.1.0)")
        }

        // Renderer version
        print("   Renderer: v\(DocumentVersion.current.string)")

        // IR version
        print("   IR:       v\(renderTree.irVersion.string)")

        print("----------------------------------------")
    }
}

// MARK: - SwiftUI Observation Modifiers

extension ScalsRendererView {
    /// Called when any state value changes (untyped, with path info).
    ///
    /// Use this for analytics or debugging where you need the path.
    ///
    /// Example:
    /// ```swift
    /// ScalsRendererView(document: doc)
    ///     .onStateChange { path, old, new in
    ///         analytics.track("state_change", path: path)
    ///     }
    /// ```
    public func onStateChange(_ callback: @escaping (_ path: String, _ oldValue: Any?, _ newValue: Any?) -> Void) -> ScalsRendererView {
        var copy = self
        copy.onStateChangeCallback = callback
        return copy
    }

    /// Called when state changes, providing the new typed state.
    ///
    /// Use this when you want the full typed state object on each change.
    ///
    /// Example:
    /// ```swift
    /// ScalsRendererView(document: doc)
    ///     .onStateChange(MyState.self) { state in
    ///         print("New state: \(state.username)")
    ///     }
    /// ```
    public func onStateChange<T: Codable>(_ type: T.Type, _ callback: @escaping (T) -> Void) -> ScalsRendererView {
        onStateChange { _, _, _ in
            if let typedState = renderTree.stateStore.getTyped(type) {
                callback(typedState)
            }
        }
    }

    /// Called when an action is about to execute.
    ///
    /// Example:
    /// ```swift
    /// ScalsRendererView(document: doc)
    ///     .onActionWillExecute { actionId in
    ///         print("Executing: \(actionId)")
    ///     }
    /// ```
    public func onActionWillExecute(_ callback: @escaping (String) -> Void) -> ScalsRendererView {
        var copy = self
        copy.onActionWillExecuteCallback = callback
        return copy
    }

    /// Called when an action has finished executing.
    ///
    /// Example:
    /// ```swift
    /// ScalsRendererView(document: doc)
    ///     .onActionDidExecute { actionId in
    ///         print("Completed: \(actionId)")
    ///     }
    /// ```
    public func onActionDidExecute(_ callback: @escaping (String) -> Void) -> ScalsRendererView {
        var copy = self
        copy.onActionDidExecuteCallback = callback
        return copy
    }

    /// Called when dismiss is requested.
    ///
    /// Example:
    /// ```swift
    /// ScalsRendererView(document: doc)
    ///     .onDismissRequest {
    ///         isPresented = false
    ///     }
    /// ```
    public func onDismissRequest(_ callback: @escaping () -> Void) -> ScalsRendererView {
        var copy = self
        copy.onDismissRequestCallback = callback
        return copy
    }

    /// Called when navigation is requested.
    ///
    /// Example:
    /// ```swift
    /// ScalsRendererView(document: doc)
    ///     .onNavigationRequest { destination, presentation in
    ///         router.navigate(to: destination)
    ///     }
    /// ```
    public func onNavigationRequest(_ callback: @escaping (String, Document.NavigationPresentation?) -> Void) -> ScalsRendererView {
        var copy = self
        copy.onNavigationRequestCallback = callback
        return copy
    }

    /// Called when alert is requested.
    ///
    /// Example:
    /// ```swift
    /// ScalsRendererView(document: doc)
    ///     .onAlertRequest { config in
    ///         customAlertPresenter.present(config)
    ///     }
    /// ```
    public func onAlertRequest(_ callback: @escaping (AlertConfiguration) -> Void) -> ScalsRendererView {
        var copy = self
        copy.onAlertRequestCallback = callback
        return copy
    }

    /// Binds the renderer's internal state to an external typed Binding.
    ///
    /// Changes flow both ways: external -> internal and internal -> external.
    ///
    /// Example:
    /// ```swift
    /// @State private var myState = MyState()
    ///
    /// ScalsRendererView(document: doc)
    ///     .bindingState(to: $myState)
    /// ```
    public func bindingState<T: Codable & Equatable>(to binding: Binding<T>) -> some View {
        ScalsRendererBindingWrapper(
            rendererView: self,
            binding: binding,
            renderTree: renderTree
        )
    }
}

// MARK: - Binding Wrapper View

/// Internal wrapper for two-way state binding
private struct ScalsRendererBindingWrapper<T: Codable & Equatable>: View {
    let rendererView: ScalsRendererView
    @Binding var externalState: T
    let renderTree: RenderTree

    @State private var isUpdatingFromExternal = false
    @State private var stateCallbackId: UUID?

    init(rendererView: ScalsRendererView, binding: Binding<T>, renderTree: RenderTree) {
        self.rendererView = rendererView
        self._externalState = binding
        self.renderTree = renderTree
    }

    var body: some View {
        rendererView
            .onAppear {
                // Initial sync from external to internal
                renderTree.stateStore.setTyped(externalState)

                // Set up internal -> external sync
                stateCallbackId = renderTree.stateStore.onStateChange { _, _, _ in
                    guard !isUpdatingFromExternal else { return }
                    if let newState = renderTree.stateStore.getTyped(T.self) {
                        Task { @MainActor in
                            externalState = newState
                        }
                    }
                }
            }
            .onChange(of: externalState) { _, newValue in
                // External -> internal sync
                isUpdatingFromExternal = true
                renderTree.stateStore.setTyped(newValue)
                isUpdatingFromExternal = false
            }
            .onDisappear {
                if let id = stateCallbackId {
                    renderTree.stateStore.removeStateChangeCallback(id)
                }
            }
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

                        if error is ResolutionError {
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

// MARK: - View Controller Extraction Helper

#if canImport(UIKit)
/// Helper to extract the UIViewController from SwiftUI's view hierarchy.
struct ViewControllerExtractor: UIViewControllerRepresentable {
    let onExtract: (UIViewController?) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = ExtractorViewController()
        vc.onExtract = onExtract
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class ExtractorViewController: UIViewController {
        var onExtract: ((UIViewController?) -> Void)?

        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            onExtract?(parent)
        }
    }
}
#endif

// MARK: - Binding-based API (Legacy Support)

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

    /// Registry for action resolvers
    public var actionResolverRegistry: ActionResolverRegistry

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
        actionResolverRegistry: ActionResolverRegistry,
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
        self.actionResolverRegistry = actionResolverRegistry
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

    /// Initialize with CoreManifest registries
    public init(
        initialState: State? = nil,
        onStateChange: ((_ path: String, _ oldValue: Any?, _ newValue: Any?) -> Void)? = nil,
        onAction: ((_ actionId: String, _ parameters: [String: Any]) -> Void)? = nil,
        customActions: [String: ActionClosure] = [:],
        customComponents: [any CustomComponent.Type] = [],
        actionDelegate: ScalsActionDelegate? = nil,
        debugMode: Bool = false
    ) {
        // Create registries from CoreManifest
        let registries = CoreManifest.createRegistries()

        // Merge custom actions into the registry
        let actionRegistry = registries.actionRegistry.merging(customActions: customActions)

        self.init(
            initialState: initialState,
            onStateChange: onStateChange,
            onAction: onAction,
            actionRegistry: actionRegistry,
            actionResolverRegistry: registries.actionResolverRegistry,
            componentRegistry: registries.componentRegistry,
            swiftuiRendererRegistry: registries.swiftUIRegistry,
            customComponents: customComponents,
            actionDelegate: actionDelegate,
            debugMode: debugMode
        )
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

    /// Initialize with a document and state binding using default registries.
    public init(
        document: Document.Definition,
        state: Binding<State>
    ) {
        self.init(
            document: document,
            state: state,
            configuration: ScalsRendererBindingConfiguration()
        )
    }

    /// Initialize from a JSON string with state binding using default registries.
    public init?(
        jsonString: String,
        state: Binding<State>
    ) {
        guard let document = try? Document.Definition(jsonString: jsonString) else {
            return nil
        }
        self.init(document: document, state: state)
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
        // Create unified presentation handler for SwiftUI binding-based rendering
        let handler = SwiftUIPresentationHandler(
            dismissAction: dismiss,
            alertPresenter: SwiftUIAlertPresenter()
        )

        // Inject unified handler
        renderContext.actionContext.setPresenter(handler, for: PresenterKey.presentation)
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
        let layoutResolver = LayoutResolver(componentRegistry: configuration.componentRegistry)
        let sectionLayoutResolver = SectionLayoutResolver(componentRegistry: configuration.componentRegistry)
        let resolver = Resolver(
            document: document,
            componentRegistry: configuration.componentRegistry,
            actionResolverRegistry: configuration.actionResolverRegistry,
            layoutResolver: layoutResolver,
            sectionLayoutResolver: sectionLayoutResolver
        )
        let tree: RenderTree
        do {
            tree = try resolver.resolve()
        } catch {
            print("BindingRenderContext: Resolution failed - \(error)")
            tree = RenderTree(root: RootNode(), stateStore: StateStore(), actions: [:])
        }

        self.renderTree = tree
        self.stateStore = tree.stateStore

        // Create ActionResolver for runtime action resolution
        let actionResolver = ActionResolver(registry: configuration.actionResolverRegistry)

        // Create action context
        self._actionContext = ActionContext(
            stateStore: tree.stateStore,
            actionDefinitions: document.actions ?? [:],
            registry: configuration.actionRegistry,
            actionResolver: actionResolver,
            document: document,
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
