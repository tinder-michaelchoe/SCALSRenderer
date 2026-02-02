//
//  RenderTreeVersionTests.swift
//  SCALSTests
//
//  Tests for IR version in RenderTree.
//

import Foundation
import Testing
@testable import SCALS
@testable import ScalsModules

@Suite("RenderTree Versioning")
struct RenderTreeVersionTests {

    @Test("RenderTree has IR version with default")
    func renderTreeHasIRVersion() {
        let tree = RenderTree(
            root: RootNode(),
            stateStore: StateStore(),
            actions: [:]
        )

        #expect(tree.irVersion == DocumentVersion.currentIR)
    }

    @Test("RenderTree can be created with custom IR version")
    func renderTreeCustomIRVersion() {
        let customVersion = DocumentVersion(2, 0, 0)

        let tree = RenderTree(
            root: RootNode(),
            stateStore: StateStore(),
            actions: [:],
            irVersion: customVersion
        )

        #expect(tree.irVersion == customVersion)
    }

    @Test("Default IR version is v0.1.0")
    func defaultIRVersion() {
        let tree = RenderTree(
            root: RootNode(),
            stateStore: StateStore(),
            actions: [:]
        )

        #expect(tree.irVersion == DocumentVersion(0, 1, 0))
    }

    @Test("Resolver sets current IR version")
    @MainActor
    func resolverSetsCurrentIRVersion() throws {
        let json = """
        {
            "id": "test",
            "version": "0.1.0",
            "root": {"children": []}
        }
        """

        let document = try Document.Definition(jsonString: json)
        let resolver = Resolver(
            document: document,
            componentRegistry: .default
        )

        let tree = try resolver.resolve()

        #expect(tree.irVersion == DocumentVersion.currentIR)
    }

    @Test("IR version can be compared for compatibility check")
    func irVersionCompatibilityCheck() {
        let tree = RenderTree(
            root: RootNode(),
            stateStore: StateStore(),
            actions: [:],
            irVersion: DocumentVersion(1, 5, 0)
        )

        // Simulating a renderer that supports v1.0.0
        let rendererVersion = DocumentVersion(1, 0, 0)

        // Tree's minor version is higher but major is same = compatible
        #expect(tree.irVersion.major == rendererVersion.major)
        #expect(tree.irVersion >= rendererVersion)
    }

    @Test("Major version mismatch indicates incompatibility")
    func majorVersionMismatch() {
        let tree = RenderTree(
            root: RootNode(),
            stateStore: StateStore(),
            actions: [:],
            irVersion: DocumentVersion(2, 0, 0)
        )

        let rendererVersion = DocumentVersion(1, 9, 9)

        // Major version mismatch = incompatible
        #expect(tree.irVersion.major > rendererVersion.major)
    }
}
