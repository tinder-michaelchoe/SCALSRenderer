//
//  DismissHandler.swift
//  ScalsModules
//
//  Handler for dismiss actions.
//

import SCALS

/// Executes dismiss actions
public struct DismissHandler: ActionHandler {
    public static let actionKind = Document.ActionKind.dismiss

    public init() {}

    @MainActor
    public func execute(definition: IR.ActionDefinition, context: ActionExecutionContext) async {
        // Dismiss the current view
        context.dismiss()
    }
}
