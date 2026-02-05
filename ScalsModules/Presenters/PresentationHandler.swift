//
//  PresentationHandler.swift
//  ScalsModules
//
//  Unified protocol for all presentation actions (alerts, dismissal, navigation, URLs).
//  Platform-specific implementations handle SwiftUI vs UIKit differences.
//

import Foundation
import SCALS

// MARK: - Alert Configuration

/// Configuration for presenting an alert
public struct AlertConfiguration {
    public let title: String
    public let message: String?
    public let buttons: [Button]
    public let onButtonTap: ((String?) -> Void)?

    public struct Button {
        public let label: String
        public let style: Document.AlertButtonStyle
        public let action: String?

        public init(label: String, style: Document.AlertButtonStyle, action: String?) {
            self.label = label
            self.style = style
            self.action = action
        }
    }

    public init(
        title: String,
        message: String?,
        buttons: [Button],
        onButtonTap: ((String?) -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
        self.onButtonTap = onButtonTap
    }
}

// MARK: - Unified Presentation Handler

/// Unified protocol for all presentation actions.
///
/// This single protocol handles all presentation concerns: alerts, dismissal, navigation, and URL opening.
/// Platform-specific implementations (SwiftUI, UIKit) provide the actual presentation logic.
///
/// **Benefits:**
/// - Single injection point for all presentation capabilities
/// - Clear contract for what presentation actions are available
/// - Platform-specific implementations can share common logic
/// - Easy to mock for testing
///
/// **Usage:**
/// ```swift
/// // Register handler
/// context.setPresenter(myPresentationHandler, for: "presentation")
///
/// // Access in handler
/// guard let handler: PresentationHandler = context.presenter(for: "presentation") else {
///     return
/// }
/// handler.presentAlert(config)
/// ```
public protocol PresentationHandler: AnyObject {
    /// Dismiss the current view
    func dismiss()

    /// Present an alert with the given configuration
    func presentAlert(_ config: AlertConfiguration)

    /// Navigate to another destination
    /// - Parameters:
    ///   - destination: The destination identifier
    ///   - presentation: The presentation style (push, sheet, etc.)
    func navigate(to destination: String, presentation: Document.NavigationPresentation?)

    /// Open a URL (typically in Safari or external browser)
    /// - Parameter urlString: The URL string to open
    func openURL(_ urlString: String)
}
