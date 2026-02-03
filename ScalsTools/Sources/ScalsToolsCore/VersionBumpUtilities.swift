//
//  VersionBumpUtilities.swift
//  ScalsToolsCore
//
//  Shared utilities for version bump CLI tools.
//

import Foundation

// MARK: - Version Types

/// Semantic version structure
public struct SemanticVersion: Comparable, CustomStringConvertible, Sendable {
    public let major: Int
    public let minor: Int
    public let patch: Int

    public init(_ major: Int, _ minor: Int, _ patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    /// Parse a version string (e.g., "1.2.3" or "1.2")
    public init?(string: String) {
        let components = string.split(separator: ".").compactMap { Int($0) }
        guard components.count >= 2 && components.count <= 3 else { return nil }
        self.major = components[0]
        self.minor = components[1]
        self.patch = components.count > 2 ? components[2] : 0
    }

    /// Version string (e.g., "1.2.3")
    public var string: String { "\(major).\(minor).\(patch)" }

    /// Underscore-separated string for Swift identifiers (e.g., "1_2_3")
    public var underscored: String { "\(major)_\(minor)_\(patch)" }

    public var description: String { string }

    public static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}

/// Type of version bump
public enum BumpType: String, CaseIterable, Sendable {
    case major
    case minor
    case patch

    public var displayName: String {
        rawValue
    }
}

// MARK: - Version Parsing

/// Errors that can occur during version operations
public enum VersionError: Error, CustomStringConvertible {
    case fileNotFound(String)
    case versionNotFound(property: String, in: String)
    case invalidVersionFormat(String)
    case snapshotAlreadyExists(SemanticVersion)
    case writeError(String)

    public var description: String {
        switch self {
        case .fileNotFound(let path):
            return "File not found: \(path)"
        case .versionNotFound(let property, let file):
            return "Version property '\(property)' not found in \(file)"
        case .invalidVersionFormat(let format):
            return "Invalid version format: \(format)"
        case .snapshotAlreadyExists(let version):
            return "Snapshot already exists for version \(version.string)"
        case .writeError(let message):
            return "Write error: \(message)"
        }
    }
}

/// Version parsing utilities
public enum VersionParser {

    /// Parse version from DocumentVersioning.swift
    /// - Parameters:
    ///   - fileURL: URL to DocumentVersioning.swift
    ///   - property: Property name to look for (e.g., "current" or "currentIR")
    /// - Returns: Parsed version
    public static func parseVersion(from fileURL: URL, property: String) throws -> SemanticVersion {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        return try parseVersion(from: content, property: property)
    }

    /// Parse version from file content
    /// - Parameters:
    ///   - content: File content
    ///   - property: Property name to look for
    /// - Returns: Parsed version
    public static func parseVersion(from content: String, property: String) throws -> SemanticVersion {
        // Pattern: public static let <property> = DocumentVersion(X, Y, Z)
        let pattern = #"public\s+static\s+let\s+"# + property + #"\s*=\s*DocumentVersion\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)"#

        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(
                  in: content,
                  range: NSRange(content.startIndex..., in: content)
              ) else {
            throw VersionError.versionNotFound(property: property, in: "content")
        }

        guard let majorRange = Range(match.range(at: 1), in: content),
              let minorRange = Range(match.range(at: 2), in: content),
              let patchRange = Range(match.range(at: 3), in: content),
              let major = Int(content[majorRange]),
              let minor = Int(content[minorRange]),
              let patch = Int(content[patchRange]) else {
            throw VersionError.invalidVersionFormat("Could not parse version numbers")
        }

        return SemanticVersion(major, minor, patch)
    }

    /// Calculate the new version after a bump
    public static func calculateNewVersion(_ current: SemanticVersion, bumpType: BumpType) -> SemanticVersion {
        switch bumpType {
        case .major:
            return SemanticVersion(current.major + 1, 0, 0)
        case .minor:
            return SemanticVersion(current.major, current.minor + 1, 0)
        case .patch:
            return SemanticVersion(current.major, current.minor, current.patch + 1)
        }
    }
}

// MARK: - Version File Updates

/// Version file update utilities
public enum VersionUpdater {

