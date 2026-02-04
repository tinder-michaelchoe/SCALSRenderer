//
//  SetStateActionHandler.swift
//  ScalsModules
//
//  Handler for setState actions.
//

import SCALS

/// Executes setState actions
public struct SetStateActionHandler: ActionHandler {
    public static let actionKind = Document.ActionKind.setState

    public init() {}

    @MainActor
    public func execute(definition: IR.ActionDefinition, context: ActionExecutionContext) async {
        do {
            // Extract path parameter
            let path: String = try definition.requiredParameter("path")

            // Determine if value is an expression or literal by checking which key exists
            let finalValue: Any
            if let expression: String = definition.parameter("expression") {
                // Expression case: evaluate the expression string
                finalValue = context.stateStore.evaluate(expression: expression)
            } else {
                // Literal case: use the value directly
                finalValue = try definition.requiredParameter("value")
            }

            // Update state
            context.stateStore.set(path, value: finalValue)

        } catch {
            print("SetStateActionHandler error: \(error)")
        }
    }
}
