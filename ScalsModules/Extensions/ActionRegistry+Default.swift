//
//  ActionRegistry+Default.swift
//  ScalsModules
//
//  Provides the default ActionRegistry with all built-in actions registered.
//

import SCALS

extension ActionRegistry {
    /// A registry with all built-in actions registered
    public static var `default`: ActionRegistry {
        let registry = ActionRegistry()
        registry.registerBuiltInActions()
        return registry
    }

    /// Register all built-in action handlers
    public func registerBuiltInActions() {
        // Core action handlers (refactored to use new system)
        register(DismissActionHandler())
        register(SetStateActionHandler())
        register(ToggleStateActionHandler())
        register(ShowAlertActionHandler())
        register(SequenceActionHandler())
        register(NavigateActionHandler())

        // TODO: Additional action handlers not yet migrated to new system
        // - AppendToArrayActionHandler
        // - RemoveFromArrayActionHandler
        // - ToggleInArrayActionHandler
        // - SetArrayItemActionHandler
        // - ClearArrayActionHandler
        // - RequestActionHandler
        // - CancelRequestActionHandler
    }

    /// Alias for registerBuiltInActions for consistency with ActionResolverRegistry
    public func registerBuiltInHandlers() {
        registerBuiltInActions()
    }
}