    /// Update version in DocumentVersioning.swift
    /// - Parameters:
    ///   - fileURL: URL to DocumentVersioning.swift
    ///   - property: Property to update ("current" or "currentIR")
    ///   - newVersion: New version to set
    ///   - addConstant: Whether to add a new version constant
    public static func updateVersion(
        in fileURL: URL,
        property: String,
        newVersion: SemanticVersion,
        addConstant: Bool = false
    ) throws {
        var content = try String(contentsOf: fileURL, encoding: .utf8)

        // Update the version property
        let pattern = #"(public\s+static\s+let\s+"# + property + #"\s*=\s*DocumentVersion\s*\()\s*\d+\s*,\s*\d+\s*,\s*\d+\s*(\))"#

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            throw VersionError.versionNotFound(property: property, in: fileURL.path)
        }

        let range = NSRange(content.startIndex..., in: content)
        let replacement = "$1\(newVersion.major), \(newVersion.minor), \(newVersion.patch)$2"
        let newContent = regex.stringByReplacingMatches(in: content, range: range, withTemplate: replacement)

        if newContent == content {
            throw VersionError.versionNotFound(property: property, in: fileURL.path)
        }

        content = newContent

        // Add new version constant if requested
        if addConstant {
            let constantName = "v\(newVersion.underscored)"
            // Check if constant already exists
            if !content.contains("static let \(constantName)") {
                // Find the last version constant and add after it
                let insertPattern = #"(public static let v\d+_\d+_\d+ = DocumentVersion\([^)]+\))"#
                if let insertRegex = try? NSRegularExpression(pattern: insertPattern) {
                    let matches = insertRegex.matches(in: content, range: NSRange(content.startIndex..., in: content))
                    if let lastMatch = matches.last,
                       let matchRange = Range(lastMatch.range, in: content) {
                        let insertPosition = content.index(matchRange.upperBound, offsetBy: 0)
                        let newConstant = "\n\n        /// Version \(newVersion.string) constant for convenience.\n        public static let \(constantName) = DocumentVersion(\(newVersion.major), \(newVersion.minor), \(newVersion.patch))"
                        content.insert(contentsOf: newConstant, at: insertPosition)
                    }
                }
            }
        }

        try content.write(to: fileURL, atomically: true, encoding: .utf8)
    }
}

// MARK: - Snapshot Creation

/// IR Snapshot creation utilities
public enum SnapshotCreator {

    /// Create a snapshot directory for a version
    /// - Parameters:
    ///   - version: Version to snapshot
    ///   - snapshotsDir: Base snapshots directory
    /// - Returns: URL to the created snapshot directory
    public static func createSnapshotDirectory(
        for version: SemanticVersion,
        in snapshotsDir: URL
    ) throws -> URL {
        let versionDir = snapshotsDir.appendingPathComponent("v\(version.underscored)")

        if FileManager.default.fileExists(atPath: versionDir.path) {
            throw VersionError.snapshotAlreadyExists(version)
        }

        try FileManager.default.createDirectory(at: versionDir, withIntermediateDirectories: true)
        return versionDir
    }

