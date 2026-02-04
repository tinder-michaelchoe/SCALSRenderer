//
//  RenderNodeKind+BuiltIn.swift
//  ScalsModules
//
//  Built-in render node kind identifiers for node types still in SCALS.
//  Node types that have been moved to ScalsModules define their own RenderNodeKind
//  in their respective files (e.g., TextNode.swift defines .text).
//
//  Kinds defined here (node still in SCALS):
//  - button (depends on ImageNode.Source)
//  - image, gradient, shape (need nested type extraction first)
//
//  Kinds defined in SCALS:
//  - container, sectionLayout, spacer (required by layout resolvers)
//
//  Kinds defined in ScalsModules/IR/Nodes/:
//  - text, textField, toggle, slider, pageIndicator, divider
//

import SCALS

// MARK: - Built-in Render Node Kinds (Still in SCALS)

extension RenderNodeKind {
    /// Custom/extensible node kind
    public static let custom = RenderNodeKind(rawValue: "custom")
}
