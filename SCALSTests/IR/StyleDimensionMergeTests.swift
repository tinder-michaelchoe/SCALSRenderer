//
//  StyleDimensionMergeTests.swift
//  SCALSTests
//
//  Unit tests for dimension property merging from Document.Style to IR.Style.
//

import Foundation
import Testing
@testable import SCALS

// MARK: - Dimension Merge Tests

struct StyleDimensionMergeTests {

    @Test func mergesFractionalDimensions() {
        let documentStyle = Document.Style(
            width: .fractional(0.8),
            height: .absolute(200)
        )

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.width == .fractional(0.8))
        #expect(irStyle.height == .absolute(200))
    }

    @Test func mergesAbsoluteDimensions() {
        let documentStyle = Document.Style(
            width: .absolute(150),
            height: .absolute(100),
            minWidth: .absolute(80),
            maxWidth: .absolute(300)
        )

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.width == .absolute(150))
        #expect(irStyle.height == .absolute(100))
        #expect(irStyle.minWidth == .absolute(80))
        #expect(irStyle.maxWidth == .absolute(300))
    }

    @Test func mergesMixedDimensions() {
        let documentStyle = Document.Style(
            width: .fractional(0.9),
            height: .absolute(200),
            minWidth: .absolute(300),
            maxWidth: .fractional(0.95)
        )

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.width == .fractional(0.9))
        #expect(irStyle.height == .absolute(200))
        #expect(irStyle.minWidth == .absolute(300))
        #expect(irStyle.maxWidth == .fractional(0.95))
    }

    @Test func doesNotMergeNilDimensions() {
        let documentStyle = Document.Style(fontSize: 16)

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.width == nil)
        #expect(irStyle.height == nil)
        #expect(irStyle.minWidth == nil)
        #expect(irStyle.minHeight == nil)
        #expect(irStyle.maxWidth == nil)
        #expect(irStyle.maxHeight == nil)
    }
}

// MARK: - Dimension Inheritance Tests

struct StyleDimensionInheritanceTests {

    @Test func childDimensionsOverrideParentDimensions() {
        let parentStyle = Document.Style(
            width: .absolute(100),
            height: .absolute(200)
        )

        let childStyle = Document.Style(
            width: .fractional(0.5)
            // height not specified - should inherit
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)
        irStyle.merge(from: childStyle)

        #expect(irStyle.width == .fractional(0.5))
        #expect(irStyle.height == .absolute(200))
    }

    @Test func childCanOverrideAbsoluteWithFractional() {
        let parentStyle = Document.Style(
            width: .absolute(300),
            minWidth: .absolute(200),
            maxWidth: .absolute(500)
        )

        let childStyle = Document.Style(
            width: .fractional(0.8),
            minWidth: .fractional(0.3)
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)
        irStyle.merge(from: childStyle)

        #expect(irStyle.width == .fractional(0.8))
        #expect(irStyle.minWidth == .fractional(0.3))
        #expect(irStyle.maxWidth == .absolute(500)) // Inherited from parent
    }

    @Test func childCanOverrideFractionalWithAbsolute() {
        let parentStyle = Document.Style(
            width: .fractional(0.9),
            height: .fractional(0.5)
        )

        let childStyle = Document.Style(
            width: .absolute(400)
            // height not specified - should inherit fractional
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)
        irStyle.merge(from: childStyle)

        #expect(irStyle.width == .absolute(400))
        #expect(irStyle.height == .fractional(0.5))
    }

    @Test func dimensionsMergeWithOtherStyleProperties() {
        let styleWithEverything = Document.Style(
            fontSize: 16,
            backgroundColor: "#FFFFFF",
            cornerRadius: 8,
            borderWidth: 1,
            width: .fractional(0.8),
            height: .absolute(150),
            minWidth: .absolute(200),
            maxWidth: .fractional(0.95),
            padding: Document.Padding(horizontal: 16, vertical: 12)
        )

        var irStyle = IR.Style()
        irStyle.merge(from: styleWithEverything)

        // Verify dimension properties merged
        #expect(irStyle.width == .fractional(0.8))
        #expect(irStyle.height == .absolute(150))
        #expect(irStyle.minWidth == .absolute(200))
        #expect(irStyle.maxWidth == .fractional(0.95))

        // Verify other properties also merged correctly
        #expect(irStyle.fontSize == 16)
        #expect(irStyle.backgroundColor != nil)
        #expect(irStyle.cornerRadius == 8)
        #expect(irStyle.borderWidth == 1)
        #expect(irStyle.paddingLeading == 16)
        #expect(irStyle.paddingTop == 12)
    }
}
