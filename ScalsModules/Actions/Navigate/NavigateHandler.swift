//
//  NavigateHandler.swift
//  ScalsModules
//
//  Handler for navigate actions.
//

import SCALS

/// Executes navigate actions
public struct NavigateHandler: ActionHandler {
    public static let actionKind = Document.ActionKind.navigate

    public init() {}

    @MainActor
    public func execute(definition: IR.ActionDefinition, context: ActionExecutionContext) async {
        do {
            // Extract parameters
            let destination: String = try definition.requiredParameter("destination")
            let presentation: Document.NavigationPresentation? = definition.parameter("presentation")

            // Navigate
            context.navigate(to: destination, presentation: presentation)

        } catch {
            print("NavigateHandler error: \(error)")
        }
    }
}
