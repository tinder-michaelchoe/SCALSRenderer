//
//  SequenceActionHandler.swift
//  ScalsModules
//
//  Handler for sequence actions.
//  Executes multiple actions in order by calling executeActionDefinition recursively.
//

import SCALS

/// Executes sequence actions
public struct SequenceActionHandler: ActionHandler {
    public static let actionKind = Document.ActionKind.sequence

    public init() {}

    @MainActor
    public func execute(definition: IR.ActionDefinition, context: ActionExecutionContext) async {
        do {
            // Extract steps array
            let steps: [IR.ActionDefinition] = try definition.requiredParameter("steps")

            // Execute each step sequentially
            for step in steps {
                await context.executeActionDefinition(step)
            }

        } catch {
            print("SequenceActionHandler error: \(error)")
        }
    }
}
