//
//  ToggleStateResolver.swift
//  ScalsModules
//
//  Resolver for toggleState actions.
//

import SCALS

/// Resolves toggleState actions
public struct ToggleStateResolver: ActionResolving {
    public static let actionKind = Document.ActionKind.toggleState

    public init() {}

    public func resolve(
        _ action: Document.Action,
        context: ResolutionContext
    ) throws -> IR.ActionDefinition {
        // Extract path parameter
        guard let path = action.parameters["path"]?.stringValue else {
            throw ActionResolutionError.invalidParameters("toggleState requires 'path' parameter")
        }

        return IR.ActionDefinition(
            kind: .toggleState,
            executionData: [
                "path": AnySendable(path)
            ]
        )
    }
}
