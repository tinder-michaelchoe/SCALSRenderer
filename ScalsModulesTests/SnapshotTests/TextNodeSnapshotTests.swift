//
//  TextNodeSnapshotTests.swift
//  ScalsModulesTests
//
//  Snapshot tests for TextNode rendering across SwiftUI, UIKit, and HTML renderers.
//

import XCTest
import SnapshotTesting
import SwiftUI
import SCALS
@testable import ScalsModules

final class TextNodeSnapshotTests: XCTestCase {

    // MARK: - Basic Text Tests

    @MainActor
    func testTextWithBasicStyle() async throws {
        // Create a simple text node with basic styling
        var style = IR.Style()
        style.fontSize = 16
        style.textColor = IR.Color.black

        let node = RenderNode.text(TextNode(
            content: "testTextWithBasicStyle",
            style: style,
            padding: .zero
        ))

        // Render with SwiftUI
        let swiftUIImage = await RendererTestHelpers.renderSwiftUI(
            node,
            size: StandardSnapshotSizes.compact
        )
        assertSnapshot(
            of: swiftUIImage,
            as: .image,
            named: "swiftui-text-basic",
            record: false
        )

        // Render with UIKit
        let uikitImage = await RendererTestHelpers.renderUIKit(
            node,
            size: StandardSnapshotSizes.compact
        )
        assertSnapshot(
            of: uikitImage,
            as: .image,
            named: "uikit-text-basic",
            record: false
        )

        // Render with HTML
        let htmlImage = try await RendererTestHelpers.renderHTML(
            node,
            size: StandardSnapshotSizes.compact
        )
        assertSnapshot(
            of: htmlImage,
            as: .image,
            named: "html-text-basic",
            record: false
        )
    }

    @MainActor
    func testTextWithCanonicalComparison() async throws {
        // Test that SCALS renderer output matches canonical SwiftUI
        var style = IR.Style()
        style.fontSize = 16
        style.textColor = IR.Color.black

        let node = RenderNode.text(TextNode(
            content: "testTextWithCanonicalComparison",
            style: style,
            padding: .zero
        ))

        // SCALS renderer
        let scalsImage = await RendererTestHelpers.renderSwiftUI(
            node,
            size: StandardSnapshotSizes.compact
        )

        // Canonical SwiftUI
        let canonicalImage = await RendererTestHelpers.renderCanonicalView({
            Text("testTextWithCanonicalComparison")
                .font(.system(size: 16))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }, size: StandardSnapshotSizes.compact)

        // Compare SCALS vs canonical
        assertSnapshot(of: scalsImage, as: .image, named: "scals-text-basic", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "canonical-text-basic", record: false)
    }

    // MARK: - Color Scheme Tests

    @MainActor
    func testTextWithColorSchemes() async throws {
        // Test text rendering in both light and dark modes
        var style = IR.Style()
        style.fontSize = 18
        style.textColor = IR.Color(red: 0.2, green: 0.2, blue: 0.8, alpha: 1.0)  // Blue text

        let node = RenderNode.text(TextNode(
            content: "testTextWithColorSchemes",
            style: style,
            padding: .zero
        ))

        // Light mode traits
        let lightTraits = UITraitCollection(userInterfaceStyle: .light)

        // Dark mode traits
        let darkTraits = UITraitCollection(userInterfaceStyle: .dark)

        // SwiftUI - Light
        let swiftUILightImage = await RendererTestHelpers.renderSwiftUI(
            node,
            size: StandardSnapshotSizes.compact,
            traits: lightTraits
        )
        assertSnapshot(
            of: swiftUILightImage,
            as: .image,
            named: "swiftui-text-light",
            record: false
        )

        // SwiftUI - Dark
        let swiftUIDarkImage = await RendererTestHelpers.renderSwiftUI(
            node,
            size: StandardSnapshotSizes.compact,
            traits: darkTraits
        )
        assertSnapshot(
            of: swiftUIDarkImage,
            as: .image,
            named: "swiftui-text-dark",
            record: false
        )

        // UIKit - Light
        let uikitLightImage = await RendererTestHelpers.renderUIKit(
            node,
            size: StandardSnapshotSizes.compact,
            traits: lightTraits
        )
        assertSnapshot(
            of: uikitLightImage,
            as: .image,
            named: "uikit-text-light",
            record: false
        )

        // UIKit - Dark
        let uikitDarkImage = await RendererTestHelpers.renderUIKit(
            node,
            size: StandardSnapshotSizes.compact,
            traits: darkTraits
        )
        assertSnapshot(
            of: uikitDarkImage,
            as: .image,
            named: "uikit-text-dark",
            record: false
        )

        // HTML - Light (HTML doesn't use traits, but renders light by default)
        let htmlLightImage = try await RendererTestHelpers.renderHTML(
            node,
            size: StandardSnapshotSizes.compact
        )
        assertSnapshot(
            of: htmlLightImage,
            as: .image,
            named: "html-text-light",
            record: false
        )
    }

