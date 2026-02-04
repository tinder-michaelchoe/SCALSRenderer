//
//  NavigateResolver.swift
//  ScalsModules
//
//  Resolver for navigate actions.
//

import SCALS

/// Resolves navigate actions
public struct NavigateResolver: ActionResolving {
    public static let actionKind = Document.ActionKind.navigate

    public init() {}

    public func resolve(
        _ action: Document.Action,
        context: ResolutionContext
    ) throws -> IR.ActionDefinition {
        // Extract destination parameter
        guard let destination = action.parameters["destination"]?.stringValue else {
            throw ActionResolutionError.invalidParameters("navigate requires 'destination' parameter")
        }

        // Extract optional presentation parameter
        var presentation: Document.NavigationPresentation? = nil
        if let presentationString = action.parameters["presentation"]?.stringValue {
            presentation = Document.NavigationPresentation(rawValue: presentationString)
        }

        return IR.ActionDefinition(
            kind: .navigate,
            executionData: [
                "destination": AnySendable(destination),
                "presentation": AnySendable(presentation as Any)
            ]
        )
    }
}
