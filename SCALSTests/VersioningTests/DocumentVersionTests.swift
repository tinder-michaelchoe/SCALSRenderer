//
//  DocumentVersionTests.swift
//  SCALSTests
//
//  Tests for DocumentVersion parsing and comparison.
//

import Foundation
import Testing
@testable import SCALS

@Suite("DocumentVersion")
struct DocumentVersionTests {

    // MARK: - Parsing

    @Test("Parse valid version string with major.minor.patch")
    func parseValidVersion() {
        let version = DocumentVersion(string: "1.2.3")
        #expect(version != nil)
        #expect(version?.major == 1)
        #expect(version?.minor == 2)
        #expect(version?.patch == 3)
    }

    @Test("Parse version without patch defaults to 0")
    func parseVersionWithoutPatch() {
        let version = DocumentVersion(string: "1.2")
        #expect(version != nil)
        #expect(version?.major == 1)
        #expect(version?.minor == 2)
        #expect(version?.patch == 0)
    }

    @Test("Parse version with leading zeros")
    func parseVersionWithLeadingZeros() {
        let version = DocumentVersion(string: "0.1.0")
        #expect(version != nil)
        #expect(version?.major == 0)
        #expect(version?.minor == 1)
        #expect(version?.patch == 0)
    }

    @Test("Invalid version strings return nil")
    func invalidVersionStrings() {
        #expect(DocumentVersion(string: "1") == nil)
        #expect(DocumentVersion(string: "abc") == nil)
        #expect(DocumentVersion(string: "") == nil)
        #expect(DocumentVersion(string: "1.2.3.4") == nil)  // Too many parts
        #expect(DocumentVersion(string: "v1.2.3") == nil)   // Invalid prefix
        #expect(DocumentVersion(string: "1.a.3") == nil)    // Non-numeric
    }

    // MARK: - Comparison

    @Test("Version equality")
    func versionEquality() {
        let v1 = DocumentVersion(0, 1, 0)
        let v2 = DocumentVersion(0, 1, 0)
        let v3 = DocumentVersion(0, 1, 1)

        #expect(v1 == v2)
        #expect(v1 != v3)
    }

    @Test("Version less than comparison")
    func versionLessThan() {
        let v0_1_0 = DocumentVersion(0, 1, 0)
        let v0_1_1 = DocumentVersion(0, 1, 1)
        let v0_2_0 = DocumentVersion(0, 2, 0)
        let v1_0_0 = DocumentVersion(1, 0, 0)

        #expect(v0_1_0 < v0_1_1)
        #expect(v0_1_1 < v0_2_0)
        #expect(v0_2_0 < v1_0_0)
        #expect(v0_1_0 < v1_0_0)
    }

    @Test("Major version takes precedence in comparison")
    func majorVersionPrecedence() {
        let v1_9_9 = DocumentVersion(1, 9, 9)
        let v2_0_0 = DocumentVersion(2, 0, 0)

        #expect(v1_9_9 < v2_0_0)
    }

    @Test("Version greater than comparison")
    func versionGreaterThan() {
        let v1_0_0 = DocumentVersion(1, 0, 0)
        let v0_9_9 = DocumentVersion(0, 9, 9)

        #expect(v1_0_0 > v0_9_9)
    }

    // MARK: - String Representation

    @Test("Version string representation")
    func stringRepresentation() {
        let version = DocumentVersion(1, 2, 3)
        #expect(version.string == "1.2.3")
    }

    @Test("Version 0.1.0 string representation")
    func v0_1_0StringRepresentation() {
        let version = DocumentVersion(0, 1, 0)
        #expect(version.string == "0.1.0")
    }

    // MARK: - Constants

    @Test("Current version constant is valid")
    func currentVersionConstant() {
        #expect(DocumentVersion.current.major >= 0)
        #expect(DocumentVersion.current.minor >= 0)
        #expect(DocumentVersion.current.patch >= 0)
    }

    @Test("Current IR version constant is valid")
    func currentIRVersionConstant() {
        #expect(DocumentVersion.currentIR.major >= 0)
        #expect(DocumentVersion.currentIR.minor >= 0)
        #expect(DocumentVersion.currentIR.patch >= 0)
    }

    @Test("v0_1_0 constant equals explicit version")
    func v0_1_0Constant() {
        #expect(DocumentVersion.v0_1_0 == DocumentVersion(0, 1, 0))
    }

    // MARK: - Codable

    @Test("Version encodes and decodes correctly")
    func codableRoundTrip() throws {
        let original = DocumentVersion(1, 2, 3)

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DocumentVersion.self, from: data)

        #expect(original == decoded)
    }

    // MARK: - Hashable

    @Test("Equal versions have same hash")
    func hashableEquality() {
        let v1 = DocumentVersion(1, 2, 3)
        let v2 = DocumentVersion(1, 2, 3)

        #expect(v1.hashValue == v2.hashValue)
    }

    @Test("Version can be used in Set")
    func setUsage() {
        var versions: Set<DocumentVersion> = []
        versions.insert(DocumentVersion(0, 1, 0))
        versions.insert(DocumentVersion(0, 1, 0))  // Duplicate
        versions.insert(DocumentVersion(1, 0, 0))

        #expect(versions.count == 2)
    }
}
