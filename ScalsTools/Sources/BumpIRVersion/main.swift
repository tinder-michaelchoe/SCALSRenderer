//
//  main.swift
//  BumpIRVersion
//
//  CLI tool for bumping IR schema version.
//  Usage: scals-bump-ir-version <major|minor|patch> [options]
//

import ArgumentParser
import Foundation
import ScalsToolsCore

@main
struct BumpIRVersion: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "scals-bump-ir-version",
        abstract: "Bump SCALS IR schema version",
        discussion: """
            Bumps the IR schema version in DocumentVersioning.swift and optionally
            creates a snapshot of the current IR types for migration purposes.

            IR version changes affect ALL renderers (SwiftUI, UIKit, HTML, iOS26 HTML).
            Use with caution - breaking changes require ecosystem-wide coordination.

            Examples:
              scals-bump-ir-version minor -m "Added opacity property"
              scals-bump-ir-version major --dry-run
              scals-bump-ir-version patch --skip-snapshot
            """
    )

    @Argument(help: "Bump type: major, minor, or patch")
    var bumpType: String

    @Option(name: [.short, .customLong("message")], help: "Description of changes for changelog")
    var message: String?

    @Option(name: .long, help: "Path to SCALS framework (default: '..')")
    var frameworkPath: String = ".."

    @Flag(name: .long, help: "Skip snapshot creation (not recommended)")
    var skipSnapshot: Bool = false

    @Flag(name: .long, help: "Skip git uncommitted changes warning")
    var skipGitCheck: Bool = false

    @Flag(name: .long, help: "Show what would be done without making changes")
    var dryRun: Bool = false

    @Flag(name: [.short, .long], help: "Show verbose output")
    var verbose: Bool = false

    @Flag(name: .long, help: "Skip confirmations (use with caution)")
    var force: Bool = false

    // MARK: - Run

    mutating func run() throws {
        // Parse bump type
        guard let bump = BumpType(rawValue: bumpType.lowercased()) else {
            Console.error("Invalid bump type '\(bumpType)'. Must be: major, minor, or patch")
            throw ExitCode.failure
        }

        // Resolve paths
        let frameworkURL = URL(fileURLWithPath: frameworkPath).standardizedFileURL
        let versioningPath = frameworkURL
            .appendingPathComponent("SCALS/Document/DocumentVersioning.swift")
        let snapshotsPath = frameworkURL
            .appendingPathComponent("SCALS/IR/Snapshots")
        let policyPath = snapshotsPath
            .appendingPathComponent("SnapshotPolicy.md")

        // Header
        Console.section("SCALS IR Version Bump Tool")

        // Parse current version
        guard FileManager.default.fileExists(atPath: versioningPath.path) else {
            Console.error("DocumentVersioning.swift not found at: \(versioningPath.path)")
            throw ExitCode.failure
        }

        let currentVersion: SemanticVersion
        do {
            currentVersion = try VersionParser.parseVersion(from: versioningPath, property: "currentIR")
        } catch {
            Console.error("Failed to parse current version: \(error)")
            throw ExitCode.failure
        }

        let newVersion = VersionParser.calculateNewVersion(currentVersion, bumpType: bump)

        print("Current IR Version: \(currentVersion.string)")
        print("New IR Version: \(newVersion.string) (\(bump.displayName) bump)")

        // Pre-bump checks
        Console.subsection("Pre-bump Checks")

        // Git check
        if !skipGitCheck {
            do {
                let repoRoot = try GitUtilities.repositoryRoot(from: frameworkURL.path)

                // Check for uncommitted changes in IR
                if try GitUtilities.hasUncommittedChanges(in: ["SCALS/IR"], workingDirectory: repoRoot) {
                    Console.warning("Uncommitted changes in SCALS/IR directory")
                    if verbose {
                        Console.info("  Consider committing IR changes before version bump")
                    }
                }

                // General uncommitted changes
                if try GitUtilities.hasUncommittedChanges(in: repoRoot) {
                    Console.warning("Git working directory has uncommitted changes")
                } else {
                    Console.success("Git working directory clean")
                }
            } catch {
                Console.warning("Could not check git status: \(error)")
            }
        } else {
            Console.info("Git check skipped")
        }

        Console.success("Current version parseable")

        // Check for existing snapshot
        let newSnapshotDir = snapshotsPath.appendingPathComponent("v\(currentVersion.underscored)")
        if FileManager.default.fileExists(atPath: newSnapshotDir.path) {
            Console.success("Snapshot exists for v\(currentVersion.string)")
        } else {
            Console.warning("No snapshot exists for v\(currentVersion.string) (will be created)")
        }

        // Detect IR changes
        var detectedChanges: [FileChange] = []
        do {
            let repoRoot = try GitUtilities.repositoryRoot(from: frameworkURL.path)
            if let lastTag = try GitUtilities.lastTag(withPrefix: "ir-v", workingDirectory: repoRoot) {
                detectedChanges = try ChangeDetector.detectChanges(
                    in: "SCALS/IR",
                    since: lastTag,
                    workingDirectory: repoRoot
                )
                if !detectedChanges.isEmpty {
                    Console.info("\(detectedChanges.count) IR changes detected since \(lastTag)")
                } else {
                    Console.info("No IR changes detected since \(lastTag)")
                }
            } else {
                Console.info("No previous IR version tag found")
            }
        } catch {
            if verbose {
                Console.warning("Could not detect changes: \(error)")
            }
        }

        // Show detected changes
        if !detectedChanges.isEmpty && verbose {
            Console.subsection("Detected Changes")
            for change in detectedChanges.prefix(10) {
                print("  • \(change.path)")
            }
            if detectedChanges.count > 10 {
                print("  ... and \(detectedChanges.count - 10) more")
            }
        }

        // Confirmation
        Console.subsection("Confirmation Required")
        print("")
        print("This will bump IR version \(currentVersion.string) -> \(newVersion.string)")
        print("")
        print("IR version changes affect ALL renderers:")
        print("  - SwiftUI Renderer")
        print("  - UIKit Renderer")
        print("  - HTML Renderer")
        print("  - iOS26 HTML Renderer")
        print("")

        if dryRun {
            Console.info("DRY RUN - No changes will be made")
            printDryRunSummary(
                currentVersion: currentVersion,
                newVersion: newVersion,
                bump: bump,
                skipSnapshot: skipSnapshot,
                snapshotsPath: snapshotsPath
            )
            return
        }

        // Get confirmation
        if !force {
            if bump == .major {
                guard ConfirmationPrompt.confirmMajorBump(newVersion: newVersion, versionType: "IR") else {
                    Console.error("Major version bump cancelled")
                    throw ExitCode.failure
                }
            } else {
                guard ConfirmationPrompt.confirm("") else {
                    Console.error("Version bump cancelled")
                    throw ExitCode.failure
                }
            }
        }

        // Perform bump
        Console.subsection("Performing Bump")

        // 1. Update DocumentVersioning.swift
        do {
            try VersionUpdater.updateVersion(
                in: versioningPath,
                property: "currentIR",
                newVersion: newVersion,
                addConstant: true
            )
            Console.success("Updated DocumentVersioning.swift")
        } catch {
            Console.error("Failed to update DocumentVersioning.swift: \(error)")
            throw ExitCode.failure
        }

        // 2. Create snapshot (for major/minor bumps)
        if !skipSnapshot && (bump == .major || bump == .minor) {
            let snapshotDir = snapshotsPath.appendingPathComponent("v\(currentVersion.underscored)")

            // Only create if doesn't exist
            if !FileManager.default.fileExists(atPath: snapshotDir.path) {
                do {
                    _ = try SnapshotCreator.createSnapshotDirectory(for: currentVersion, in: snapshotsPath)
                    Console.success("Created snapshot directory v\(currentVersion.underscored)")

                    try SnapshotCreator.generateIRTypesSnapshot(for: currentVersion, in: snapshotDir)
                    Console.success("Created snapshot v\(currentVersion.underscored)/IRTypesV\(currentVersion.underscored).swift")

                    let changesDesc = message ?? "TODO: Document changes"
                    try SnapshotCreator.generateRenderTreeSnapshot(
                        for: currentVersion,
                        in: snapshotDir,
                        changesDescription: changesDesc
                    )
                    Console.success("Created snapshot v\(currentVersion.underscored)/RenderTreeV\(currentVersion.underscored).swift")

                    try SnapshotCreator.setReadOnly(at: snapshotDir)
                    Console.success("Set snapshot files to read-only")
                } catch VersionError.snapshotAlreadyExists(_) {
                    Console.info("Snapshot v\(currentVersion.underscored) already exists, skipping")
                } catch {
                    Console.warning("Failed to create snapshot: \(error)")
                }
            } else {
                Console.info("Snapshot v\(currentVersion.underscored) already exists, skipping")
            }

            // Update SnapshotPolicy.md
            if FileManager.default.fileExists(atPath: policyPath.path) {
                do {
                    let changesDesc = message ?? "- TODO: Document changes from previous version"
                    try SnapshotPolicyUpdater.addVersionEntry(
                        version: newVersion,
                        previousVersion: currentVersion,
                        changesDescription: changesDesc,
                        to: policyPath
                    )
                    Console.success("Updated SnapshotPolicy.md")
                } catch {
                    Console.warning("Failed to update SnapshotPolicy.md: \(error)")
                }
            }
        } else if skipSnapshot {
            Console.info("Snapshot creation skipped (--skip-snapshot)")
        } else {
            Console.info("Snapshot not created for patch bump")
        }

        // Suggested next steps
        Console.subsection("Suggested Next Steps")
        Console.info("1. Review changes: git diff")
        Console.info("2. Commit: git commit -am 'Bump IR version to \(newVersion.string)'")
        Console.info("3. Tag: git tag ir-v\(newVersion.string)")

        print("")
        Console.success("SUCCESS: IR version bumped to \(newVersion.string)")
    }

    // MARK: - Helpers

    private func printDryRunSummary(
        currentVersion: SemanticVersion,
        newVersion: SemanticVersion,
        bump: BumpType,
        skipSnapshot: Bool,
        snapshotsPath: URL
    ) {
        Console.subsection("Dry Run Summary")
        print("")
        print("Would perform the following actions:")
        print("")
        print("1. Update DocumentVersioning.swift:")
        print("   - Change currentIR from \(currentVersion.string) to \(newVersion.string)")
        print("   - Add version constant v\(newVersion.underscored)")

        if !skipSnapshot && (bump == .major || bump == .minor) {
            let snapshotDir = snapshotsPath.appendingPathComponent("v\(currentVersion.underscored)")
            if !FileManager.default.fileExists(atPath: snapshotDir.path) {
                print("")
                print("2. Create snapshot for v\(currentVersion.string):")
                print("   - Create SCALS/IR/Snapshots/v\(currentVersion.underscored)/")
                print("   - Generate IRTypesV\(currentVersion.underscored).swift")
                print("   - Generate RenderTreeV\(currentVersion.underscored).swift")
                print("   - Set files to read-only (chmod 444)")
            } else {
                print("")
                print("2. Snapshot v\(currentVersion.underscored) already exists (would skip)")
            }

            print("")
            print("3. Update SnapshotPolicy.md with v\(newVersion.string) entry")
        }

        print("")
        Console.info("No changes made (dry run)")
    }
}
