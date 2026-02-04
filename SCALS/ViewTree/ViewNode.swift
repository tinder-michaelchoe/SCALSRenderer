//
//  ViewNode.swift
//  ScalsRendererFramework
//
//  Represents a node in the view tree with dependency tracking.
//
//  **Important**: This file should remain platform-agnostic. Do NOT import
//  SwiftUI or UIKit here. Platform-specific conversions belong in the
//  renderer layer (see `Renderers/SwiftUI/IRTypeConversions.swift`).
//

import Foundation

// MARK: - View Node

/// A node in the view tree that tracks its state dependencies
public class ViewNode: Identifiable {
    public let id: String
    public weak var parent: ViewNode?
    public var children: [ViewNode]

    // Dependency tracking
    public var readPaths: Set<String> = []      // State paths this node reads
    public var writePaths: Set<String> = []     // State paths this node writes (e.g., textfield binding)

    // Local state (if this node declares local state)
    public var localState: [String: Any]?

    // Update tracking
    public var needsUpdate: Bool = false
    public var lastUpdateTimestamp: Date?

    public init(
        id: String,
        children: [ViewNode] = []
    ) {
        self.id = id
        self.children = children

        // Set parent references
        for child in children {
            child.parent = self
        }
    }

    // MARK: - Tree Traversal

    /// Find a node by ID in this subtree
    public func findNode(id: String) -> ViewNode? {
        if self.id == id { return self }
        for child in children {
            if let found = child.findNode(id: id) {
                return found
            }
        }
        return nil
    }

    /// Get all descendant nodes
    public func allDescendants() -> [ViewNode] {
        var result: [ViewNode] = []
        for child in children {
            result.append(child)
            result.append(contentsOf: child.allDescendants())
        }
        return result
    }

    /// Get the path from root to this node
    public func pathFromRoot() -> [ViewNode] {
        var path: [ViewNode] = [self]
        var current = self.parent
        while let node = current {
            path.insert(node, at: 0)
            current = node.parent
        }
        return path
    }

    // MARK: - Local State Scope

    /// Find the nearest ancestor (including self) that has local state
    public func nearestLocalStateScope() -> ViewNode? {
        if localState != nil { return self }
        return parent?.nearestLocalStateScope()
    }

    /// Get local state value, walking up the tree if needed
    public func getLocalState(_ path: String) -> Any? {
        // Only look at our own local state (no parent access)
        guard let state = localState else { return nil }
        return StatePathResolver.getValue(from: state, path: path)
    }

    /// Set local state value
    public func setLocalState(_ path: String, value: Any) {
        if localState == nil {
            localState = [:]
        }
        StatePathResolver.setValue(in: &localState!, path: path, value: value)
    }
}

// MARK: - State Path Resolver

/// Utility for resolving dot-notation paths in dictionaries
public enum StatePathResolver {

    public static func getValue(from dict: [String: Any], path: String) -> Any? {
        let components = path.split(separator: ".").map(String.init)
        var current: Any = dict

        for component in components {
            if let dict = current as? [String: Any] {
                guard let next = dict[component] else { return nil }
                current = next
            } else {
                return nil
            }
        }

        return current
    }

    public static func setValue(in dict: inout [String: Any], path: String, value: Any) {
        let components = path.split(separator: ".").map(String.init)

        if components.count == 1 {
            dict[path] = value
            return
        }

        // Navigate to parent, then set
        var current = dict
        for (index, component) in components.dropLast().enumerated() {
            if let next = current[component] as? [String: Any] {
                current = next
            } else {
                // Create intermediate dictionaries
                var newDict: [String: Any] = [:]
                setValueRecursive(in: &newDict, components: Array(components[index...]), value: value)
                dict[component] = newDict
                return
            }
        }

        // Set the final value
        setValueRecursive(in: &dict, components: components, value: value)
    }

    private static func setValueRecursive(in dict: inout [String: Any], components: [String], value: Any) {
        guard !components.isEmpty else { return }

        if components.count == 1 {
            dict[components[0]] = value
            return
        }

        let key = components[0]
        var subDict = dict[key] as? [String: Any] ?? [:]
        setValueRecursive(in: &subDict, components: Array(components.dropFirst()), value: value)
        dict[key] = subDict
    }
}