    // MARK: - Font Weight Tests

    @MainActor
    func testTextWithFontWeights() async throws {
        // Test text with various font weights
        let weights: [(IR.FontWeight, String)] = [
            (.regular, "regular"),
            (.medium, "medium"),
            (.semibold, "semibold"),
            (.bold, "bold")
        ]

        for (weight, name) in weights {
            var style = IR.Style()
            style.fontSize = 18
            style.fontWeight = weight
            style.textColor = IR.Color.black

            let node = RenderNode.text(TextNode(
                content: "Font Weight: \(name)",
                style: style,
                padding: .zero
            ))

            // SwiftUI
            let swiftUIImage = await RendererTestHelpers.renderSwiftUI(
                node,
                size: StandardSnapshotSizes.compact
            )
            assertSnapshot(
                of: swiftUIImage,
                as: .image,
                named: "swiftui-text-weight-\(name)",
                record: false
            )

            // UIKit
            let uikitImage = await RendererTestHelpers.renderUIKit(
                node,
                size: StandardSnapshotSizes.compact
            )
            assertSnapshot(
                of: uikitImage,
                as: .image,
                named: "uikit-text-weight-\(name)",
                record: false
            )

            // HTML
            let htmlImage = try await RendererTestHelpers.renderHTML(
                node,
                size: StandardSnapshotSizes.compact
            )
            assertSnapshot(
                of: htmlImage,
                as: .image,
                named: "html-text-weight-\(name)",
                record: false
            )
        }
    }

    // MARK: - Font Size Tests

    @MainActor
    func testTextWithFontSizes() async throws {
        // Test text with various font sizes
        let sizes: [(CGFloat, String)] = [
            (12, "small"),
            (16, "medium"),
            (24, "large"),
            (32, "xlarge")
        ]

        for (size, name) in sizes {
            var style = IR.Style()
            style.fontSize = size
            style.textColor = IR.Color.black

            let node = RenderNode.text(TextNode(
                content: "Size: \(Int(size))pt",
                style: style,
                padding: .zero
            ))

            // SwiftUI
            let swiftUIImage = await RendererTestHelpers.renderSwiftUI(
                node,
                size: StandardSnapshotSizes.compact
            )
            assertSnapshot(
                of: swiftUIImage,
                as: .image,
                named: "swiftui-text-size-\(name)",
                record: false
            )

            // UIKit
            let uikitImage = await RendererTestHelpers.renderUIKit(
                node,
                size: StandardSnapshotSizes.compact
            )
            assertSnapshot(
                of: uikitImage,
                as: .image,
                named: "uikit-text-size-\(name)",
                record: false
            )

            // HTML
            let htmlImage = try await RendererTestHelpers.renderHTML(
                node,
                size: StandardSnapshotSizes.compact
            )
            assertSnapshot(
                of: htmlImage,
                as: .image,
                named: "html-text-size-\(name)",
                record: false
            )
        }
    }
}
