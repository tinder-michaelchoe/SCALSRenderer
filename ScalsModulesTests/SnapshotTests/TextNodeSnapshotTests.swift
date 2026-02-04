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
        // Create a simple text node with basic styling (flattened properties)
        let node = RenderNode(TextNode(
            content: "testTextWithBasicStyle",
            textColor: .black,
            fontSize: 16
        ))

        // Render with SwiftUI
        let swiftUIImage = await RendererTestHelpers.renderSwiftUI(
            node,
            size: StandardSnapshotSizes.compact
        )
        assertSnapshot(
            of: swiftUIImage,
            as: .image,
            named: "text-basic-swiftui",
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
            named: "text-basic-uikit",
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
            named: "text-basic-html",
            record: false
        )
    }

    @MainActor
    func testTextWithCanonicalComparison() async throws {
        // Test that SCALS renderer output matches canonical SwiftUI
        let node = RenderNode(TextNode(
            content: "testTextWithCanonicalComparison",
            textColor: .black,
            fontSize: 16
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
        assertSnapshot(of: scalsImage, as: .image, named: "text-basic-scals", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "text-basic-canonical", record: false)
    }

    // MARK: - Color Scheme Tests

    @MainActor
    func testTextWithColorSchemes() async throws {
        // Test text rendering in both light and dark modes
        let node = RenderNode(TextNode(
            content: "testTextWithColorSchemes",
            textColor: IR.Color(red: 0.2, green: 0.2, blue: 0.8, alpha: 1.0),  // Blue text
            fontSize: 18
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
            named: "text-light-swiftui",
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
            named: "text-dark-swiftui",
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
            named: "text-light-uikit",
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
            named: "text-dark-uikit",
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
            named: "text-light-html",
            record: false
        )

        // Canonical comparisons
        let canonicalLightImage = await RendererTestHelpers.renderCanonicalView({
            Text("testTextWithColorSchemes")
                .font(.system(size: 18))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.8))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }, size: StandardSnapshotSizes.compact, traits: lightTraits)

        let canonicalDarkImage = await RendererTestHelpers.renderCanonicalView({
            Text("testTextWithColorSchemes")
                .font(.system(size: 18))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.8))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }, size: StandardSnapshotSizes.compact, traits: darkTraits)

        assertSnapshot(of: swiftUILightImage, as: .image, named: "text-light-scals", record: false)
        assertSnapshot(of: canonicalLightImage, as: .image, named: "text-light-canonical", record: false)
        assertSnapshot(of: swiftUIDarkImage, as: .image, named: "text-dark-scals", record: false)
        assertSnapshot(of: canonicalDarkImage, as: .image, named: "text-dark-canonical", record: false)
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
            let node = RenderNode(TextNode(
                content: "Font Weight: \(name)",
                textColor: .black,
                fontSize: 18,
                fontWeight: weight
            ))

            // SwiftUI
            let swiftUIImage = await RendererTestHelpers.renderSwiftUI(
                node,
                size: StandardSnapshotSizes.compact
            )
            assertSnapshot(
                of: swiftUIImage,
                as: .image,
                named: "text-weight-\(name)-swiftui",
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
                named: "text-weight-\(name)-uikit",
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
                named: "text-weight-\(name)-html",
                record: false
            )

            // Canonical comparison
            let fontWeight: Font.Weight = {
                switch weight {
                case .regular: return .regular
                case .medium: return .medium
                case .semibold: return .semibold
                case .bold: return .bold
                default: return .regular
                }
            }()

            let canonicalImage = await RendererTestHelpers.renderCanonicalView({
                Text("Font Weight: \(name)")
                    .font(.system(size: 18, weight: fontWeight))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }, size: StandardSnapshotSizes.compact)

            assertSnapshot(of: swiftUIImage, as: .image, named: "text-weight-\(name)-scals", record: false)
            assertSnapshot(of: canonicalImage, as: .image, named: "text-weight-\(name)-canonical", record: false)
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
            let node = RenderNode(TextNode(
                content: "Size: \(Int(size))pt",
                textColor: .black,
                fontSize: size
            ))

            // SwiftUI
            let swiftUIImage = await RendererTestHelpers.renderSwiftUI(
                node,
                size: StandardSnapshotSizes.compact
            )
            assertSnapshot(
                of: swiftUIImage,
                as: .image,
                named: "text-size-\(name)-swiftui",
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
                named: "text-size-\(name)-uikit",
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
                named: "text-size-\(name)-html",
                record: false
            )

            // Canonical comparison
            let canonicalImage = await RendererTestHelpers.renderCanonicalView({
                Text("Size: \(Int(size))pt")
                    .font(.system(size: size))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }, size: StandardSnapshotSizes.compact)

            assertSnapshot(of: swiftUIImage, as: .image, named: "text-size-\(name)-scals", record: false)
            assertSnapshot(of: canonicalImage, as: .image, named: "text-size-\(name)-canonical", record: false)
        }
    }

    // MARK: - Text Alignment Tests

    @MainActor
    func testTextWithAlignment() async throws {
        let alignments: [(IR.TextAlignment, String)] = [
            (.leading, "leading"),
            (.center, "center"),
            (.trailing, "trailing")
        ]

        for (alignment, name) in alignments {
            let textNode = TextNode(
                content: "Aligned \(name)",
                textColor: .black,
                fontSize: 16,
                textAlignment: alignment,
                // Text needs full width to show alignment (intrinsic-width text has no room to align)
                width: .fractional(1.0)
            )

            let node = RenderNode(textNode)

            // SwiftUI - pinToEdges allows fractional width to work and shows alignment
            let swiftUIImage = await RendererTestHelpers.renderSwiftUI(
                node,
                size: StandardSnapshotSizes.compact,
                pinToEdges: true
            )
            assertSnapshot(
                of: swiftUIImage,
                as: .image,
                named: "text-align-\(name)-swiftui",
                record: false
            )

            // UIKit - pinToEdges allows fractional width to work and shows alignment
            let uikitImage = await RendererTestHelpers.renderUIKit(
                node,
                size: StandardSnapshotSizes.compact,
                pinToEdges: true
            )
            assertSnapshot(
                of: uikitImage,
                as: .image,
                named: "text-align-\(name)-uikit",
                record: false
            )

            // HTML - pinToEdges allows width percentage and text-align to work
            let htmlImage = try await RendererTestHelpers.renderHTML(
                node,
                size: StandardSnapshotSizes.compact,
                pinToEdges: true
            )
            assertSnapshot(
                of: htmlImage,
                as: .image,
                named: "text-align-\(name)-html",
                record: false
            )

            // Canonical comparison - text with full width shows alignment
            let frameAlignment: SwiftUI.Alignment = {
                switch alignment {
                case .leading: return .leading
                case .center: return .center
                case .trailing: return .trailing
                }
            }()

            let canonicalImage = await RendererTestHelpers.renderCanonicalView({
                Text("Aligned \(name)")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .containerRelativeFrame(.horizontal, alignment: frameAlignment)
            }, size: StandardSnapshotSizes.compact, pinToEdges: true)

            assertSnapshot(of: swiftUIImage, as: .image, named: "text-align-\(name)-scals", record: false)
            assertSnapshot(of: canonicalImage, as: .image, named: "text-align-\(name)-canonical", record: false)
        }
    }

    // MARK: - Multiline Text Tests

    @MainActor
    func testTextWithMultiline() async throws {
        let node = RenderNode(TextNode(
            content: "This is a multiline text example that should wrap to multiple lines when the content is too long to fit on a single line.",
            textColor: .black,
            fontSize: 16
        ))

        // SwiftUI
        let swiftUIImage = await RendererTestHelpers.renderSwiftUI(
            node,
            size: StandardSnapshotSizes.compact
        )
        assertSnapshot(
            of: swiftUIImage,
            as: .image,
            named: "text-multiline-swiftui",
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
            named: "text-multiline-uikit",
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
            named: "text-multiline-html",
            record: false
        )

        // Canonical comparison
        let canonicalImage = await RendererTestHelpers.renderCanonicalView({
            Text("This is a multiline text example that should wrap to multiple lines when the content is too long to fit on a single line.")
                .font(.system(size: 16))
                .foregroundColor(.black)
        }, size: StandardSnapshotSizes.compact)

        assertSnapshot(of: swiftUIImage, as: .image, named: "text-multiline-scals", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "text-multiline-canonical", record: false)
    }

    // MARK: - Text Padding Tests

    @MainActor
    func testTextWithPadding() async throws {
        let node = RenderNode(TextNode(
            content: "Text with padding",
            padding: IR.EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32),
            textColor: .black,
            fontSize: 16
        ))

        // SwiftUI
        let swiftUIImage = await RendererTestHelpers.renderSwiftUI(
            node,
            size: StandardSnapshotSizes.compact
        )
        assertSnapshot(
            of: swiftUIImage,
            as: .image,
            named: "text-padding-swiftui",
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
            named: "text-padding-uikit",
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
            named: "text-padding-html",
            record: false
        )

        // Canonical comparison
        let canonicalImage = await RendererTestHelpers.renderCanonicalView({
            Text("Text with padding")
                .font(.system(size: 16))
                .foregroundColor(.black)
                .padding(.top, 16)
                .padding(.bottom, 16)
                .padding(.leading, 32)
                .padding(.trailing, 32)
        }, size: StandardSnapshotSizes.compact)

        assertSnapshot(of: swiftUIImage, as: .image, named: "text-padding-scals", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "text-padding-canonical", record: false)
    }
}