    /// Generate snapshot type aliases file
    /// - Parameters:
    ///   - version: Version for the snapshot
    ///   - destinationDir: Directory to write the file
    public static func generateIRTypesSnapshot(
        for version: SemanticVersion,
        in destinationDir: URL
    ) throws {
        let date = ISO8601DateFormatter.string(
            from: Date(),
            timeZone: .current,
            formatOptions: [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
        )

        let content = """
//
//  IRTypesV\(version.underscored).swift
//  ScalsRendererFramework
//
// ============================================================
// FROZEN SNAPSHOT - DO NOT MODIFY
// IR Schema Version: \(version.string)
// Snapshot Created: \(date)
//
// This file represents the IR schema as it existed in v\(version.string).
// It is preserved for reference and migration purposes only.
// All new development should use the current IR types.
// ============================================================
//

import Foundation

// MARK: - V\(version.underscored) Namespace

extension IRSnapshot {
    /// Frozen IR schema version \(version.string).
    ///
    /// **DO NOT MODIFY** - This is a historical snapshot.
    public enum V\(version.underscored) {}
}

// MARK: - Type Aliases for Unchanged Types

extension IRSnapshot.V\(version.underscored) {
    // These types have not changed between v\(version.string) and current.
    // We reference the current IR types directly.

    /// Platform-agnostic color (unchanged from current)
    public typealias Color = IR.Color

    /// Platform-agnostic edge insets (unchanged from current)
    public typealias EdgeInsets = IR.EdgeInsets

    /// Platform-agnostic shadow (unchanged from current)
    public typealias Shadow = IR.Shadow

    /// Platform-agnostic border (unchanged from current)
    public typealias Border = IR.Border

    /// Platform-agnostic alignment (unchanged from current)
    public typealias Alignment = IR.Alignment

    /// Horizontal alignment (unchanged from current)
    public typealias HorizontalAlignment = IR.HorizontalAlignment

    /// Vertical alignment (unchanged from current)
    public typealias VerticalAlignment = IR.VerticalAlignment

    /// Unit point for gradients (unchanged from current)
    public typealias UnitPoint = IR.UnitPoint

    /// Color scheme (unchanged from current)
    public typealias ColorScheme = IR.ColorScheme

    /// Font weight (unchanged from current)
    public typealias FontWeight = IR.FontWeight

    /// Text alignment (unchanged from current)
    public typealias TextAlignment = IR.TextAlignment

    /// Dimension value (unchanged from current)
    public typealias DimensionValue = IR.DimensionValue

    /// Section type (unchanged from current)
    public typealias SectionType = IR.SectionType

    /// Column config (unchanged from current)
    public typealias ColumnConfig = IR.ColumnConfig

    /// Section config (unchanged from current)
    public typealias SectionConfig = IR.SectionConfig

    /// Item dimensions (unchanged from current)
    public typealias ItemDimensions = IR.ItemDimensions

    /// Snap behavior (unchanged from current)
    public typealias SnapBehavior = IR.SnapBehavior

    /// Positioning (unchanged from current)
    public typealias Positioning = IR.Positioning

    /// Positioned edge inset (unchanged from current)
    public typealias PositionedEdgeInset = IR.PositionedEdgeInset

    /// Positioned edge insets (unchanged from current)
    public typealias PositionedEdgeInsets = IR.PositionedEdgeInsets
}
"""

        let fileURL = destinationDir.appendingPathComponent("IRTypesV\(version.underscored).swift")
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
    }

    /// Generate a placeholder RenderTree snapshot file
    /// - Parameters:
    ///   - version: Version for the snapshot
    ///   - destinationDir: Directory to write the file
    ///   - changesDescription: Description of changes for this version
    public static func generateRenderTreeSnapshot(
        for version: SemanticVersion,
        in destinationDir: URL,
        changesDescription: String = "TODO: Document changes from previous version"
    ) throws {
        let date = ISO8601DateFormatter.string(
            from: Date(),
            timeZone: .current,
            formatOptions: [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
        )

        let content = """
//
//  RenderTreeV\(version.underscored).swift
//  ScalsRendererFramework
//
// ============================================================
// FROZEN SNAPSHOT - DO NOT MODIFY
// IR Schema Version: \(version.string)
// Snapshot Created: \(date)
//
// This file represents the IR schema as it existed in v\(version.string).
// It is preserved for reference and migration purposes only.
// All new development should use the current IR types.
//
// CHANGES FROM PREVIOUS VERSION:
// \(changesDescription)
// ============================================================
//

import Foundation

// TODO: Copy the current RenderTree node definitions here
// and modify them to match the schema at v\(version.string).
//
// Example structure:
//
// extension IRSnapshot.V\(version.underscored) {
//     public struct ContainerNode {
//         // Properties as they existed in v\(version.string)
//     }
// }

// MARK: - Version Constant

extension IRSnapshot.V\(version.underscored) {
    /// The IR version this snapshot represents
    public static let version = DocumentVersion(\(version.major), \(version.minor), \(version.patch))
}
"""

        let fileURL = destinationDir.appendingPathComponent("RenderTreeV\(version.underscored).swift")
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
    }

    /// Set files to read-only
    /// - Parameter directory: Directory containing files to make read-only
    public static func setReadOnly(at directory: URL) throws {
        let fileManager = FileManager.default
        let contents = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)

        for fileURL in contents where fileURL.pathExtension == "swift" {
            // Set file to read-only (0o444 = r--r--r--)
            try fileManager.setAttributes([.posixPermissions: 0o444], ofItemAtPath: fileURL.path)
        }
    }
}

// MARK: - Snapshot Policy Update

/// Snapshot policy document updater
public enum SnapshotPolicyUpdater {

