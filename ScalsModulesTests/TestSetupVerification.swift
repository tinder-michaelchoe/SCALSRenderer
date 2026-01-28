//
//  TestSetupVerification.swift
//  ScalsModulesTests
//
//  Created to verify XCTest and SnapshotTesting setup
//

import XCTest
import SnapshotTesting
@testable import ScalsModules

/// Verification test to ensure XCTest and SnapshotTesting are properly configured
final class TestSetupVerification: XCTestCase {

    func testXCTestIsAvailable() {
        // This test verifies XCTest is working
        XCTAssertTrue(true, "XCTest is available")
    }

    func testSnapshotTestingIsAvailable() {
        // This test verifies SnapshotTesting is available
        // We create a simple snapshotting strategy to confirm the module is linked
        let _ = Snapshotting<String, String>.lines
        XCTAssertTrue(true, "SnapshotTesting module is available")
    }
}
