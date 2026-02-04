//
//  RenderTree.swift
//  ScalsRendererFramework
//
//  Intermediate Representation (IR) for rendering.
//  This is the resolved, ready-to-render tree structure.
//
//  **Important**: This file should remain platform-agnostic. Do NOT import
//  SwiftUI or UIKit here. Platform-specific conversions belong in the
//  renderer layer (see `Renderers/SwiftUI/IRTypeConversions.swift`).
//

import Foundation

// MARK: - Render Tree

/// The root of the resolved render tree
/// All styles resolved, data bound, references validated
public struct RenderTree {
    /// IR schema version used to create this tree.
    ///
    /// This version indicates the IR contract used for rendering.
    /// Renderers can check this to ensure compatibility.
    public let irVersion: DocumentVersion

    /// The root node containing all children
    public let root: RootNode

    /// Reference to state store for dynamic updates
    public let stateStore: StateStore

    /// Action definitions for execution
    public let actions: [String: IR.ActionDefinition]

    public init(
        root: RootNode,
        stateStore: StateStore,
        actions: [String: IR.ActionDefinition],
        irVersion: DocumentVersion = .currentIR
    ) {
        self.irVersion = irVersion
        self.root = root
        self.stateStore = stateStore
        self.actions = actions
    }
}

// MARK: - Root Node

/// The resolved root container
public struct RootNode {
    public let backgroundColor: IR.Color?
    public let edgeInsets: IR.PositionedEdgeInsets?
    public let colorScheme: IR.ColorScheme
    public let actions: LifecycleActions
    public let children: [RenderNode]

    // MARK: - Flattened Style Properties

    public let padding: IR.EdgeInsets
    public let cornerRadius: CGFloat
    public let shadow: IR.Shadow?
    public let border: IR.Border?

    public init(
        backgroundColor: IR.Color? = nil,
        edgeInsets: IR.PositionedEdgeInsets? = nil,
        colorScheme: IR.ColorScheme = .system,
        actions: LifecycleActions = LifecycleActions(),
        children: [RenderNode] = [],
        padding: IR.EdgeInsets = .zero,
        cornerRadius: CGFloat = 0,
        shadow: IR.Shadow? = nil,
        border: IR.Border? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.edgeInsets = edgeInsets
        self.colorScheme = colorScheme
        self.actions = actions
        self.children = children
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.border = border
    }
}

// MARK: - Render Node Kind

/// Type-safe render node kind identifier.
///
/// Uses struct with static constants for compile-time safety while remaining extensible.
/// External modules can add new render node kinds without modifying core code.
///
/// Built-in kinds are accessed via static properties defined in ScalsModules:
/// ```swift
/// RenderNodeKind.text
/// RenderNodeKind.button
/// ```
///
/// External modules can extend with new kinds:
/// ```swift
/// extension RenderNodeKind {
///     public static let chart = RenderNodeKind(rawValue: "chart")
/// }
/// ```
public struct RenderNodeKind: Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

