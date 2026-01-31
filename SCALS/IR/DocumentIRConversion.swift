//
//  DocumentIRConversion.swift
//  ScalsRendererFramework
//
//  Protocol for converting Document types to IR types.
//  Simple, one-way conversion with no dependencies on IR internals.
//
//  **Important**: This file should remain platform-agnostic. Do NOT import
//  SwiftUI or UIKit here. Platform-specific conversions belong in the
//  renderer layer (see `Renderers/SwiftUI/IRTypeConversions.swift`).
//

import Foundation

// MARK: - Conversion Protocol

/// A Document type that can be converted to an IR type.
///
/// This protocol enables pure Document→IR conversion without coupling
/// Document types to IR resolution logic (like style merging).
///
/// ## Usage
///
/// Conform Document types to this protocol for simple, pure conversions:
///
/// ```swift
/// extension Document.Padding: IRConvertible {
///     public typealias IRType = IR.EdgeInsets
///
///     public func toIR() -> IR.EdgeInsets {
///         return IR.EdgeInsets(
///             top: resolvedTop,
///             leading: resolvedLeading,
///             bottom: resolvedBottom,
///             trailing: resolvedTrailing
///         )
///     }
/// }
/// ```
///
/// ## Design Principles
///
/// - **Pure conversion**: `toIR()` should only resolve internal representation
///   (e.g., horizontal/vertical → specific edges), NOT merge with external sources.
/// - **No coupling**: Document types should NOT depend on IR.Style or ResolvedStyle.
/// - **One-way**: Only IR depends on Document (Document → IR → Render).
///
/// For merging with style properties, use IR initializers instead:
/// ```swift
/// let padding = IR.EdgeInsets(
///     from: layout.padding,
///     mergingTop: resolvedStyle.paddingTop ?? 0,
///     // ...
/// )
/// ```
public protocol IRConvertible {
    /// The target IR type
    associatedtype IRType

    /// Convert this Document type to its IR representation.
    ///
    /// This should be a simple, pure conversion that resolves internal
    /// representation (e.g., horizontal/vertical → specific edges) but
    /// does NOT merge with external sources like styles.
    func toIR() -> IRType
}
