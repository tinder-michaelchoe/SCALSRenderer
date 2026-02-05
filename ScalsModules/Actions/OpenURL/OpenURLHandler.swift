//
//  OpenURLHandler.swift
//  ScalsModules
//
//  Handler for openURL actions.
//

import SCALS

/// Executes openURL actions
public struct OpenURLHandler: ActionHandler {
    public static let actionKind = Document.ActionKind.openURL

    public init() {}

    @MainActor
    public func execute(definition: IR.ActionDefinition, context: ActionExecutionContext) async {
        do {
            // Extract URL parameter (required)
            let urlString: String = try definition.requiredParameter("url")

            // Access unified presentation handler
            guard let handler: PresentationHandler = context.presenter(for: PresenterKey.presentation) else {
                print("OpenURLHandler: No presentation handler registered")
                return
            }
            handler.openURL(urlString)

        } catch {
            print("OpenURLHandler error: \(error)")
        }
    }
}
