//
//  UIKitDelegatePresentationHandler.swift
//  ScalsModules
//
//  Wrapper that combines individual delegate-based presenters into a unified handler.
//  This is used by ScalsUIKitView to maintain delegate-based architecture.
//

import Foundation
import SCALS

/// Unified presentation handler that delegates to individual presenters
///
/// This class wraps individual delegate-based presenters (UIKitDismissDelegatePresenter,
/// UIKitAlertDelegatePresenter, etc.) into a single PresentationHandler interface.
///
/// This is useful when you have existing individual presenters and want to adapt them
/// to the unified PresentationHandler interface without rewriting them.
class UIKitDelegatePresentationHandler: PresentationHandler {
    private let dismissPresenter: DismissPresenting
    private let alertPresenter: AlertPresenting
    private let navigationPresenter: NavigationPresenting
    private var urlPresenter: URLPresenting?

    init(
        dismissPresenter: DismissPresenting,
        alertPresenter: AlertPresenting,
        navigationPresenter: NavigationPresenting,
        urlPresenter: URLPresenting? = nil
    ) {
        self.dismissPresenter = dismissPresenter
        self.alertPresenter = alertPresenter
        self.navigationPresenter = navigationPresenter
        self.urlPresenter = urlPresenter
    }

    func dismiss() {
        dismissPresenter.dismiss()
    }

    func presentAlert(_ config: AlertConfiguration) {
        alertPresenter.present(config)
    }

    func navigate(to destination: String, presentation: Document.NavigationPresentation?) {
        navigationPresenter.navigate(to: destination, presentation: presentation)
    }

    func openURL(_ urlString: String) {
        if let urlPresenter = urlPresenter {
            urlPresenter.openURL(urlString)
        } else {
            print("UIKitDelegatePresentationHandler: No URL presenter configured")
        }
    }
}
