//
//  SwiftUIAlertPresenter.swift
//  ScalsModules
//
//  SwiftUI-specific implementation of AlertPresenting.
//

import SwiftUI
import Combine
import SCALS

/// SwiftUI implementation of alert presentation.
///
/// Uses SwiftUI's .alert modifier pattern to present alerts.
/// This presenter manages alert state and presentation in a SwiftUI-friendly way.
///
/// Usage:
/// ```swift
/// @StateObject var alertPresenter = SwiftUIAlertPresenter()
/// let context = ActionContext(..., alertPresenter: alertPresenter, ...)
///
/// // In your view:
/// .modifier(alertPresenter.modifier())
/// ```
@MainActor
public final class SwiftUIAlertPresenter: AlertPresenting, ObservableObject {
    @Published var isPresented = false
    @Published var currentConfig: AlertConfiguration?

    public init() {}

    public func present(_ config: AlertConfiguration) {
        currentConfig = config
        isPresented = true
    }

    /// Returns a view modifier that handles alert presentation.
    public func modifier() -> AlertPresenterModifier {
        AlertPresenterModifier(presenter: self)
    }
}

/// View modifier that presents alerts.
public struct AlertPresenterModifier: ViewModifier {
    @ObservedObject var presenter: SwiftUIAlertPresenter

    public func body(content: Content) -> some View {
        content.alert(
            presenter.currentConfig?.title ?? "",
            isPresented: $presenter.isPresented,
            presenting: presenter.currentConfig
        ) { config in
            ForEach(config.buttons.indices, id: \.self) { index in
                let button = config.buttons[index]
                Button(button.label, role: buttonRole(for: button.style)) {
                    config.onButtonTap?(button.action)
                }
            }
        } message: { config in
            if let message = config.message {
                Text(message)
            }
        }
    }

    private func buttonRole(for style: Document.AlertButtonStyle) -> ButtonRole? {
        switch style {
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        case .default:
            return nil
        }
    }
}
