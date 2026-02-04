//
//  UIKitDismissDelegatePresenter.swift
//  ScalsModules
//
//  UIKit presenter that delegates dismiss to ScalsRendererDelegate.
//

import UIKit
import SCALS

/// UIKit dismiss presenter that delegates to ScalsRendererDelegate.
///
/// This presenter is used internally by ScalsUIKitView to bridge
/// the presenter pattern with the existing delegate pattern.
@MainActor
public final class UIKitDismissDelegatePresenter: DismissPresenting {
    private weak var view: ScalsUIKitView?

    public init(view: ScalsUIKitView) {
        self.view = view
    }

    public func dismiss() {
        guard let view = view else { return }
        view.delegate?.scalsRendererDidRequestDismiss(view)
    }
}
