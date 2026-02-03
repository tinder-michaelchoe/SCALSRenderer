//
//  main.swift
//  BumpDocumentVersion
//
//  CLI tool for bumping Document schema version.
//  Usage: scals-bump-document-version <major|minor|patch> [options]
//

import ArgumentParser
import Foundation
import ScalsToolsCore

@main
struct BumpDocumentVersion: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "scals-bump-document-version",
        abstract: "Bump SCALS Document schema version",
        discussion: """
            Bumps the Document schema version in DocumentVersioning.swift and optionally
            creates a snapshot of the current Document types for migration purposes.

            Document version represents the user-facing JSON API and can evolve
            more frequently than the IR version. Changes affect JSON parsing only.

            Examples:
              scals-bump-document-version minor -m "Added Slider component"
              scals-bump-document-version patch --dry-run
              scals-bump-document-version major --skip-snapshot
            """
    )

    @Argument(help: "Bump type: major, minor, or patch")
    var bumpType: String

    @Option(name: [.short, .customLong("message")], help: "Description of changes for changelog")
    var message: String?

    @Option(name: .long, help: "Path to SCALS framework (default: '..')")
    var frameworkPath: String = ".."

    @Flag(name: .long, help: "Skip snapshot creation")
    var skipSnapshot: Bool = false

    @Flag(name: .long, help: "Skip git uncommitted changes warning")
    var skipGitCheck: Bool = false

    @Flag(name: .long, help: "Show what would be done without making changes")
    var dryRun: Bool = false

    @Flag(name: [.short, .long], help: "Show verbose output")
    var verbose: Bool = false

    @Flag(name: .long, help: "Auto-generate migration guide (placeholder)")
    var generateMigration: Bool = false

    @Flag(name: .long, help: "Skip confirmations")
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
            .appendingPathComponent("SCALS/Document/Snapshots")
        let policyPath = snapshotsPath
            .appendingPathComponent("SnapshotPolicy.md")
        let changelogPath = frameworkURL
            .appendingPathComponent("SCALS/Document/CHANGELOG.md")

        // Header
        Console.section("SCALS Document Version Bump Tool")

        // Parse current version
        guard FileManager.default.fileExists(atPath: versioningPath.path) else {
            Console.error("DocumentVersioning.swift not found at: \(versioningPath.path)")
            throw ExitCode.failure
        }

        let currentVersion: SemanticVersion
        do {
            currentVersion = try VersionParser.parseVersion(from: versioningPath, property: "current")
        } catch {
            Console.error("Failed to parse current version: \(error)")
            throw ExitCode.failure
        }

        let newVersion = VersionParser.calculateNewVersion(currentVersion, bumpType: bump)

        print("Current Document Version: \(currentVersion.string)")
        print("New Document Version: \(newVersion.string) (\(bump.displayName) bump)")

        // Pre-bump checks
        Console.subsection("Pre-bump Checks")

        // Git check
        if !skipGitCheck {
            do {
                let repoRoot = try GitUtilities.repositoryRoot(from: frameworkURL.path)

                // Check for uncommitted changes in Document
                if try GitUtilities.hasUncommittedChanges(in: ["SCALS/Document"], workingDirectory: repoRoot) {
                    Console.warning("Uncommitted changes in SCALS/Document directory")
                    if verbose {
                        Console.info("  Consider committing Document changes before version bump")
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
        let existingSnapshotDir = snapshotsPath.appendingPathComponent("v\(currentVersion.underscored)")
        if FileManager.default.fileExists(atPath: existingSnapshotDir.path) {
            Console.success("Snapshot exists for v\(currentVersion.string)")
        } else {
            Console.warning("No snapshot exists for v\(currentVersion.string) (will be created)")
        }

        // Detect Document changes
        var detectedChanges: [FileChange] = []
        let newComponents: [String] = []
        var updatedComponents: [String] = []
        var newActions: [String] = []

        do {
            let repoRoot = try GitUtilities.repositoryRoot(from: frameworkURL.path)
            if let lastTag = try GitUtilities.lastTag(withPrefix: "doc-v", workingDirectory: repoRoot) {
                detectedChanges = try ChangeDetector.detectChanges(
                    in: "SCALS/Document",
                    since: lastTag,
                    workingDirectory: repoRoot
                )
                if !detectedChanges.isEmpty {
                    Console.info("\(detectedChanges.count) Document layer changes detected since \(lastTag)")

                    // Analyze changes for component/action additions
                    for change in detectedChanges {
                        let filename = (change.path as NSString).lastPathComponent
                        if filename.contains("Component") && filename.hasSuffix(".swift") {
                            let componentName = filename.replacingOccurrences(of: ".swift", with: "")
                                .replacingOccurrences(of: "Component", with: "")
                            updatedComponents.append(componentName)
                        }
                        if filename.contains("Action") {
                            newActions.append(filename)
                        }
                    }
                } else {
                    Console.info("No Document changes detected since \(lastTag)")
                }
            } else {
                Console.info("No previous Document version tag found")
            }
        } catch {
            if verbose {
                Console.warning("Could not detect changes: \(error)")
            }
        }

        // Show detected changes
        if verbose && (!newComponents.isEmpty || !updatedComponents.isEmpty || !newActions.isEmpty) {
            Console.subsection("Detected Changes")

            if !newComponents.isEmpty {
                print("")
                print("  New Components:")
                for component in newComponents {
                    print("    • \(component) component added")
                }
            }

            if !updatedComponents.isEmpty {
                print("")
                print("  Updated Components:")
                for component in updatedComponents {
                    print("    • \(component)")
                }
            }

            if !newActions.isEmpty {
                print("")
                print("  New/Updated Actions:")
                for action in newActions {
                    print("    • \(action)")
                }
            }
        }

        // Confirmation
        Console.subsection("Confirmation Required")
        print("")
        print("This will bump Document version \(currentVersion.string) -> \(newVersion.string)")
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
                print("MAJOR version bump indicates breaking changes to JSON API.")
                print("Existing SCALS documents may need updates.")
                print("")
                print("Type 'MAJOR' to confirm major version bump: ", terminator: "")
                guard let response = readLine()?.trimmingCharacters(in: .whitespaces),
                      response == "MAJOR" else {
                    Console.error("Major version bump cancelled")
                    throw ExitCode.failure
                }
            }

            guard ConfirmationPrompt.confirm("") else {
                Console.error("Version bump cancelled")
                throw ExitCode.failure
            }
        }

        // Perform bump
        Console.subsection("Performing Bump")

        // 1. Update DocumentVersioning.swift
        do {
            try VersionUpdater.updateVersion(
                in: versioningPath,
                property: "current",
                newVersion: newVersion,
                addConstant: false
            )
            Console.success("Updated DocumentVersioning.swift")
        } catch {
            Console.error("Failed to update DocumentVersioning.swift: \(error)")
            throw ExitCode.failure
        }

        // 2. Update CHANGELOG.md (on every bump)
        if FileManager.default.fileExists(atPath: changelogPath.path) {
            do {
                let changesDesc = message ?? "- TODO: Document changes"
                try ChangelogUpdater.addVersionEntry(
                    version: newVersion,
                    changesDescription: changesDesc,
                    to: changelogPath
                )
                Console.success("Updated CHANGELOG.md")
            } catch {
                Console.warning("Failed to update CHANGELOG.md: \(error)")
            }
        } else {
            Console.warning("CHANGELOG.md not found at \(changelogPath.path)")
        }

        // 3. Create snapshot (for major/minor bumps)
        if !skipSnapshot && (bump == .major || bump == .minor) {
            let snapshotDir = snapshotsPath.appendingPathComponent("v\(currentVersion.underscored)")

            // Only create if doesn't exist
            if !FileManager.default.fileExists(atPath: snapshotDir.path) {
                do {
                    _ = try DocumentSnapshotCreator.createSnapshotDirectory(for: currentVersion, in: snapshotsPath)
                    Console.success("Created snapshot directory v\(currentVersion.underscored)")

                    try DocumentSnapshotCreator.generateDocumentTypesSnapshot(for: currentVersion, in: snapshotDir)
                    Console.success("Created snapshot v\(currentVersion.underscored)/DocumentTypesV\(currentVersion.underscored).swift")

                    let changesDesc = message ?? "TODO: Document changes"
                    try DocumentSnapshotCreator.generateComponentsSnapshot(
                        for: currentVersion,
                        in: snapshotDir,
                        changesDescription: changesDesc
                    )
                    Console.success("Created snapshot v\(currentVersion.underscored)/ComponentsV\(currentVersion.underscored).swift")

                    try DocumentSnapshotCreator.setReadOnly(at: snapshotDir)
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

        // Generate migration guide if requested
        if generateMigration {
            Console.info("Migration guide generation not yet implemented")
            // TODO: Implement migration guide generation
        }

        // Suggested next steps
        Console.subsection("Suggested Next Steps")
        Console.info("1. Review changes: git diff")
        Console.info("2. Update documentation if needed")

        if !newComponents.isEmpty {
            Console.info("3. Run: scals-reference-generator (\(newComponents.count) new components)")
            Console.info("4. Commit: git commit -am 'Bump Document version to \(newVersion.string)'")
            Console.info("5. Tag: git tag doc-v\(newVersion.string)")
        } else {
            Console.info("3. Commit: git commit -am 'Bump Document version to \(newVersion.string)'")
            Console.info("4. Tag: git tag doc-v\(newVersion.string)")
        }

        print("")
        Console.success("SUCCESS: Document version bumped to \(newVersion.string)")
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
        print("   - Change current from \(currentVersion.string) to \(newVersion.string)")

        print("")
        print("2. Update CHANGELOG.md with v\(newVersion.string) entry")

        var stepNum = 3

        if !skipSnapshot && (bump == .major || bump == .minor) {
            let snapshotDir = snapshotsPath.appendingPathComponent("v\(currentVersion.underscored)")
            if !FileManager.default.fileExists(atPath: snapshotDir.path) {
                print("")
                print("\(stepNum). Create snapshot for v\(currentVersion.string):")
                print("   - Create SCALS/Document/Snapshots/v\(currentVersion.underscored)/")
                print("   - Generate DocumentTypesV\(currentVersion.underscored).swift")
                print("   - Generate ComponentsV\(currentVersion.underscored).swift")
                print("   - Set files to read-only (chmod 444)")
            } else {
                print("")
                print("\(stepNum). Snapshot v\(currentVersion.underscored) already exists (would skip)")
            }
            stepNum += 1

            print("")
            print("\(stepNum). Update SnapshotPolicy.md with v\(newVersion.string) entry")
            stepNum += 1
        }

        if generateMigration {
            print("")
            print("\(stepNum). Generate migration guide (not yet implemented)")
        }

        print("")
        Console.info("No changes made (dry run)")
    }
}
