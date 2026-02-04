//
//  SwiftUINavigationPresenter.swift
//  ScalsModules
//
//  SwiftUI-specific implementation of NavigationPresenting.
//

import SwiftUI
import SCALS

/// SwiftUI implementation of navigation presentation.
///
/// Navigation in SwiftUI can be implemented in various ways (NavigationStack,
/// NavigationLink, programmatic navigation, etc.). This presenter uses a
/// closure-based approach to allow flexibility in how navigation is handled.
///
/// Usage:
/// ```swift
/// let presenter = SwiftUINavigationPresenter { destination, presentation in
///     // Handle navigation using your app's navigation pattern
///     navigationPath.append(destination)
/// }
/// let context = ActionContext(..., navigationPresenter: presenter, ...)
/// ```
@MainActor
public final class SwiftUINavigationPresenter: NavigationPresenting {
    private let navigationHandler: (String, Document.NavigationPresentation?) -> Void

    public init(navigationHandler: @escaping (String, Document.NavigationPresentation?) -> Void) {
        self.navigationHandler = navigationHandler
    }

    public func navigate(to destination: String, presentation: Document.NavigationPresentation?) {
        navigationHandler(destination, presentation)
    }
}
