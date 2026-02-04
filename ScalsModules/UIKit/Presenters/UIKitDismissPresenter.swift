//
//  UIKitDismissPresenter.swift
//  ScalsModules
//
//  UIKit-specific implementation of DismissPresenting.
//

import UIKit
import SCALS

/// UIKit implementation of dismiss presentation.
///
/// Uses UIViewController's dismiss(animated:completion:) method to dismiss views.
///
/// Usage:
/// ```swift
/// let presenter = UIKitDismissPresenter(viewController: self)
/// let context = ActionContext(..., dismissPresenter: presenter, ...)
/// ```
@MainActor
public final class UIKitDismissPresenter: DismissPresenting {
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
