//
//  SwiftUIPresentationHandler.swift
//  ScalsModules
//
//  SwiftUI-specific implementation of PresentationHandler.
//  Handles presentation using SwiftUI's Environment and UIViewController extraction.
//

import Foundation
import SwiftUI
import SafariServices
import SCALS

#if canImport(UIKit)
import UIKit
#endif

/// SwiftUI implementation of PresentationHandler
///
/// This implementation bridges SwiftUI's declarative presentation system with the imperative
/// presentation needs of the action system. It uses:
/// - SwiftUI's DismissAction for dismissal
/// - SwiftUIAlertPresenter for alerts (state-driven alerts)
/// - Extracted UIViewController for Safari and navigation (when UIKit is available)
///
/// **Design Philosophy:**
/// SwiftUI prefers declarative presentation, but actions are imperative by nature.
/// This handler bridges that gap by:
/// 1. Using SwiftUI's built-in mechanisms where possible (DismissAction, state-driven alerts)
/// 2. Falling back to UIKit for imperative needs (Safari, navigation)
@MainActor
public class SwiftUIPresentationHandler: PresentationHandler {
    /// SwiftUI's dismiss action
    private let dismissAction: DismissAction

    /// Alert presenter using SwiftUI state
    private let alertPresenter: SwiftUIAlertPresenter

    /// Optional extracted UIViewController for UIKit-based presentations
    private weak var extractedViewController: UIViewController?

    /// Navigation handler callback (optional, for custom navigation)
    private let navigationHandler: ((String, Document.NavigationPresentation?) -> Void)?

    /// Optional callback invoked before dismiss (for external observation)
    private let dismissCallback: (() -> Void)?

    /// Optional callback invoked before alert (for external observation)
    private let alertCallback: ((AlertConfiguration) -> Void)?

    public init(
        dismissAction: DismissAction,
        alertPresenter: SwiftUIAlertPresenter,
        extractedViewController: UIViewController? = nil,
        navigationHandler: ((String, Document.NavigationPresentation?) -> Void)? = nil,
        dismissCallback: (() -> Void)? = nil,
        alertCallback: ((AlertConfiguration) -> Void)? = nil
    ) {
        self.dismissAction = dismissAction
        self.alertPresenter = alertPresenter
        self.extractedViewController = extractedViewController
        self.navigationHandler = navigationHandler
        self.dismissCallback = dismissCallback
        self.alertCallback = alertCallback
    }

    /// Update the extracted view controller (called when ViewControllerExtractor provides one)
    public func setExtractedViewController(_ viewController: UIViewController?) {
        self.extractedViewController = viewController
    }

    // MARK: - PresentationHandler

    public func dismiss() {
        dismissCallback?()
        dismissAction()
    }

    public func presentAlert(_ config: AlertConfiguration) {
        alertCallback?(config)
        alertPresenter.present(config)
    }

    public func navigate(to destination: String, presentation: Document.NavigationPresentation?) {
        if let handler = navigationHandler {
            handler(destination, presentation)
        } else {
            print("SwiftUIPresentationHandler: Navigation to '\(destination)' not implemented")
        }
    }

    public func openURL(_ urlString: String) {
        #if canImport(UIKit)
        guard let url = URL(string: urlString) else {
            print("SwiftUIPresentationHandler: Invalid URL '\(urlString)'")
            return
        }

        guard let viewController = extractedViewController else {
            print("SwiftUIPresentationHandler: No view controller available for presenting Safari")
            return
        }

        let safari = SFSafariViewController(url: url)
        viewController.present(safari, animated: true)
        #else
        print("SwiftUIPresentationHandler: UIKit not available for opening URLs")
        #endif
    }
}
