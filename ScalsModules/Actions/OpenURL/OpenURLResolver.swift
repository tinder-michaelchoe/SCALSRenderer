//
//  OpenURLResolver.swift
//  ScalsModules
//
//  Resolver for openURL actions.
//

import SCALS

/// Resolves openURL actions
public struct OpenURLResolver: ActionResolving {
    public static let actionKind = Document.ActionKind.openURL

    public init() {}

    public func resolve(
        _ action: Document.Action,
        context: ResolutionContext
    ) throws -> IR.ActionDefinition {
        // Extract URL parameter (required)
        guard let url = action.parameters["url"]?.stringValue else {
            throw ActionResolutionError.invalidParameters("openURL requires 'url' parameter")
        }

        var executionData: [String: AnySendable] = [:]
        executionData["url"] = AnySendable(url)

        return IR.ActionDefinition(
            kind: .openURL,
            executionData: executionData
        )
    }
}
