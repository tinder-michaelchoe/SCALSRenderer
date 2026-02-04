//
//  ActionResolverRegistry+Default.swift
//  ScalsModules
//
//  Default registration of built-in action resolvers.
//

import SCALS

extension ActionResolverRegistry {
    /// Creates a registry with all built-in action resolvers pre-registered
    public static var `default`: ActionResolverRegistry {
        let registry = ActionResolverRegistry()
        registry.registerBuiltInResolvers()
        return registry
    }

    /// Register all built-in action resolvers
    public func registerBuiltInResolvers() {
        // Register all 6 built-in resolvers
        register(DismissActionResolver())
        register(SetStateActionResolver())
        register(ToggleStateActionResolver())
        register(ShowAlertActionResolver())
        register(NavigateActionResolver())

        // Sequence resolver needs the registry for recursive resolution
        register(SequenceActionResolver(registry: self))
    }
}
