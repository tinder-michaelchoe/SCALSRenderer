//
//  UIKitPresentationHandler.swift
//  ScalsModules
//
//  UIKit-specific implementation of PresentationHandler.
//  Handles presentation using UIKit's imperative presentation APIs.
//

import Foundation
import SafariServices
import SCALS

#if canImport(UIKit)
import UIKit

/// UIKit implementation of PresentationHandler
///
/// This implementation uses UIKit's imperative presentation system directly.
/// All presentations are performed through the provided UIViewController.
///
/// **Design:**
/// - Holds weak reference to presenting view controller
/// - Uses standard UIKit presentation APIs
/// - Converts platform-agnostic configs to UIKit equivalents
public class UIKitPresentationHandler: PresentationHandler {
    /// The view controller that will present content
    weak var viewController: UIViewController?

    public init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    // MARK: - PresentationHandler

    public func dismiss() {
        viewController?.dismiss(animated: true)
    }

    public func presentAlert(_ config: AlertConfiguration) {
        guard let viewController = viewController else {
            print("UIKitPresentationHandler: No view controller available for alert")
            return
        }

        let alert = UIAlertController(
            title: config.title,
            message: config.message,
            preferredStyle: .alert
        )

        for button in config.buttons {
            let style: UIAlertAction.Style
            switch button.style {
            case .default:
                style = .default
            case .cancel:
                style = .cancel
            case .destructive:
                style = .destructive
            }

            let action = UIAlertAction(title: button.label, style: style) { _ in
                config.onButtonTap?(button.action)
            }
            alert.addAction(action)
        }

        viewController.present(alert, animated: true)
    }

    public func navigate(to destination: String, presentation: Document.NavigationPresentation?) {
        print("UIKitPresentationHandler: Navigation to '\(destination)' not implemented")
        // Implementation would depend on app's navigation architecture
        // Could delegate to a navigation coordinator, push on nav stack, etc.
    }

    public func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("UIKitPresentationHandler: Invalid URL '\(urlString)'")
            return
        }

        guard let viewController = viewController else {
            print("UIKitPresentationHandler: No view controller available for presenting Safari")
            return
        }

        let safari = SFSafariViewController(url: url)
        viewController.present(safari, animated: true)
    }
}

#endif
