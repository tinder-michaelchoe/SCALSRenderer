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
        // Access unified presentation handler
        guard let handler: PresentationHandler = context.presenter(for: PresenterKey.presentation) else {
            print("DismissHandler: No presentation handler registered")
            return
        }
        handler.dismiss()
    }
}
