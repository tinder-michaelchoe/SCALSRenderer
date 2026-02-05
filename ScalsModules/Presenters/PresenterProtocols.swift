//
//  PresenterProtocols.swift
//  ScalsModules
//
//  DEPRECATED: This file contains legacy individual presenter protocols.
//  New code should use PresentationHandler.swift for unified presentation handling.
//
//  These protocols are kept for backward compatibility but will be removed in a future version.
//

import Foundation
import SCALS

// NOTE: AlertConfiguration has been moved to PresentationHandler.swift

// MARK: - Individual Presenter Protocols (DEPRECATED)

/// DEPRECATED: Use PresentationHandler instead
public protocol AlertPresenting: AnyObject {
    func present(_ config: AlertConfiguration)
}

/// DEPRECATED: Use PresentationHandler instead
public protocol DismissPresenting: AnyObject {
    func dismiss()
}

/// DEPRECATED: Use PresentationHandler instead
public protocol NavigationPresenting: AnyObject {
    func navigate(to destination: String, presentation: Document.NavigationPresentation?)
}

/// DEPRECATED: Use PresentationHandler instead
public protocol URLPresenting: AnyObject {
    func openURL(_ urlString: String)
}
