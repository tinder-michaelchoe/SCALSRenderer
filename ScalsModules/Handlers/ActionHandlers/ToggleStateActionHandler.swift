//
//  ToggleStateActionHandler.swift
//  ScalsModules
//
//  Handler for toggleState actions.
//

import SCALS

/// Executes toggleState actions
public struct ToggleStateActionHandler: ActionHandler {
    public static let actionKind = Document.ActionKind.toggleState

    public init() {}

    @MainActor
    public func execute(definition: IR.ActionDefinition, context: ActionExecutionContext) async {
        do {
            // Extract path
            let path: String = try definition.requiredParameter("path")

            // Read current value
            let currentValue = context.stateStore.get(path) as? Bool ?? false

            // Toggle and update
            context.stateStore.set(path, value: !currentValue)

        } catch {
            print("ToggleStateActionHandler error: \(error)")
        }
    }
}