    /// Add a new version entry to SnapshotPolicy.md
    /// - Parameters:
    ///   - version: Version being added
    ///   - previousVersion: Previous version (for comparison)
    ///   - changesDescription: Description of changes
    ///   - policyFileURL: URL to SnapshotPolicy.md
    public static func addVersionEntry(
        version: SemanticVersion,
        previousVersion: SemanticVersion,
        changesDescription: String,
        to policyFileURL: URL
    ) throws {
        var content = try String(contentsOf: policyFileURL, encoding: .utf8)

        let date = ISO8601DateFormatter.string(
            from: Date(),
            timeZone: .current,
            formatOptions: [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
        )

        // Find the "## Version History" section and add after the last version entry
        let newEntry = """

### v\(version.string) (Current)

**Snapshot Created:** \(date)

**Changes from v\(previousVersion.string):**
\(changesDescription)

"""

        // Update the previous "Current" marker
        content = content.replacingOccurrences(
            of: "### v\(previousVersion.string) (Current)",
            with: "### v\(previousVersion.string)"
        )

        // Find the Version History section header and insert after the first version entry
        if let historyRange = content.range(of: "## Version History") {
            // Find the next section (starts with ##) or end of version history
            let searchRange = historyRange.upperBound..<content.endIndex
            if let nextSectionRange = content.range(of: "\n### v", range: searchRange) {
                content.insert(contentsOf: newEntry, at: nextSectionRange.lowerBound)
            }
        }

        try content.write(to: policyFileURL, atomically: true, encoding: .utf8)
    }
}

// MARK: - Document Snapshot Creation

/// Document Snapshot creation utilities
public enum DocumentSnapshotCreator {

    /// Create a snapshot directory for a Document version
    /// - Parameters:
    ///   - version: Version to snapshot
    ///   - snapshotsDir: Base snapshots directory
    /// - Returns: URL to the created snapshot directory
    public static func createSnapshotDirectory(
        for version: SemanticVersion,
        in snapshotsDir: URL
    ) throws -> URL {
        let versionDir = snapshotsDir.appendingPathComponent("v\(version.underscored)")

        if FileManager.default.fileExists(atPath: versionDir.path) {
            throw VersionError.snapshotAlreadyExists(version)
        }

        try FileManager.default.createDirectory(at: versionDir, withIntermediateDirectories: true)
        return versionDir
    }

