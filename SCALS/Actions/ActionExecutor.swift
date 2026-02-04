//
//  ActionExecutor.swift
//  ScalsRendererFramework
//
//  Platform-agnostic action execution context.
//  UIKit-specific alert presentation is handled via the AlertPresenting protocol.
//

import Foundation

/// Context for action execution, providing access to state and navigation.
///
/// **Platform-Agnostic**: This class does not depend on SwiftUI, UIKit, or Combine.
/// Alert presentation is delegated to an `AlertPresenting` implementation.
/// For SwiftUI integration, use `ObservableActionContext` wrapper.
public final class ActionContext: ActionExecutionContext {
    public let stateStore: StateStoring
    public let documentId: String
    public let actionRegistry: ActionRegistry
    private let actionDefinitions: [String: Document.Action]
    private let actionResolver: ActionResolver
    private let document: Document.Definition

    /// Presenters for platform-specific view operations (injectable for testing)
    /// These can be set after initialization for SwiftUI @Environment dependencies
    public var dismissPresenter: DismissPresenting?
    public var navigationPresenter: NavigationPresenting?
    public var alertPresenter: AlertPresenting?

    /// Delegate for handling custom actions
    public weak var actionDelegate: ScalsActionDelegate?

    public init(
        stateStore: StateStoring,
        actionDefinitions: [String: Document.Action],
        registry: ActionRegistry,
        actionResolver: ActionResolver,
        document: Document.Definition,
        documentId: String = UUID().uuidString,
        actionDelegate: ScalsActionDelegate? = nil,
        dismissPresenter: DismissPresenting? = nil,
        navigationPresenter: NavigationPresenting? = nil,
        alertPresenter: AlertPresenting? = nil
    ) {
        self.stateStore = stateStore
        self.actionDefinitions = actionDefinitions
        self.actionRegistry = registry
        self.actionResolver = actionResolver
        self.document = document
        self.documentId = documentId
        self.actionDelegate = actionDelegate
        // Presenters can be set after initialization for SwiftUI @Environment dependencies
        self.dismissPresenter = dismissPresenter
        self.navigationPresenter = navigationPresenter
        self.alertPresenter = alertPresenter
    }

    // MARK: - ActionExecutionContext

    /// Execute an action by its ID.
    ///
    /// Resolution order:
    /// 1. Document action definitions (to get type + parameters)
    /// 2. Action delegate (for intercepting, with parameters)
    /// 3. Execute the action
    ///
    /// The action definition determines the action type and parameters,
    /// which are then passed to `executeAction(type:parameters:)` for registry lookup.
    public func executeAction(id actionId: String) async {
        // 1. Look up action definition to get type + parameters
        guard let action = actionDefinitions[actionId] else {
            print("ActionContext: Unknown action '\(actionId)'")
            return
        }

        // 2. Check delegate (for intercepting, with parameters extracted from action)
        if let delegate = actionDelegate {
            let parameters = extractParameters(from: action)
            let handled = await delegate.scalsRenderer(
                handleAction: actionId,
                parameters: parameters,
                context: self
            )
            if handled { return }
        }

        // 3. Execute the action
        await executeAction(action)
    }

    /// Extract parameters from an action for delegate calls
    private func extractParameters(from action: Document.Action) -> ActionParameters {
        return ActionParameters(raw: action.parameters.mapValues { stateValueToAny($0) })
    }

    /// Execute a typed Action directly
    /// Resolves the Document.Action to IR.ActionDefinition, then executes it.
    public func executeAction(_ action: Document.Action) async {
        do {
            // Cast StateStoring to concrete StateStore for resolution context
            guard let concreteStore = stateStore as? StateStore else {
                print("ActionContext: stateStore must be a StateStore instance for resolution")
                return
            }

            // Create resolution context
            let context = ResolutionContext.withoutTracking(
                document: document,
                stateStore: concreteStore,
                designSystemProvider: nil
            )

            // Resolve Document.Action → IR.ActionDefinition
            let resolved = try actionResolver.resolve(action, context: context)

            // Execute the resolved action
            await executeActionDefinition(resolved)
        } catch {
            print("ActionContext: Failed to resolve/execute action - \(error)")
        }
    }

    /// Execute an action directly by type and parameters.
    ///
    /// Resolution order:
    /// 1. Registry handlers (includes custom actions wrapped as ClosureActionHandler)
    /// 2. Action delegate
    public func executeAction(type actionType: String, parameters: ActionParameters) async {
        // Create a minimal IR.ActionDefinition for backward compatibility
        let actionKind = Document.ActionKind(rawValue: actionType)
        var executionData: [String: AnySendable] = [:]
        for (key, value) in parameters.raw {
            executionData[key] = AnySendable(value)
        }
        let definition = IR.ActionDefinition(kind: actionKind, executionData: executionData)

        await executeActionDefinition(definition)
    }

