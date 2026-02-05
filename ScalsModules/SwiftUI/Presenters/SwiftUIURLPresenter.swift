//
//  SwiftUIURLPresenter.swift
//  ScalsModules
//
//  SwiftUI-specific implementation of URLPresenting.
//

import SwiftUI
import SafariServices
import SCALS

/// SwiftUI implementation of URL presentation.
///
/// Uses SFSafariViewController to open URLs in an in-app browser.
///
/// Usage:
/// ```swift
/// let presenter = SwiftUIURLPresenter()
/// let context = ActionContext(..., urlPresenter: presenter, ...)
/// ```
@MainActor
public final class SwiftUIURLPresenter: URLPresenting {
    private weak var presentingViewController: UIViewController?

    public init() {}

    /// Set the presenting view controller (called from ScalsRendererView)
    public func setPresentingViewController(_ viewController: UIViewController?) {
        self.presentingViewController = viewController
    }

    public func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("SwiftUIURLPresenter: Invalid URL string: \(urlString)")
            return
        }

        guard let presentingVC = findPresentingViewController() else {
            print("SwiftUIURLPresenter: No presenting view controller available, opening in external browser")
            // Fallback to opening in external browser
            #if canImport(UIKit)
            UIApplication.shared.open(url)
            #endif
            return
        }

        // Open in Safari View Controller
        let safariVC = SFSafariViewController(url: url)
        presentingVC.present(safariVC, animated: true)
    }

    private func findPresentingViewController() -> UIViewController? {
        if let presentingVC = presentingViewController {
            return presentingVC
        }

        // Fallback: find the root view controller
        #if canImport(UIKit)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            return findTopmostViewController(from: rootVC)
        }
        #endif

        return nil
    }

    private func findTopmostViewController(from viewController: UIViewController) -> UIViewController {
        if let presented = viewController.presentedViewController {
            return findTopmostViewController(from: presented)
        }
        if let navigationController = viewController as? UINavigationController,
           let topVC = navigationController.topViewController {
            return findTopmostViewController(from: topVC)
        }
        if let tabBarController = viewController as? UITabBarController,
           let selectedVC = tabBarController.selectedViewController {
            return findTopmostViewController(from: selectedVC)
        }
        return viewController
    }
}
