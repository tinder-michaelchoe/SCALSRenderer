//
//  StylePaddingInheritanceTests.swift
//  SCALSTests
//
//  Unit tests for padding property merging and inheritance clearing.
//

import Foundation
import Testing
@testable import SCALS

// MARK: - Padding Merge Tests

struct StylePaddingMergeTests {

    @Test func mergesPaddingFromDocument() {
        let documentStyle = Document.Style(
            padding: Document.Padding(
                top: 10,
                bottom: 20,
                leading: 15,
                trailing: 25
            )
        )

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.paddingTop == 10)
        #expect(irStyle.paddingBottom == 20)
        #expect(irStyle.paddingLeading == 15)
        #expect(irStyle.paddingTrailing == 25)
    }

    @Test func mergesHorizontalVerticalPadding() {
        let documentStyle = Document.Style(
            padding: Document.Padding(
                horizontal: 16,
                vertical: 12
            )
        )

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.paddingTop == 12)
        #expect(irStyle.paddingBottom == 12)
        #expect(irStyle.paddingLeading == 16)
        #expect(irStyle.paddingTrailing == 16)
    }

    @Test func specificPaddingOverridesGeneral() {
        let documentStyle = Document.Style(
            padding: Document.Padding(
                top: 20,
                horizontal: 16,
                vertical: 12
            )
        )

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        // Top should use specific value (20), not vertical (12)
        #expect(irStyle.paddingTop == 20)
        #expect(irStyle.paddingBottom == 12)
        #expect(irStyle.paddingLeading == 16)
        #expect(irStyle.paddingTrailing == 16)
    }

    @Test func doesNotMergeNilPadding() {
        let documentStyle = Document.Style(fontSize: 16)

        var irStyle = IR.Style()
        irStyle.merge(from: documentStyle)

        #expect(irStyle.paddingTop == nil)
        #expect(irStyle.paddingBottom == nil)
        #expect(irStyle.paddingLeading == nil)
        #expect(irStyle.paddingTrailing == nil)
    }
}

// MARK: - Padding Inheritance Tests

struct StylePaddingInheritanceTests {

    @Test func childPaddingOverridesParentPadding() {
        // Parent style with padding
        let parentStyle = Document.Style(
            padding: Document.Padding(horizontal: 16, vertical: 12)
        )

        // Child style with different padding
        let childStyle = Document.Style(
            padding: Document.Padding(horizontal: 24, vertical: 20)
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)
        irStyle.merge(from: childStyle)

        // Child padding should override parent
        #expect(irStyle.paddingTop == 20)
        #expect(irStyle.paddingBottom == 20)
        #expect(irStyle.paddingLeading == 24)
        #expect(irStyle.paddingTrailing == 24)
    }

    @Test func childPartialPaddingOverridesSpecificSides() {
        // Parent style with full padding
        let parentStyle = Document.Style(
            padding: Document.Padding(
                top: 10,
                bottom: 10,
                leading: 10,
                trailing: 10
            )
        )

        // Child style with partial padding (only top and leading)
        let childStyle = Document.Style(
            padding: Document.Padding(
                top: 20,
                leading: 20
            )
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)
        irStyle.merge(from: childStyle)

        // Top and leading should be from child
        #expect(irStyle.paddingTop == 20)
        #expect(irStyle.paddingLeading == 20)

        // Bottom and trailing should remain from parent
        #expect(irStyle.paddingBottom == 10)
        #expect(irStyle.paddingTrailing == 10)
    }

    @Test func emptyPaddingClearsInheritedPadding() {
        // Parent style with padding
        let parentStyle = Document.Style(
            padding: Document.Padding(horizontal: 16, vertical: 12)
        )

        // Child style with empty padding (all properties nil)
        let childStyle = Document.Style(
            padding: Document.Padding()
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)

        // Verify parent padding is set
        #expect(irStyle.paddingTop == 12)
        #expect(irStyle.paddingBottom == 12)
        #expect(irStyle.paddingLeading == 16)
        #expect(irStyle.paddingTrailing == 16)

        // Merge child with empty padding
        irStyle.merge(from: childStyle)

        // All padding properties should be cleared
        #expect(irStyle.paddingTop == nil)
        #expect(irStyle.paddingBottom == nil)
        #expect(irStyle.paddingLeading == nil)
        #expect(irStyle.paddingTrailing == nil)
    }

    @Test func emptyPaddingOnlyAffectsPaddingProperties() {
        // Parent style with padding and other properties
        let parentStyle = Document.Style(
            fontSize: 16,
            backgroundColor: "#FFFFFF",
            cornerRadius: 8,
            padding: Document.Padding(horizontal: 16, vertical: 12)
        )

        // Child style with empty padding only
        let childStyle = Document.Style(
            padding: Document.Padding()
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)
        irStyle.merge(from: childStyle)

        // Padding should be cleared
        #expect(irStyle.paddingTop == nil)
        #expect(irStyle.paddingBottom == nil)
        #expect(irStyle.paddingLeading == nil)
        #expect(irStyle.paddingTrailing == nil)

        // Other properties should remain
        #expect(irStyle.fontSize == 16)
        #expect(irStyle.backgroundColor != nil)
        #expect(irStyle.cornerRadius == 8)
    }