    /// Execute a resolved action definition
    /// - Parameter definition: The resolved IR action definition to execute
    public func executeActionDefinition(_ definition: IR.ActionDefinition) async {
        // NO SWITCH STATEMENT - delegate ALL actions to the registry
        if let handler = actionRegistry.handler(for: definition.kind.rawValue) {
            await handler.execute(definition: definition, context: self)
            return
        }

        // Fallback to delegate
        if let delegate = actionDelegate {
            var rawParams: [String: Any] = [:]
            for (key, wrapper) in definition.executionData {
                rawParams[key] = wrapper.value
            }
            let parameters = ActionParameters(raw: rawParams)
            let handled = await delegate.scalsRenderer(
                handleAction: definition.kind.rawValue,
                parameters: parameters,
                context: self
            )
            if handled { return }
        }

        print("ActionContext: No handler registered for action kind '\(definition.kind.rawValue)'")
    }

    // MARK: - Utility Methods

    private func stateValueToAny(_ value: Document.StateValue) -> Any {
        switch value {
        case .intValue(let v): return v
        case .doubleValue(let v): return v
        case .stringValue(let v): return v
        case .boolValue(let v): return v
        case .nullValue: return NSNull()
        case .arrayValue(let arr): return arr.map { stateValueToAny($0) }
        case .objectValue(let obj): return obj.mapValues { stateValueToAny($0) }
        }
    }

    /// Dismiss the current view
    public func dismiss() {
        dismissPresenter?.dismiss()
    }

    /// Present an alert using the injected alert presenter
    public func presentAlert(_ config: AlertConfiguration) {
        alertPresenter?.present(config)
    }

    /// Navigate to another view
    public func navigate(to destination: String, presentation: Document.NavigationPresentation?) {
        navigationPresenter?.navigate(to: destination, presentation: presentation)
    }

    // MARK: - Convenience Execution

    /// Execute an action binding (either reference or inline)
    public func execute(_ binding: Document.Component.ActionBinding) {
        Task {
            switch binding {
            case .reference(let actionId):
                await executeAction(id: actionId)
            case .inline(let action):
                await executeAction(action)
            }
        }
    }

    /// Execute an action by its ID (convenience for button taps, etc.)
    public func execute(_ actionId: String) {
        Task {
            await executeAction(id: actionId)
        }
    }
}

/// Configuration for presenting an alert
public struct AlertConfiguration {
    public let title: String
    public let message: String?
    public let buttons: [Button]
    public let onButtonTap: ((String?) -> Void)?

    public struct Button {
        public let label: String
        public let style: Document.AlertButtonStyle
        public let action: String?

        public init(label: String, style: Document.AlertButtonStyle, action: String?) {
            self.label = label
            self.style = style
            self.action = action
        }
    }

    public init(
        title: String,
        message: String?,
        buttons: [Button],
        onButtonTap: ((String?) -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
        self.onButtonTap = onButtonTap
    }
}

// MARK: - Alert Presenting Protocol

/// Protocol for presenting alerts, enabling dependency injection for testing.
///
/// **Platform-Agnostic**: This protocol does not depend on UIKit or SwiftUI.
/// Platform-specific implementations (like `UIKitAlertPresenter`) are in the renderer layer.
///
/// Example test usage:
/// ```swift
/// class MockAlertPresenter: AlertPresenting {
///     var presentedAlerts: [AlertConfiguration] = []
///     func present(_ config: AlertConfiguration) {
///         presentedAlerts.append(config)
///     }
/// }
///
/// let mockPresenter = MockAlertPresenter()
/// let context = ActionContext(stateStore: store, alertPresenter: mockPresenter, ...)
/// // ... trigger action ...
/// XCTAssertEqual(mockPresenter.presentedAlerts.count, 1)
/// ```
public protocol AlertPresenting: AnyObject {
    func present(_ config: AlertConfiguration)
}

// MARK: - Dismiss Presenting Protocol

/// Protocol for dismissing views, enabling dependency injection for testing.
///
/// **Platform-Agnostic**: This protocol does not depend on UIKit or SwiftUI.
/// Platform-specific implementations are in the renderer layer.
///
/// Example test usage:
/// ```swift
/// class MockDismissPresenter: DismissPresenting {
///     var dismissCalled = false
///     func dismiss() {
///         dismissCalled = true
///     }
/// }
/// ```
public protocol DismissPresenting: AnyObject {
    func dismiss()
}

// MARK: - Navigation Presenting Protocol

/// Protocol for navigation, enabling dependency injection for testing.
///
/// **Platform-Agnostic**: This protocol does not depend on UIKit or SwiftUI.
/// Platform-specific implementations are in the renderer layer.
///
/// Example test usage:
/// ```swift
/// class MockNavigationPresenter: NavigationPresenting {
///     var navigatedDestination: String?
///     func navigate(to destination: String, presentation: Document.NavigationPresentation?) {
///         navigatedDestination = destination
///     }
/// }
/// ```
public protocol NavigationPresenting: AnyObject {
    func navigate(to destination: String, presentation: Document.NavigationPresentation?)
}
