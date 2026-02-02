//
//  StyleInheritanceIntegrationTests.swift
//  SCALSTests
//
//  Integration tests for complete style inheritance scenarios, including
//  clearing inherited composite properties (shadow, padding).
//

import Foundation
import Testing
@testable import SCALS

// MARK: - Real-World Style Inheritance Scenarios

struct StyleInheritanceIntegrationTests {

    @Test("Card style inheritance - no shadow variant")
    func cardStyleInheritanceNoShadow() {
        // This replicates the shadows example issue that was fixed

        // Base card style
        let cardStyle = Document.Style(
            backgroundColor: "#FFFFFF",
            cornerRadius: 12,
            padding: Document.Padding(horizontal: 16, vertical: 24)
        )

        // Elevated card inherits from card and adds shadow
        let elevatedStyle = Document.Style(
            shadow: Document.Shadow(
                color: "rgba(0, 0, 0, 0.12)",
                radius: 8,
                x: 0,
                y: 4
            )
        )

        // No-shadow card inherits from elevated but removes shadow
        let noShadowStyle = Document.Style(
            shadow: Document.Shadow() // Empty shadow clears inherited shadow
        )

        // Build up the inheritance chain
        var irStyle = ResolvedStyle()
        irStyle.merge(from: cardStyle)
        irStyle.merge(from: elevatedStyle)

        // After merging card + elevated, shadow should be present
        #expect(irStyle.shadowColor != nil)
        #expect(irStyle.shadowRadius == 8)
        #expect(irStyle.shadowY == 4)
        #expect(irStyle.paddingLeading == 16) // Padding should still be there

        // Now merge no-shadow style
        irStyle.merge(from: noShadowStyle)

        // Shadow should be completely cleared
        #expect(irStyle.shadowColor == nil)
        #expect(irStyle.shadowRadius == nil)
        #expect(irStyle.shadowX == nil)
        #expect(irStyle.shadowY == nil)

        // But other properties should remain
        #expect(irStyle.backgroundColor != nil)
        #expect(irStyle.cornerRadius == 12)
        #expect(irStyle.paddingLeading == 16)
        #expect(irStyle.paddingTop == 24)
    }

    @Test("Button style inheritance - compact variant")
    func buttonStyleInheritanceCompact() {
        // Button base style
        let buttonStyle = Document.Style(
            backgroundColor: "#007AFF",
            cornerRadius: 8,
            padding: Document.Padding(horizontal: 24, vertical: 14)
        )

        // Compact button removes padding
        let compactStyle = Document.Style(
            padding: Document.Padding() // Empty padding clears inherited padding
        )

        var irStyle = ResolvedStyle()
        irStyle.merge(from: buttonStyle)

        // After base button style
        #expect(irStyle.paddingLeading == 24)
        #expect(irStyle.paddingTop == 14)

        // Merge compact style
        irStyle.merge(from: compactStyle)

        // Padding should be cleared
        #expect(irStyle.paddingTop == nil)
        #expect(irStyle.paddingLeading == nil)

        // Other properties remain
        #expect(irStyle.backgroundColor != nil)
        #expect(irStyle.cornerRadius == 8)
    }

    @Test("List row style - selective overrides")
    func listRowStyleSelectiveOverrides() {
        // Default list row
        let defaultRow = Document.Style(
            backgroundColor: "#FFFFFF",
            shadow: Document.Shadow(
                color: "rgba(0, 0, 0, 0.05)",
                radius: 2,
                x: 0,
                y: 1
            ),
            padding: Document.Padding(horizontal: 16, vertical: 12)
        )

        // Highlighted row - change background, keep shadow and padding
        let highlightedRow = Document.Style(
            backgroundColor: "#F0F0F0"
        )

        // Flat row - remove shadow, keep padding
        let flatRow = Document.Style(
            shadow: Document.Shadow()
        )

        // Test highlighted variant
        var highlighted = ResolvedStyle()
        highlighted.merge(from: defaultRow)
        highlighted.merge(from: highlightedRow)

        #expect(highlighted.shadowColor != nil) // Shadow remains
        #expect(highlighted.paddingTop == 12) // Padding remains
        // Background would be updated (can't easily test color comparison)

        // Test flat variant
        var flat = ResolvedStyle()
        flat.merge(from: defaultRow)
        flat.merge(from: flatRow)

        #expect(flat.shadowColor == nil) // Shadow cleared
        #expect(flat.shadowRadius == nil)
        #expect(flat.paddingTop == 12) // Padding remains
        #expect(flat.backgroundColor != nil) // Background remains
    }

