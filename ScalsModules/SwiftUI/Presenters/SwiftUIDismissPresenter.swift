//
//  SwiftUIDismissPresenter.swift
//  ScalsModules
//
//  SwiftUI-specific implementation of DismissPresenting.
//

import SwiftUI
import SCALS

/// SwiftUI implementation of dismiss presentation.
///
/// Uses SwiftUI's @Environment(\.dismiss) action to dismiss views.
///
/// Usage:
/// ```swift
/// @Environment(\.dismiss) var dismiss
/// let presenter = SwiftUIDismissPresenter(dismiss: dismiss)
/// let context = ActionContext(..., dismissPresenter: presenter, ...)
/// ```
@MainActor
public final class SwiftUIDismissPresenter: DismissPresenting {
    private let dismissAction: DismissAction

    public init(dismiss: DismissAction) {
        self.dismissAction = dismiss
    }

    public func dismiss() {
        dismissAction()
    }
}
