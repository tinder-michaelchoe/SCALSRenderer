//
//  SequenceHandler.swift
//  ScalsModules
//
//  Handler for sequence actions.
//  Executes multiple actions in order by calling executeActionDefinition recursively.
//

import SCALS

/// Executes sequence actions
public struct SequenceHandler: ActionHandler {
    public static let actionKind = Document.ActionKind.sequence

    public init() {}

    @MainActor
    public func execute(definition: IR.ActionDefinition, context: ActionExecutionContext) async {
        // Extract steps array - handle both direct array and Any-wrapped array
        guard let stepsWrapper = definition.executionData["steps"] else {
            print("SequenceHandler error: Missing 'steps' parameter")
            return
        }

        let steps: [IR.ActionDefinition]

        // Try direct cast first
        if let directSteps = stepsWrapper.value as? [IR.ActionDefinition] {
            steps = directSteps
        }
        // If that fails, try casting each element individually (handles [Any] case)
        else if let anyArray = stepsWrapper.value as? [Any] {
            steps = anyArray.compactMap { $0 as? IR.ActionDefinition }
            if steps.count != anyArray.count {
                print("SequenceHandler warning: Some steps could not be cast to ActionDefinition")
            }
        } else {
            print("SequenceHandler error: 'steps' is not an array")
            return
        }

        // Execute each step sequentially
        for step in steps {
            await context.executeActionDefinition(step)
        }
    }
}
