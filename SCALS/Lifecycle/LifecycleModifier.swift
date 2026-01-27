//
//  LifecycleModifier.swift
//  ScalsRendererFramework
//
//  SwiftUI view modifier that applies lifecycle action hooks.
//

import SwiftUI

// MARK: - Lifecycle Modifier

/// View modifier that applies lifecycle action bindings to a view.
///
/// To add support for a new event:
/// 1. Add the case to `LifecycleActions.LifecycleEvent`
/// 2. Add the corresponding SwiftUI modifier here
struct LifecycleModifier: ViewModifier {
    let actions: LifecycleActions
    let context: ActionContext

    func body(content: Content) -> some View {
        content
            .onAppear {
                execute(.onAppear)
            }
            .onDisappear {
                execute(.onDisappear)
            }
        // Future events:
        // .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
        //     execute(.onForeground)
        // }
    }

    private func execute(_ event: LifecycleActions.LifecycleEvent) {
        if let action = actions.action(for: event) {
            context.execute(action)
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Apply lifecycle action hooks to this view
    func lifecycleActions(_ actions: LifecycleActions, context: ActionContext) -> some View {
        modifier(LifecycleModifier(actions: actions, context: context))
    }
}
