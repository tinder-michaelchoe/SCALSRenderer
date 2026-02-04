//
//  UIKitAlertDelegatePresenter.swift
//  ScalsModules
//
//  UIKit presenter that delegates alert presentation to ScalsRendererDelegate.
//

import UIKit
import SCALS

/// UIKit alert presenter that delegates to ScalsRendererDelegate.
///
/// This presenter is used internally by ScalsUIKitView to bridge
/// the presenter pattern with the existing delegate pattern.
@MainActor
public final class UIKitAlertDelegatePresenter: AlertPresenting {
    private weak var view: ScalsUIKitView?

    public init(view: ScalsUIKitView) {
        self.view = view
    }

    public func present(_ config: AlertConfiguration) {
        guard let view = view else { return }
        view.delegate?.scalsRenderer(view, didRequestAlert: config)
    }
}
