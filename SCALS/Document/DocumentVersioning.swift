//
//  DocumentVersioning.swift
//  ScalsRendererFramework
//
//  Semantic versioning support for SCALS documents and IR.
//

import Foundation

// MARK: - DocumentVersion

extension Document {
    /// Semantic version for SCALS documents and IR.
    ///
    /// SCALS uses dual versioning:
    /// - **Document schema version** (`Document.Definition.version`): User-facing JSON API, evolves frequently
    /// - **IR schema version** (`RenderTree.irVersion`): Renderer contract, extremely stable
    ///
    /// Example usage:
    /// ```swift
    /// let version = DocumentVersion(1, 2, 3)
    /// let parsed = DocumentVersion(string: "1.2.3")
    /// print(DocumentVersion.current.string)  // "0.1.0"
    /// ```
    public struct DocumentVersion: Comparable, Codable, Sendable, Hashable {
        public let major: Int
        public let minor: Int
        public let patch: Int

        // MARK: - Initialization

        /// Creates a version with explicit major, minor, and patch components.
        public init(_ major: Int, _ minor: Int, _ patch: Int) {
            self.major = major
            self.minor = minor
            self.patch = patch
        }

        /// Parses a version string (e.g., "1.2.3" or "1.2").
        ///
        /// Returns `nil` if the string is not a valid semver format.
        /// - Parameter string: Version string to parse
        /// - Returns: Parsed version or nil if invalid
        public init?(string: String) {
            let components = string.split(separator: ".").compactMap { Int($0) }
            guard components.count >= 2 && components.count <= 3 else { return nil }
            self.major = components[0]
            self.minor = components[1]
            self.patch = components.count > 2 ? components[2] : 0
        }

        // MARK: - String Representation

        /// Returns the version as a string (e.g., "1.2.3").
        public var string: String { "\(major).\(minor).\(patch)" }

        // MARK: - Version Constants

        /// Current Document schema version.
        ///
        /// This version represents the user-facing JSON API and can evolve
        /// frequently with new components, actions, and properties.
        public static let current = DocumentVersion(0, 1, 0)

        /// Current IR schema version.
        ///
        /// This version represents the renderer contract and should remain
        /// extremely stable. Breaking changes to IR are rare and require
        /// ecosystem-wide coordination.
        public static let currentIR = DocumentVersion(0, 1, 0)

        /// Version 0.1.0 constant for convenience.
        public static let v0_1_0 = DocumentVersion(0, 1, 0)

        // MARK: - Comparable

        public static func < (lhs: DocumentVersion, rhs: DocumentVersion) -> Bool {
            if lhs.major != rhs.major { return lhs.major < rhs.major }
            if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
            return lhs.patch < rhs.patch
        }

        public static func == (lhs: DocumentVersion, rhs: DocumentVersion) -> Bool {
            lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
        }
    }
}

// MARK: - Convenience Type Alias

/// Type alias for Document.DocumentVersion for easier access.
public typealias DocumentVersion = Document.DocumentVersion
