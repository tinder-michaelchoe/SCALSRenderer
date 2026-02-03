//
//  GitUtilities.swift
//  ScalsToolsCore
//
//  Git integration utilities for CLI tools.
//

import Foundation

/// Git operations helper
public enum GitUtilities {

    /// Error types for git operations
    public enum GitError: Error, CustomStringConvertible {
        case notAGitRepository
        case commandFailed(String)
        case noOutput

        public var description: String {
            switch self {
            case .notAGitRepository:
                return "Not a git repository"
            case .commandFailed(let message):
                return "Git command failed: \(message)"
            case .noOutput:
                return "Git command produced no output"
            }
        }
    }

    /// Execute a git command and return the output
    /// - Parameters:
    ///   - arguments: Git command arguments
    ///   - workingDirectory: Working directory for the command
    /// - Returns: Command output as string
    public static func execute(
        _ arguments: [String],
        in workingDirectory: String? = nil
    ) throws -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = arguments

        if let dir = workingDirectory {
            process.currentDirectoryURL = URL(fileURLWithPath: dir)
        }

        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        try process.run()
        process.waitUntilExit()

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

        if process.terminationStatus != 0 {
            let errorOutput = String(data: errorData, encoding: .utf8) ?? "Unknown error"
            throw GitError.commandFailed(errorOutput.trimmingCharacters(in: .whitespacesAndNewlines))
        }

        guard let output = String(data: outputData, encoding: .utf8) else {
            throw GitError.noOutput
        }

        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Check if the working directory has uncommitted changes
    /// - Parameter workingDirectory: Working directory to check
    /// - Returns: True if there are uncommitted changes
    public static func hasUncommittedChanges(in workingDirectory: String? = nil) throws -> Bool {
        let output = try execute(["status", "--porcelain"], in: workingDirectory)
        return !output.isEmpty
    }

    /// Check if specific paths have uncommitted changes
    /// - Parameters:
    ///   - paths: Paths to check
    ///   - workingDirectory: Working directory
    /// - Returns: True if any of the paths have uncommitted changes
    public static func hasUncommittedChanges(
        in paths: [String],
        workingDirectory: String? = nil
    ) throws -> Bool {
        var args = ["status", "--porcelain", "--"]
        args.append(contentsOf: paths)
        let output = try execute(args, in: workingDirectory)
        return !output.isEmpty
    }

    /// Get the diff since a reference (tag, commit, branch)
    /// - Parameters:
    ///   - ref: Reference to diff against
    ///   - paths: Optional paths to limit the diff
    ///   - workingDirectory: Working directory
    /// - Returns: Diff output
    public static func diffSince(
        _ ref: String,
        paths: [String]? = nil,
        workingDirectory: String? = nil
    ) throws -> String {
        var args = ["diff", ref]
        if let paths = paths, !paths.isEmpty {
            args.append("--")
            args.append(contentsOf: paths)
        }
        return try execute(args, in: workingDirectory)
    }

    /// Get the names of changed files since a reference
    /// - Parameters:
    ///   - ref: Reference to compare against
    ///   - paths: Optional paths to limit the search
    ///   - workingDirectory: Working directory
    /// - Returns: Array of changed file paths
    public static func changedFilesSince(
        _ ref: String,
        paths: [String]? = nil,
        workingDirectory: String? = nil
    ) throws -> [String] {
        var args = ["diff", "--name-only", ref]
        if let paths = paths, !paths.isEmpty {
            args.append("--")
            args.append(contentsOf: paths)
        }
        let output = try execute(args, in: workingDirectory)
        guard !output.isEmpty else { return [] }
        return output.components(separatedBy: "\n").filter { !$0.isEmpty }
    }

    /// Get the last tag matching a prefix
    /// - Parameters:
    ///   - prefix: Tag prefix to match (e.g., "ir-v")
    ///   - workingDirectory: Working directory
    /// - Returns: Tag name or nil if no matching tag found
    public static func lastTag(
        withPrefix prefix: String,
        workingDirectory: String? = nil
    ) throws -> String? {
        do {
            // Get all tags sorted by version, filtered by prefix
            let args = ["tag", "-l", "\(prefix)*", "--sort=-v:refname"]
            let output = try execute(args, in: workingDirectory)
            guard !output.isEmpty else { return nil }
            return output.components(separatedBy: "\n").first
        } catch {
            return nil
        }
    }

    /// Check if a tag exists
    /// - Parameters:
    ///   - tag: Tag name to check
    ///   - workingDirectory: Working directory
    /// - Returns: True if the tag exists
    public static func tagExists(_ tag: String, in workingDirectory: String? = nil) throws -> Bool {
        do {
            _ = try execute(["rev-parse", "refs/tags/\(tag)"], in: workingDirectory)
            return true
        } catch {
            return false
        }
    }

    /// Get the current branch name
    /// - Parameter workingDirectory: Working directory
    /// - Returns: Current branch name
    public static func currentBranch(in workingDirectory: String? = nil) throws -> String {
        try execute(["rev-parse", "--abbrev-ref", "HEAD"], in: workingDirectory)
    }

    /// Get the repository root directory
    /// - Parameter workingDirectory: Working directory
    /// - Returns: Repository root path
    public static func repositoryRoot(from workingDirectory: String? = nil) throws -> String {
        try execute(["rev-parse", "--show-toplevel"], in: workingDirectory)
    }

    /// Check if in a git repository
    /// - Parameter workingDirectory: Working directory
    /// - Returns: True if in a git repository
    public static func isGitRepository(at workingDirectory: String? = nil) -> Bool {
        do {
            _ = try execute(["rev-parse", "--is-inside-work-tree"], in: workingDirectory)
            return true
        } catch {
            return false
        }
    }
}