    @Test func paddingMergesWithOtherStyleProperties() {
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

        // Verify padding properties merged
        #expect(irStyle.paddingTop == 12)
        #expect(irStyle.paddingBottom == 12)
        #expect(irStyle.paddingLeading == 16)
        #expect(irStyle.paddingTrailing == 16)

        // Verify other properties also merged correctly
        #expect(irStyle.fontSize == 16)
        #expect(irStyle.backgroundColor != nil)
        #expect(irStyle.cornerRadius == 8)
        #expect(irStyle.borderWidth == 1)
        #expect(irStyle.shadowColor != nil)
        #expect(irStyle.shadowRadius == 8)
    }
}

// MARK: - Combined Composite Property Tests

struct StyleCompositePropertyInheritanceTests {

    @Test func canClearBothShadowAndPaddingIndependently() {
        // Parent style with both shadow and padding
        let parentStyle = Document.Style(
            shadow: Document.Shadow(
                color: "#000000",
                radius: 8,
                x: 0,
                y: 4
            ),
            padding: Document.Padding(horizontal: 16, vertical: 12)
        )

        // Child style clears shadow but keeps padding
        let childClearsShadow = Document.Style(
            shadow: Document.Shadow()
        )

        // Another child clears padding but keeps shadow
        let childClearsPadding = Document.Style(
            padding: Document.Padding()
        )

        // Test clearing shadow only
        var irStyle1 = IR.Style()
        irStyle1.merge(from: parentStyle)
        irStyle1.merge(from: childClearsShadow)

        #expect(irStyle1.shadowColor == nil)
        #expect(irStyle1.shadowRadius == nil)
        #expect(irStyle1.paddingTop == 12)
        #expect(irStyle1.paddingLeading == 16)

        // Test clearing padding only
        var irStyle2 = IR.Style()
        irStyle2.merge(from: parentStyle)
        irStyle2.merge(from: childClearsPadding)

        #expect(irStyle2.shadowColor != nil)
        #expect(irStyle2.shadowRadius == 8)
        #expect(irStyle2.paddingTop == nil)
        #expect(irStyle2.paddingLeading == nil)
    }

    @Test func canClearBothShadowAndPaddingTogether() {
        // Parent style with both shadow and padding
        let parentStyle = Document.Style(
            fontSize: 16,
            shadow: Document.Shadow(
                color: "#000000",
                radius: 8,
                x: 0,
                y: 4
            ),
            padding: Document.Padding(horizontal: 16, vertical: 12)
        )

        // Child style clears both shadow and padding
        let childStyle = Document.Style(
            shadow: Document.Shadow(),
            padding: Document.Padding()
        )

        var irStyle = IR.Style()
        irStyle.merge(from: parentStyle)
        irStyle.merge(from: childStyle)

        // Both shadow and padding should be cleared
        #expect(irStyle.shadowColor == nil)
        #expect(irStyle.shadowRadius == nil)
        #expect(irStyle.paddingTop == nil)
        #expect(irStyle.paddingLeading == nil)

        // Other properties should remain
        #expect(irStyle.fontSize == 16)
    }

    @Test func multiLevelInheritanceWithClearing() {
        // Grandparent with shadow and padding
        let grandparent = Document.Style(
            fontSize: 14,
            shadow: Document.Shadow(
                color: "#000000",
                radius: 4,
                x: 0,
                y: 2
            ),
            padding: Document.Padding(horizontal: 12, vertical: 8)
        )

        // Parent increases shadow and padding
        let parent = Document.Style(
            fontSize: 16,
            shadow: Document.Shadow(
                color: "#000000",
                radius: 8,
                x: 0,
                y: 4
            ),
            padding: Document.Padding(horizontal: 16, vertical: 12)
        )

        // Child clears shadow but adds more padding
        let child = Document.Style(
            shadow: Document.Shadow(),
            padding: Document.Padding(horizontal: 24, vertical: 16)
        )

        var irStyle = IR.Style()
        irStyle.merge(from: grandparent)
        irStyle.merge(from: parent)
        irStyle.merge(from: child)

        // Shadow should be cleared
        #expect(irStyle.shadowColor == nil)
        #expect(irStyle.shadowRadius == nil)

        // Padding should be from child
        #expect(irStyle.paddingTop == 16)
        #expect(irStyle.paddingLeading == 24)

        // Font size should be from parent
        #expect(irStyle.fontSize == 16)
    }
}