    @Test("Complex three-level inheritance")
    func complexThreeLevelInheritance() {
        // Level 1: Base component
        let base = Document.Style(
            fontSize: 14,
            textColor: "#000000",
            backgroundColor: "#FFFFFF",
            cornerRadius: 4,
            shadow: Document.Shadow(
                color: "rgba(0, 0, 0, 0.1)",
                radius: 2,
                x: 0,
                y: 1
            ),
            padding: Document.Padding(horizontal: 8, vertical: 4)
        )

        // Level 2: Enhanced component - bigger padding and shadow
        let enhanced = Document.Style(
            fontSize: 16, // Override font size
            shadow: Document.Shadow(
                radius: 4,
                y: 2
            ), // Partial shadow override
            padding: Document.Padding(horizontal: 16, vertical: 12)
        )

        // Level 3: Minimal variant - remove shadow, reduce padding
        let minimal = Document.Style(
            shadow: Document.Shadow(), // Clear shadow
            padding: Document.Padding(horizontal: 4, vertical: 2)
        )

        var irStyle = ResolvedStyle()
        irStyle.merge(from: base)
        irStyle.merge(from: enhanced)
        irStyle.merge(from: minimal)

        // Font size from enhanced
        #expect(irStyle.fontSize == 16)

        // Colors from base
        #expect(irStyle.textColor != nil)
        #expect(irStyle.backgroundColor != nil)

        // Corner radius from base
        #expect(irStyle.cornerRadius == 4)

        // Shadow cleared by minimal
        #expect(irStyle.shadowColor == nil)
        #expect(irStyle.shadowRadius == nil)

        // Padding from minimal
        #expect(irStyle.paddingLeading == 4)
        #expect(irStyle.paddingTop == 2)
    }

    @Test("Partial property override doesn't affect clearing")
    func partialPropertyOverrideDoesntAffectClearing() {
        // Parent with full shadow
        let parent = Document.Style(
            shadow: Document.Shadow(
                color: "#000000",
                radius: 8,
                x: 2,
                y: 4
            )
        )

        // Child with partial shadow (only color)
        let childPartial = Document.Style(
            shadow: Document.Shadow(
                color: "#FF0000"
            )
        )

        // Another child with empty shadow
        let childEmpty = Document.Style(
            shadow: Document.Shadow()
        )

        // Test partial override - should merge
        var partialStyle = ResolvedStyle()
        partialStyle.merge(from: parent)
        partialStyle.merge(from: childPartial)

        // Color overridden, but radius, x, y inherited
        #expect(partialStyle.shadowColor != nil)
        #expect(partialStyle.shadowRadius == 8)
        #expect(partialStyle.shadowX == 2)
        #expect(partialStyle.shadowY == 4)

        // Test empty override - should clear
        var emptyStyle = ResolvedStyle()
        emptyStyle.merge(from: parent)
        emptyStyle.merge(from: childEmpty)

        // All shadow properties cleared
        #expect(emptyStyle.shadowColor == nil)
        #expect(emptyStyle.shadowRadius == nil)
        #expect(emptyStyle.shadowX == nil)
        #expect(emptyStyle.shadowY == nil)
    }

    @Test("Horizontal and vertical padding with clearing")
    func horizontalVerticalPaddingWithClearing() {
        // Parent with horizontal/vertical padding
        let parent = Document.Style(
            padding: Document.Padding(
                horizontal: 16,
                vertical: 12
            )
        )

        // Child with specific side overrides
        let childSpecific = Document.Style(
            padding: Document.Padding(
                top: 20,
                leading: 24
            )
        )

        // Grandchild clears all padding
        let grandchild = Document.Style(
            padding: Document.Padding()
        )

        // Test specific overrides
        var specificStyle = ResolvedStyle()
        specificStyle.merge(from: parent)
        specificStyle.merge(from: childSpecific)

        #expect(specificStyle.paddingTop == 20) // Overridden
        #expect(specificStyle.paddingLeading == 24) // Overridden
        #expect(specificStyle.paddingBottom == 12) // Inherited from vertical
        #expect(specificStyle.paddingTrailing == 16) // Inherited from horizontal

        // Test clearing
        specificStyle.merge(from: grandchild)

        #expect(specificStyle.paddingTop == nil)
        #expect(specificStyle.paddingLeading == nil)
        #expect(specificStyle.paddingBottom == nil)
        #expect(specificStyle.paddingTrailing == nil)
    }
}