    /// Generate Document types snapshot file
    /// - Parameters:
    ///   - version: Version for the snapshot
    ///   - destinationDir: Directory to write the file
    public static func generateDocumentTypesSnapshot(
        for version: SemanticVersion,
        in destinationDir: URL
    ) throws {
        let date = ISO8601DateFormatter.string(
            from: Date(),
            timeZone: .current,
            formatOptions: [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
        )

        let content = """
//
//  DocumentTypesV\(version.underscored).swift
//  ScalsRendererFramework
//
// ============================================================
// FROZEN SNAPSHOT - DO NOT MODIFY
// Document Schema Version: \(version.string)
// Snapshot Created: \(date)
//
// This file represents the Document schema as it existed in v\(version.string).
// It is preserved for reference and migration purposes only.
// All new development should use the current Document types.
// ============================================================
//

import Foundation

// MARK: - DocumentSnapshot Namespace

/// Namespace for frozen Document schema snapshots.
///
/// Each version snapshot is nested under this enum to avoid type conflicts
/// with the current Document types.
public enum DocumentSnapshot {}

// MARK: - V\(version.underscored) Namespace

extension DocumentSnapshot {
    /// Frozen Document schema version \(version.string).
    ///
    /// **DO NOT MODIFY** - This is a historical snapshot.
    public enum V\(version.underscored) {}
}

// MARK: - Type Aliases for Unchanged Types

extension DocumentSnapshot.V\(version.underscored) {
    // These types have not changed between v\(version.string) and current.
    // We reference the current Document types directly.

    /// Style definition (unchanged from current)
    public typealias Style = Document.Style

    /// Padding definition (unchanged from current)
    public typealias Padding = Document.Padding

    /// Color definition (unchanged from current)
    public typealias Color = Document.Color

    /// Action binding (unchanged from current)
    public typealias ActionBinding = Document.Component.ActionBinding
}

// MARK: - Version Constant

extension DocumentSnapshot.V\(version.underscored) {
    /// The Document version this snapshot represents
    public static let version = DocumentVersion(\(version.major), \(version.minor), \(version.patch))
}
"""

        let fileURL = destinationDir.appendingPathComponent("DocumentTypesV\(version.underscored).swift")
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
    }

    /// Generate Components snapshot file
    /// - Parameters:
    ///   - version: Version for the snapshot
    ///   - destinationDir: Directory to write the file
    ///   - changesDescription: Description of changes for this version
    public static func generateComponentsSnapshot(
        for version: SemanticVersion,
        in destinationDir: URL,
        changesDescription: String = "TODO: Document changes from previous version"
    ) throws {
        let date = ISO8601DateFormatter.string(
            from: Date(),
            timeZone: .current,
            formatOptions: [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
        )

        let content = """
//
//  ComponentsV\(version.underscored).swift
//  ScalsRendererFramework
//
// ============================================================
// FROZEN SNAPSHOT - DO NOT MODIFY
// Document Schema Version: \(version.string)
// Snapshot Created: \(date)
//
// This file represents the Document components as they existed in v\(version.string).
// It is preserved for reference and migration purposes only.
// All new development should use the current Document types.
//
// CHANGES FROM PREVIOUS VERSION:
// \(changesDescription)
// ============================================================
//

import Foundation

// TODO: Copy the current Document component definitions here
// and modify them to match the schema at v\(version.string).
//
// Example structure:
//
// extension DocumentSnapshot.V\(version.underscored) {
//     public enum Component {
//         case text(Text)
//         case button(Button)
//         // ... etc
//     }
//
//     public struct Text {
//         // Properties as they existed in v\(version.string)
//     }
// }
"""

        let fileURL = destinationDir.appendingPathComponent("ComponentsV\(version.underscored).swift")
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
    }

    /// Set files to read-only
    /// - Parameter directory: Directory containing files to make read-only
    public static func setReadOnly(at directory: URL) throws {
        let fileManager = FileManager.default
        let contents = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)

        for fileURL in contents where fileURL.pathExtension == "swift" {
            // Set file to read-only (0o444 = r--r--r--)
            try fileManager.setAttributes([.posixPermissions: 0o444], ofItemAtPath: fileURL.path)
        }
    }
}

// MARK: - Confirmation Prompts

/// User confirmation utilities
public enum ConfirmationPrompt {

    /// Standard yes/no confirmation
    /// - Parameter message: Message to display
    /// - Returns: True if user confirmed
    public static func confirm(_ message: String) -> Bool {
        print(message)
        print("Type 'yes' to continue: ", terminator: "")
        guard let response = readLine()?.trimmingCharacters(in: .whitespaces) else {
            return false
        }
        return response.lowercased() == "yes"
    }

