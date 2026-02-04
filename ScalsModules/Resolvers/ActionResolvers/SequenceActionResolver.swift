//
//  SequenceActionResolver.swift
//  ScalsModules
//
//  Resolver for sequence actions.
//  This resolver requires an ActionResolverRegistry to recursively resolve nested actions.
//

import SCALS

/// Resolves sequence actions (executes multiple actions in order)
public struct SequenceActionResolver: ActionResolving {
    public static let actionKind = Document.ActionKind.sequence

    private let registry: ActionResolverRegistry

    /// Initialize with an action resolver registry for recursive resolution
    /// - Parameter registry: The registry to use for resolving nested actions
    public init(registry: ActionResolverRegistry) {
        self.registry = registry
    }

    public func resolve(
        _ action: Document.Action,
        context: ResolutionContext
    ) throws -> IR.ActionDefinition {
        // Extract steps parameter
        guard let stepsParam = action.parameters["steps"]?.arrayValue else {
            throw ActionResolutionError.invalidParameters("sequence requires 'steps' array parameter")
        }

        // Resolve each nested action recursively
        var resolvedSteps: [IR.ActionDefinition] = []
        for stepValue in stepsParam {
            // Each step should be an object with a "type" field and parameters
            guard let stepDict = stepValue.objectValue else {
                throw ActionResolutionError.invalidParameters("Each step in sequence must be an object")
            }

            guard let typeString = stepDict["type"]?.stringValue else {
                throw ActionResolutionError.invalidParameters("Each step in sequence must have a 'type' field")
            }

            // Build parameters dict (all fields except "type")
            var parameters: [String: Document.StateValue] = [:]
            for (key, value) in stepDict where key != "type" {
                parameters[key] = value
            }

            // Create Document.Action for this step
            let stepAction = Document.Action(
                type: Document.ActionKind(rawValue: typeString),
                parameters: parameters
            )

            // Recursively resolve this action
            let resolvedStep = try registry.resolve(stepAction, context: context)
            resolvedSteps.append(resolvedStep)
        }

        return IR.ActionDefinition(
            kind: .sequence,
            executionData: [
                "steps": AnySendable(resolvedSteps)
            ]
        )
    }
}
