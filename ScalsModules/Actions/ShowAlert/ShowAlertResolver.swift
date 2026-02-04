//
//  ShowAlertResolver.swift
//  ScalsModules
//
//  Resolver for showAlert actions.
//

import SCALS

/// Resolves showAlert actions
public struct ShowAlertResolver: ActionResolving {
    public static let actionKind = Document.ActionKind.showAlert

    public init() {}

    public func resolve(
        _ action: Document.Action,
        context: ResolutionContext
    ) throws -> IR.ActionDefinition {
        var executionData: [String: AnySendable] = [:]

        // Extract title (required)
        let title = action.parameters["title"]?.stringValue ?? "Alert"
        executionData["title"] = AnySendable(title)

        // Extract message (optional, can be static or template)
        if let messageParam = action.parameters["message"] {
            if let messageString = messageParam.stringValue {
                // Simple string message
                executionData["message"] = AnySendable(messageString)
                executionData["messageIsTemplate"] = AnySendable(false)
            } else if let messageDict = messageParam.objectValue {
                // Template message: { "type": "binding", "template": "Hello ${name}" }
                if messageDict["type"]?.stringValue == "binding",
                   let template = messageDict["template"]?.stringValue {
                    executionData["message"] = AnySendable(template)
                    executionData["messageIsTemplate"] = AnySendable(true)
                } else {
                    executionData["message"] = AnySendable(messageDict.description)
                    executionData["messageIsTemplate"] = AnySendable(false)
                }
            }
        }

        // Extract buttons (optional) as array of dictionaries
        var buttonsArray: [[String: Any]] = []
        if let buttonsParam = action.parameters["buttons"]?.arrayValue {
            for buttonValue in buttonsParam {
                if let buttonDict = buttonValue.objectValue,
                   let label = buttonDict["label"]?.stringValue {
                    let styleString = buttonDict["style"]?.stringValue ?? "default"
                    let actionId = buttonDict["action"]?.stringValue

                    var buttonData: [String: Any] = [
                        "label": label,
                        "style": styleString
                    ]
                    if let actionId = actionId {
                        buttonData["action"] = actionId
                    }
                    buttonsArray.append(buttonData)
                }
            }
        }
        executionData["buttons"] = AnySendable(buttonsArray)

        return IR.ActionDefinition(
            kind: .showAlert,
            executionData: executionData
        )
    }
}
