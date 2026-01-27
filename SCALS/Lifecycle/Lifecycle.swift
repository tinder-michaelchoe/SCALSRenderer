//
//  Lifecycle.swift
//  ScalsRendererFramework
//
//  Lifecycle action handling for ScalsRenderer views.
//

import Foundation

// MARK: - Lifecycle Actions (IR)

/// Container for lifecycle action bindings (IR layer).
///
/// Parsed from the document's `root.actions` and used by `LifecycleModifier`
/// to execute actions at the appropriate lifecycle points.
public struct LifecycleActions {

    // MARK: - Lifecycle Event

    /// Supported lifecycle events for ScalsRenderer views.
    ///
    /// To add a new event:
    /// 1. Add a case here
    /// 2. Add the corresponding modifier in `LifecycleModifier`
    public enum LifecycleEvent: String, CaseIterable {
        /// Triggered when the view appears on screen
        case onAppear

        /// Triggered when the view disappears from screen
        case onDisappear

        // Future events:
        // case onForeground
        // case onBackground
    }

    // MARK: - Properties and Initialization

    private var actions: [LifecycleEvent: Document.Component.ActionBinding] = [:]

    /// Create empty lifecycle actions
    public init() {}

    /// Create lifecycle actions from document lifecycle actions
    public init(from documentActions: Document.LifecycleActions?) {
        guard let documentActions = documentActions else { return }

        if let onAppear = documentActions.onAppear {
            actions[.onAppear] = onAppear
        }
        if let onDisappear = documentActions.onDisappear {
            actions[.onDisappear] = onDisappear
        }
    }

    // MARK: - Public Methods

    /// Get the action binding for a specific event
    public func action(for event: LifecycleEvent) -> Document.Component.ActionBinding? {
        actions[event]
    }

    /// Check if any actions are defined
    public var isEmpty: Bool {
        actions.isEmpty
    }

    /// All events that have actions defined
    public var definedEvents: [LifecycleEvent] {
        Array(actions.keys)
    }
}
