//
//  SetStateResolver.swift
//  ScalsModules
//
//  Resolver for setState actions.
//

import SCALS

/// Resolves setState actions
public struct SetStateResolver: ActionResolving {
    public static let actionKind = Document.ActionKind.setState

    public init() {}

    public func resolve(
        _ action: Document.Action,
        context: ResolutionContext
    ) throws -> IR.ActionDefinition {
        // Extract path parameter
        guard let path = action.parameters["path"]?.stringValue else {
            throw ActionResolutionError.invalidParameters("setState requires 'path' parameter")
        }

        // Extract value parameter
        guard let valueParam = action.parameters["value"] else {
            throw ActionResolutionError.invalidParameters("setState requires 'value' parameter")
        }

        // Check if value is an expression or literal
        var executionData: [String: AnySendable] = ["path": AnySendable(path)]

        if let dict = valueParam.objectValue, let expr = dict["$expr"]?.stringValue {
            // Expression: { "$expr": "counter + 1" }
            // Store expression string for evaluation at execution time
            executionData["expression"] = AnySendable(expr)
        } else {
            // Literal value: unwrap StateValue to Any
            executionData["value"] = AnySendable(StateValueConverter.unwrap(valueParam))
        }

        return IR.ActionDefinition(
            kind: .setState,
            executionData: executionData
        )
    }
}
