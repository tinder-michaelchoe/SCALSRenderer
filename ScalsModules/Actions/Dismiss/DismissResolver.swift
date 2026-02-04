//
//  DismissResolver.swift
//  ScalsModules
//
//  Resolver for dismiss actions.
//

import SCALS

/// Resolves dismiss actions (no parameters needed)
public struct DismissResolver: ActionResolving {
    public static let actionKind = Document.ActionKind.dismiss

    public init() {}

    public func resolve(
        _ action: Document.Action,
        context: ResolutionContext
    ) throws -> IR.ActionDefinition {
        // Dismiss has no parameters
        return IR.ActionDefinition(
            kind: .dismiss,
            executionData: [:]
        )
    }
}
