//
//  ScalsUIKitView+Convenience.swift
//  ScalsModules
//
//  Convenience initializers for ScalsUIKitView and ScalsViewController that use CoreManifest.
//  Custom actions are merged into the action registry internally.
//

import SCALS
import UIKit

extension ScalsUIKitView {
    /// Initialize with a document using CoreManifest.
    ///
    /// - Parameters:
    ///   - document: The document definition to render
    ///   - customActions: View-specific action closures, keyed by action ID
    ///   - actionDelegate: Delegate for handling custom actions
    ///
    /// Example:
    /// ```swift
    /// let view = ScalsUIKitView(document: document)
    ///
    /// // With custom actions
    /// let view = ScalsUIKitView(
    ///     document: document,
    ///     customActions: [
    ///         "submitOrder": { params, context in
    ///             await OrderService.submit(orderId)
    ///         }
    ///     ]
    /// )
    /// ```
    public convenience init(
        document: Document.Definition,
        customActions: [String: ActionClosure] = [:],
        actionDelegate: ScalsActionDelegate? = nil
    ) {
        // Create registries from CoreManifest
        let registries = CoreManifest.createRegistries()

        // Merge custom actions into the registry
        let actionRegistry = registries.actionRegistry.merging(customActions: customActions)

        self.init(
            document: document,
            actionRegistry: actionRegistry,
            actionResolverRegistry: registries.actionResolverRegistry,
            componentRegistry: registries.componentRegistry,
            rendererRegistry: registries.uiKitRegistry,
            actionDelegate: actionDelegate
        )
    }

    /// Initialize from a JSON string using CoreManifest.
    public convenience init?(
        jsonString: String,
        customActions: [String: ActionClosure] = [:],
        actionDelegate: ScalsActionDelegate? = nil
    ) {
        guard let document = try? Document.Definition(jsonString: jsonString) else {
            return nil
        }

        // Create registries from CoreManifest
        let registries = CoreManifest.createRegistries()

        // Merge custom actions into the registry
        let actionRegistry = registries.actionRegistry.merging(customActions: customActions)

        self.init(
            document: document,
            actionRegistry: actionRegistry,
            actionResolverRegistry: registries.actionResolverRegistry,
            componentRegistry: registries.componentRegistry,
            rendererRegistry: registries.uiKitRegistry,
            actionDelegate: actionDelegate
        )
    }
}

// MARK: - ScalsViewController Convenience

extension ScalsViewController {
    /// Initialize with a document using CoreManifest.
    public convenience init(document: Document.Definition) {
        // Create registries from CoreManifest
        let registries = CoreManifest.createRegistries()

        self.init(
            document: document,
            actionRegistry: registries.actionRegistry,
            actionResolverRegistry: registries.actionResolverRegistry,
            componentRegistry: registries.componentRegistry,
            rendererRegistry: registries.uiKitRegistry
        )
    }

    /// Initialize from a JSON string using CoreManifest.
    public convenience init?(jsonString: String) {
        // Create registries from CoreManifest
        let registries = CoreManifest.createRegistries()

        self.init(
            jsonString: jsonString,
            actionRegistry: registries.actionRegistry,
            actionResolverRegistry: registries.actionResolverRegistry,
            componentRegistry: registries.componentRegistry,
            rendererRegistry: registries.uiKitRegistry
        )
    }
}
