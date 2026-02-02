//
//  Validate.swift
//  ScalsTools
//
//  Validates SCALS JSON documents for version field and format.
//  Can be used standalone or integrated with CI/CD pipelines.
//

import ArgumentParser
import Foundation

@main
struct Validate: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "scals-validate",
        abstract: "Validates SCALS JSON documents for version field and format",
        discussion: """
            Validates JSON documents to ensure they include proper version fields.
            Can validate individual files, directories, or staged git files.

            Exit codes:
              0 - All validations passed
              1 - Validation errors found
            """
    )

    @Flag(name: .long, help: "Only validate staged git files")
    var staged: Bool = false

    @Flag(name: .long, help: "Require version field (error if missing)")
    var requireVersion: Bool = false

    @Flag(name: .shortAndLong, help: "Show verbose output")
    var verbose: Bool = false

    @Argument(help: "Files or directories to validate (default: SCALS/ ScalsModules/)")
    var paths: [String] = []

    mutating func run() throws {
        var hasErrors = false
        var hasWarnings = false
        var validCount = 0
        var totalCount = 0

        // Get files to validate
        let files: [String]
        if staged {
            files = getStagedJSONFiles()
        } else if paths.isEmpty {
            files = getJSONFiles(in: ["SCALS", "ScalsModules", "ScalsExamples"])
        } else {
            files = paths.flatMap { getJSONFiles(in: [$0]) }
        }

        if files.isEmpty {
            print("✓ No JSON files to validate")
            return
        }

        if verbose {
            print("Validating \(files.count) JSON file(s)...\n")
        }

        for filePath in files {
            totalCount += 1

            guard let data = FileManager.default.contents(atPath: filePath),
                  let jsonString = String(data: data, encoding: .utf8) else {
                print("⚠️  Cannot read: \(filePath)")
                hasWarnings = true
                continue
            }

            // Check if this looks like a SCALS document (has "root" key)
            guard jsonString.contains("\"root\"") else {
                if verbose {
                    print("⏭  Skipping (not a SCALS document): \(filePath)")
                }
                continue
            }

            // Parse JSON
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("❌ Invalid JSON: \(filePath)")
                hasErrors = true
                continue
            }

            // Check for version field
            if let version = jsonObject["version"] as? String {
                // Validate version format (semver)
                if isValidSemver(version) {
                    if verbose {
                        print("✓ \(filePath) (v\(version))")
                    }
                    validCount += 1
                } else {
                    print("⚠️  Invalid version format '\(version)': \(filePath)")
                    print("   Expected semver format: \"0.1.0\"")
                    hasWarnings = true
                }
            } else {
                if requireVersion {
                    print("❌ Missing version: \(filePath)")
                    print("   Add: \"version\": \"0.1.0\"")
                    hasErrors = true
                } else {
                    print("⚠️  Missing version: \(filePath)")
                    print("   Add: \"version\": \"0.1.0\"")
                    hasWarnings = true
                    validCount += 1  // Still valid, just a warning
                }
            }

            // Check for requirements section (informational)
            if verbose, let requirements = jsonObject["requirements"] as? [String: Any] {
                if let minVersion = requirements["minimumVersion"] as? String {
                    if !isValidSemver(minVersion) {
                        print("   ⚠️  Invalid minimumVersion: '\(minVersion)'")
                        hasWarnings = true
                    }
                }
                if let components = requirements["components"] as? [String], !components.isEmpty {
                    print("   📦 Requires components: \(components.joined(separator: ", "))")
                }
                if let actions = requirements["actions"] as? [String], !actions.isEmpty {
                    print("   ⚡ Requires actions: \(actions.joined(separator: ", "))")
                }
            }
        }

        // Summary
        print("")
        if hasErrors {
            print("❌ Validation failed (\(validCount)/\(totalCount) valid)")
            throw ExitCode.failure
        } else if hasWarnings {
            print("⚠️  Validation passed with warnings (\(validCount)/\(totalCount) valid)")
        } else {
            print("✓ All validations passed (\(validCount)/\(totalCount))")
        }
    }

    // MARK: - Helpers

    /// Check if string is valid semver format
    private func isValidSemver(_ version: String) -> Bool {
        let semverPattern = #"^\d+\.\d+(\.\d+)?$"#
        return version.range(of: semverPattern, options: .regularExpression) != nil
    }

    /// Get staged JSON files from git
    private func getStagedJSONFiles() -> [String] {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = ["diff", "--cached", "--name-only", "--diff-filter=ACM"]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = FileHandle.nullDevice

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return []
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""

        return output
            .components(separatedBy: .newlines)
            .filter { $0.hasSuffix(".json") }
            .filter { !$0.isEmpty }
    }

    /// Get JSON files in directories
    private func getJSONFiles(in directories: [String]) -> [String] {
        var files: [String] = []
        let fileManager = FileManager.default

        for dir in directories {
            // Try as absolute path first, then relative
            let path = dir.hasPrefix("/") ? dir : FileManager.default.currentDirectoryPath + "/" + dir

            guard let enumerator = fileManager.enumerator(atPath: path) else {
                // Try as single file
                if fileManager.fileExists(atPath: path) && path.hasSuffix(".json") {
                    files.append(path)
                }
                continue
            }

            while let file = enumerator.nextObject() as? String {
                if file.hasSuffix(".json") {
                    files.append(path + "/" + file)
                }
            }
        }

        return files
    }
}
