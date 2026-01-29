//
//  SnapshotAssertions.swift
//  ScalsModulesTests
//
//  Custom snapshot assertion helpers that save to external snapshot directory.
//

import XCTest
import SnapshotTesting

/// Custom snapshot assertion that saves to external directory
/// - Parameters:
///   - value: The value to snapshot
///   - snapshotting: The snapshotting strategy
///   - name: Optional name for the snapshot
///   - record: Whether to record/update the snapshot
///   - snapshotDirectory: Custom directory for snapshots (defaults to external directory)
///   - timeout: Timeout for async snapshotting
///   - file: Source file (auto-populated)
///   - testName: Test function name (auto-populated)
///   - line: Source line (auto-populated)
func assertSnapshot<Value, Format>(
    of value: @autoclosure () throws -> Value,
    as snapshotting: Snapshotting<Value, Format>,
    named name: String? = nil,
    record recording: Bool? = nil,
    snapshotDirectory: String? = SnapshotConfig.defaultDirectory,
    timeout: TimeInterval = 5,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
) {

    let failure: String? = verifySnapshot(
        of: try value(),
        as: snapshotting,
        named: name,
        record: recording,
        snapshotDirectory: snapshotDirectory,
        timeout: timeout,
        file: file,
        testName: testName,
        line: line
    )

    if let message = failure {
        XCTFail(message, file: file, line: line)
    }
}

/// Configuration for snapshot testing
enum SnapshotConfig {
    /// Default snapshot directory (external to repository)
    static let defaultDirectory = "/Users/michael.choe/Desktop/PROGRAMMING/ScalsRenderer-Snapshots/__Snapshots__"
}