    /// Double confirmation for major version bumps
    /// - Parameters:
    ///   - newVersion: The new version
    ///   - versionType: Type of version ("IR" or "Document")
    /// - Returns: True if user confirmed both prompts
    public static func confirmMajorBump(newVersion: SemanticVersion, versionType: String) -> Bool {
        print("")
        print("!!! MAJOR VERSION BUMP !!!")
        print("This indicates BREAKING CHANGES to the \(versionType) contract.")

        if versionType == "IR" {
            print("All renderers may need updates to handle the new schema.")
        } else {
            print("Existing SCALS documents may need updates.")
        }

        print("")
        print("Type 'BREAKING' to acknowledge breaking changes: ", terminator: "")
        guard let response1 = readLine()?.trimmingCharacters(in: .whitespaces),
              response1 == "BREAKING" else {
            return false
        }

        print("Type the new version number '\(newVersion.string)' to confirm: ", terminator: "")
        guard let response2 = readLine()?.trimmingCharacters(in: .whitespaces),
              response2 == newVersion.string else {
            return false
        }

        return true
    }
}

// MARK: - Changelog Update

/// Changelog updater for Document schema
public enum ChangelogUpdater {

    /// Add a new version entry to CHANGELOG.md
    /// - Parameters:
    ///   - version: New version being released
    ///   - changesDescription: Description of changes (markdown formatted)
    ///   - changelogURL: URL to CHANGELOG.md
    public static func addVersionEntry(
        version: SemanticVersion,
        changesDescription: String,
        to changelogURL: URL
    ) throws {
        var content = try String(contentsOf: changelogURL, encoding: .utf8)

        let date = ISO8601DateFormatter.string(
            from: Date(),
            timeZone: .current,
            formatOptions: [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
        )

        // Format the new entry
        let newEntry = """

## [\(version.string)] - \(date)

### Changed
\(changesDescription)

"""

        // Find the first version entry (## [X.Y.Z]) and insert before it
        let versionPattern = #"\n## \[\d+\.\d+\.\d+\]"#
        if let regex = try? NSRegularExpression(pattern: versionPattern),
           let match = regex.firstMatch(in: content, range: NSRange(content.startIndex..., in: content)),
           let matchRange = Range(match.range, in: content) {
            content.insert(contentsOf: newEntry, at: matchRange.lowerBound)
        } else {
            // No existing version entries, append to end
            content.append(newEntry)
        }

        try content.write(to: changelogURL, atomically: true, encoding: .utf8)
    }
}

// MARK: - Change Detection

/// Detected file change
public struct FileChange: Sendable {
    public let path: String
    public let description: String

    public init(path: String, description: String = "") {
        self.path = path
        self.description = description
    }
}

/// Change detection utilities
public enum ChangeDetector {

    /// Detect changes in a directory since a reference
    /// - Parameters:
    ///   - directory: Directory to check
    ///   - ref: Git reference to compare against
    ///   - workingDirectory: Repository root
    /// - Returns: Array of file changes
    public static func detectChanges(
        in directory: String,
        since ref: String,
        workingDirectory: String? = nil
    ) throws -> [FileChange] {
        let changedFiles = try GitUtilities.changedFilesSince(
            ref,
            paths: [directory],
            workingDirectory: workingDirectory
        )

        return changedFiles.map { FileChange(path: $0) }
    }

    /// Analyze changes for potential breaking changes
    /// - Parameter changes: File changes to analyze
    /// - Returns: Summary of potential breaking changes
    public static func analyzeBreakingChanges(_ changes: [FileChange]) -> [String] {
        var breaking: [String] = []

        for change in changes {
            let filename = (change.path as NSString).lastPathComponent

            // Common patterns that suggest breaking changes
            if filename.contains("RenderTree") {
                breaking.append("Node structure changes in \(filename)")
            }
            if filename.contains("IR.swift") {
                breaking.append("Core IR type changes in \(filename)")
            }
        }

        return breaking
    }
}
