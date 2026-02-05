//
//  ShowAlertHandler.swift
//  ScalsModules
//
//  Handler for showAlert actions.
//

import SCALS

/// Executes showAlert actions
public struct ShowAlertHandler: ActionHandler {
    public static let actionKind = Document.ActionKind.showAlert

    public init() {}

    @MainActor
    public func execute(definition: IR.ActionDefinition, context: ActionExecutionContext) async {
        do {
            // Extract title (required)
            let title: String = try definition.requiredParameter("title")

            // Extract message (optional)
            let messageString: String? = definition.parameter("message")
            let isTemplate: Bool = definition.parameter("messageIsTemplate") ?? false

            // Resolve message (interpolate if template)
            let message: String?
            if let messageString = messageString {
                message = isTemplate ? context.stateStore.interpolate(messageString) : messageString
            } else {
                message = nil
            }

            // Extract buttons as array of dictionaries
            let buttonsData: [[String: Any]] = definition.parameter("buttons") ?? []

            // Convert button dictionaries to AlertConfiguration.Button
            let buttons = buttonsData.compactMap { buttonDict -> AlertConfiguration.Button? in
                guard let label = buttonDict["label"] as? String else { return nil }

                let styleString = buttonDict["style"] as? String ?? "default"
                let style = Document.AlertButtonStyle(rawValue: styleString) ?? .default
                let actionId = buttonDict["action"] as? String

                return AlertConfiguration.Button(label: label, style: style, action: actionId)
            }

            // Create alert configuration
            let alertConfig = AlertConfiguration(
                title: title,
                message: message,
                buttons: buttons.isEmpty ? [AlertConfiguration.Button(label: "OK", style: .default, action: nil)] : buttons,
                onButtonTap: { [weak context] actionId in
                    if let actionId = actionId, let context = context {
                        Task { @MainActor in
                            await context.executeAction(id: actionId)
                        }
                    }
                }
            )

            // Access unified presentation handler
            guard let handler: PresentationHandler = context.presenter(for: PresenterKey.presentation) else {
                print("ShowAlertHandler: No presentation handler registered")
                return
            }
            handler.presentAlert(alertConfig)

        } catch {
            print("ShowAlertHandler error: \(error)")
        }
    }
}
