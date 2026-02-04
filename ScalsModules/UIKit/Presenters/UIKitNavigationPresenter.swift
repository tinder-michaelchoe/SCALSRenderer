//
//  UIKitNavigationPresenter.swift
//  ScalsModules
//
//  UIKit-specific implementation of NavigationPresenting.
//

import UIKit
import SCALS

/// UIKit implementation of navigation presentation.
///
/// Navigation in UIKit can be implemented in various ways (UINavigationController push/pop,
/// modal presentation, etc.). This presenter uses a closure-based approach to allow
/// flexibility in how navigation is handled, typically through a delegate pattern.
///
/// Usage:
/// ```swift
/// let presenter = UIKitNavigationPresenter { destination, presentation in
///     // Handle navigation using your app's navigation pattern
///     // e.g., navigationController?.pushViewController(...)
/// }
/// let context = ActionContext(..., navigationPresenter: presenter, ...)
/// ```
@MainActor
public final class UIKitNavigationPresenter: NavigationPresenting {
    private let navigationHandler: (String, Document.NavigationPresentation?) -> Void

    public init(navigationHandler: @escaping (String, Document.NavigationPresentation?) -> Void) {
        self.navigationHandler = navigationHandler
    }

    public func navigate(to destination: String, presentation: Document.NavigationPresentation?) {
        navigationHandler(destination, presentation)
    }
}
