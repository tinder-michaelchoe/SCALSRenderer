//
//  Document+ActionKind.swift
//  ScalsModules
//
//  Built-in action kind static properties.
//  These extend Document.ActionKind with concrete built-in action types.
//

import SCALS

// MARK: - Built-in Action Kinds

extension Document.ActionKind {
    /// Dismiss the current view
    public static let dismiss = Document.ActionKind(rawValue: "dismiss")

    /// Set a value in the state store
    public static let setState = Document.ActionKind(rawValue: "setState")

    /// Toggle a boolean value in the state store
    public static let toggleState = Document.ActionKind(rawValue: "toggleState")

    /// Show an alert dialog
    public static let showAlert = Document.ActionKind(rawValue: "showAlert")

    /// Navigate to another view
    public static let navigate = Document.ActionKind(rawValue: "navigate")

    /// Execute multiple actions in sequence
    public static let sequence = Document.ActionKind(rawValue: "sequence")

    /// Open a URL in Safari
    public static let openURL = Document.ActionKind(rawValue: "openURL")

    /// Make an HTTP request
    public static let request = Document.ActionKind(rawValue: "request")
}
