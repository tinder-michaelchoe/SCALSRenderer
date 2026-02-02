//
//  StyleShadowMergeTests.swift
//  SCALSTests
//
//  Unit tests for shadow property merging from Document.Style to IR.Style.
//

import Foundation
import Testing
@testable import SCALS

// MARK: - Shadow Merge Tests

struct StyleShadowMergeTests {

    @Test func mergesShadowFromDocument() {
        let documentStyle = Document.Style(
            shadow: Document.Shadow(
                color: "#000000",
                radius: 8,
                x: 0,
                y: 4
            )
        )

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.shadowColor != nil)
        #expect(irStyle.shadowRadius == 8)
        #expect(irStyle.shadowX == 0)
        #expect(irStyle.shadowY == 4)
    }

    @Test func mergesPartialShadow() {
        let documentStyle = Document.Style(
            shadow: Document.Shadow(
                color: "rgba(0, 0, 0, 0.1)",
                radius: 12
            )
        )

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.shadowColor != nil)
        #expect(irStyle.shadowRadius == 12)
        #expect(irStyle.shadowX == nil)
        #expect(irStyle.shadowY == nil)
    }

    @Test func doesNotMergeNilShadow() {
        let documentStyle = Document.Style(fontSize: 16)

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.shadowColor == nil)
        #expect(irStyle.shadowRadius == nil)
        #expect(irStyle.shadowX == nil)
        #expect(irStyle.shadowY == nil)
    }

    @Test func shadowColorParsesHexString() {
        let documentStyle = Document.Style(
            shadow: Document.Shadow(color: "#FF0000")
        )

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.shadowColor != nil)
        // The IR.Color should be able to parse the hex string
    }

    @Test func shadowColorParsesRgbaString() {
        let documentStyle = Document.Style(
            shadow: Document.Shadow(color: "rgba(0, 0, 0, 0.5)")
        )

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.shadowColor != nil)
        // The IR.Color should be able to parse the rgba string
    }

    @Test func mergesNegativeShadowOffsets() {
        let documentStyle = Document.Style(
            shadow: Document.Shadow(
                color: "#000000",
                radius: 4,
                x: -2,
                y: -3
            )
        )

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.shadowX == -2)
        #expect(irStyle.shadowY == -3)
    }
}

// MARK: - Shadow Inheritance Tests

struct StyleShadowInheritanceTests {

    @Test func childShadowOverridesParentShadow() {
        // Parent style with shadow
        let parentStyle = Document.Style(
            shadow: Document.Shadow(
                color: "#000000",
                radius: 4,
                x: 0,
                y: 2
            )
        )

        // Child style with different shadow
        let childStyle = Document.Style(
            shadow: Document.Shadow(
                color: "#FF0000",
                radius: 8,
                x: 2,
                y: 4
            )
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)
        irStyle.merge(from: childStyle)

        // Child shadow properties should completely override parent
        #expect(irStyle.shadowRadius == 8)
        #expect(irStyle.shadowX == 2)
        #expect(irStyle.shadowY == 4)
    }

    @Test func childPartialShadowOverridesSpecificProperties() {
        // Parent style with full shadow
        let parentStyle = Document.Style(
            shadow: Document.Shadow(
                color: "#000000",
                radius: 4,
                x: 0,
                y: 2
            )
        )

        // Child style with partial shadow (only radius and y)
        let childStyle = Document.Style(
            shadow: Document.Shadow(
                radius: 12,
                y: 6
            )
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)
        irStyle.merge(from: childStyle)

        // Color and x should remain from parent
        #expect(irStyle.shadowColor != nil)
        #expect(irStyle.shadowX == 0)

        // Radius and y should be from child
        #expect(irStyle.shadowRadius == 12)
        #expect(irStyle.shadowY == 6)
    }

    @Test func shadowPropertiesMergeIndependently() {
        // Parent with color and radius
        let parentStyle = Document.Style(
            shadow: Document.Shadow(
                color: "#000000",
                radius: 8
            )
        )

        // Child with x and y offsets
        let childStyle = Document.Style(
            shadow: Document.Shadow(
                x: 2,
                y: 4
            )
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)
        irStyle.merge(from: childStyle)

        // Should have all properties merged
        #expect(irStyle.shadowColor != nil)
        #expect(irStyle.shadowRadius == 8)
        #expect(irStyle.shadowX == 2)
        #expect(irStyle.shadowY == 4)
    }

    @Test func shadowMergesWithOtherStyleProperties() {
        let styleWithEverything = Document.Style(
            fontSize: 16,
            backgroundColor: "#FFFFFF",
            cornerRadius: 8,
            borderWidth: 1,
            shadow: Document.Shadow(
                color: "rgba(0, 0, 0, 0.1)",
                radius: 8,
                x: 0,
                y: 4
            ),
            padding: Document.Padding(horizontal: 16, vertical: 12)
        )

        var irStyle = IR.Style()
        irStyle.merge(from: styleWithEverything)

        // Verify shadow properties merged
        #expect(irStyle.shadowColor != nil)
        #expect(irStyle.shadowRadius == 8)
        #expect(irStyle.shadowX == 0)
        #expect(irStyle.shadowY == 4)

        // Verify other properties also merged correctly
        #expect(irStyle.fontSize == 16)
        #expect(irStyle.backgroundColor != nil)
        #expect(irStyle.cornerRadius == 8)
        #expect(irStyle.borderWidth == 1)
        #expect(irStyle.paddingLeading == 16)
        #expect(irStyle.paddingTop == 12)
    }

    @Test func emptyShadowClearsInheritedShadow() {
        // Parent style with shadow
        let parentStyle = Document.Style(
            shadow: Document.Shadow(
                color: "#000000",
                radius: 8,
                x: 0,
                y: 4
            )
        )

        // Child style with empty shadow (all properties nil)
        let childStyle = Document.Style(
            shadow: Document.Shadow()
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)

        // Verify parent shadow is set
        #expect(irStyle.shadowColor != nil)
        #expect(irStyle.shadowRadius == 8)
        #expect(irStyle.shadowX == 0)
        #expect(irStyle.shadowY == 4)

        // Merge child with empty shadow
        irStyle.merge(from: childStyle)

        // All shadow properties should be cleared
        #expect(irStyle.shadowColor == nil)
        #expect(irStyle.shadowRadius == nil)
        #expect(irStyle.shadowX == nil)
        #expect(irStyle.shadowY == nil)
    }

    @Test func emptyShadowOnlyAffectsShadowProperties() {
        // Parent style with shadow and other properties
        let parentStyle = Document.Style(
            fontSize: 16,
            backgroundColor: "#FFFFFF",
            cornerRadius: 8,
            shadow: Document.Shadow(
                color: "#000000",
                radius: 8,
                x: 0,
                y: 4
            )
        )

        // Child style with empty shadow only
        let childStyle = Document.Style(
            shadow: Document.Shadow()
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)
        irStyle.merge(from: childStyle)

        // Shadow should be cleared
        #expect(irStyle.shadowColor == nil)
        #expect(irStyle.shadowRadius == nil)
        #expect(irStyle.shadowX == nil)
        #expect(irStyle.shadowY == nil)

        // Other properties should remain
        #expect(irStyle.fontSize == 16)
        #expect(irStyle.backgroundColor != nil)
        #expect(irStyle.cornerRadius == 8)
    }
}
