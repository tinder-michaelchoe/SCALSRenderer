//
//  ContainerNodeSnapshotTests.swift
//  ScalsModulesTests
//
//  Snapshot tests for ContainerNode (VStack, HStack, ZStack) rendering across all renderers.
//

import XCTest
import SnapshotTesting
import SwiftUI
import SCALS
@testable import ScalsModules

final class ContainerNodeSnapshotTests: XCTestCase {

    // MARK: - Basic Container Tests

    @MainActor
    func testVStackBasic() async throws {
        // Create a simple VStack with three text children (flattened properties)
        let children: [RenderNode] = [
            RenderNode(TextNode(content: "First Item", textColor: .black, fontSize: 16)),
            RenderNode(TextNode(content: "Second Item", textColor: .black, fontSize: 16)),
            RenderNode(TextNode(content: "Third Item", textColor: .black, fontSize: 16))
        ]

        let container = ContainerNode(
            id: "vstack-basic",
            layoutType: .vstack,
            alignment: .center,
            spacing: 0,
            children: children
        )

        let node = RenderNode(container)

        // Render with SwiftUI
        let swiftUIImage = await RendererTestHelpers.renderSwiftUI(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: swiftUIImage, as: .image, named: "vstack-basic-swiftui", record: false)

        // Render with UIKit
        let uikitImage = await RendererTestHelpers.renderUIKit(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: uikitImage, as: .image, named: "vstack-basic-uikit", record: false)

        // Render with HTML
        let htmlImage = try await RendererTestHelpers.renderHTML(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: htmlImage, as: .image, named: "vstack-basic-html", record: false)

        // Canonical comparison
        let canonicalImage = await RendererTestHelpers.renderCanonicalView({
            VStack(spacing: 0) {
                Text("First Item")
                Text("Second Item")
                Text("Third Item")
            }
            .font(.system(size: 16))
            .foregroundColor(.black)
        }, size: StandardSnapshotSizes.compact)

        assertSnapshot(of: swiftUIImage, as: .image, named: "vstack-basic-scals", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "vstack-basic-canonical", record: false)
    }

    @MainActor
    func testHStackBasic() async throws {
        // Create a simple HStack with three text children (flattened properties)
        let children: [RenderNode] = [
            RenderNode(TextNode(content: "A", textColor: .black, fontSize: 16)),
            RenderNode(TextNode(content: "B", textColor: .black, fontSize: 16)),
            RenderNode(TextNode(content: "C", textColor: .black, fontSize: 16))
        ]

        let container = ContainerNode(
            id: "hstack-basic",
            layoutType: .hstack,
            alignment: .center,
            spacing: 0,
            children: children
        )

        let node = RenderNode(container)

        // Render with SwiftUI
        let swiftUIImage = await RendererTestHelpers.renderSwiftUI(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: swiftUIImage, as: .image, named: "hstack-basic-swiftui", record: false)

        // Render with UIKit
        let uikitImage = await RendererTestHelpers.renderUIKit(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: uikitImage, as: .image, named: "hstack-basic-uikit", record: false)

        // Render with HTML
        let htmlImage = try await RendererTestHelpers.renderHTML(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: htmlImage, as: .image, named: "hstack-basic-html", record: false)

        // Canonical comparison
        let canonicalImage = await RendererTestHelpers.renderCanonicalView({
            HStack(spacing: 0) {
                Text("A")
                Text("B")
                Text("C")
            }
            .font(.system(size: 16))
            .foregroundColor(.black)
        }, size: StandardSnapshotSizes.compact)

        assertSnapshot(of: swiftUIImage, as: .image, named: "hstack-basic-scals", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "hstack-basic-canonical", record: false)
    }

    @MainActor
    func testZStackBasic() async throws {
        // Create a simple ZStack with overlapping elements
        let children: [RenderNode] = [
            RenderNode(TextNode(
                content: "Background",
                width: .absolute(100),
                height: .absolute(100)
            )),
            RenderNode(TextNode(
                content: "Front",
                textColor: .green,
                fontSize: 20,
                fontWeight: .bold
            ))
        ]

        let container = ContainerNode(
            id: "zstack-basic",
            layoutType: .zstack,
            alignment: .center,
            spacing: 0,
            children: children
        )

        let node = RenderNode(container)

        // Render with SwiftUI
        let swiftUIImage = await RendererTestHelpers.renderSwiftUI(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: swiftUIImage, as: .image, named: "zstack-basic-swiftui", record: false)

        // Render with UIKit
        let uikitImage = await RendererTestHelpers.renderUIKit(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: uikitImage, as: .image, named: "zstack-basic-uikit", record: false)

        // Render with HTML
        let htmlImage = try await RendererTestHelpers.renderHTML(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: htmlImage, as: .image, named: "zstack-basic-html", record: false)

        // Canonical comparison
        let canonicalImage = await RendererTestHelpers.renderCanonicalView({
            ZStack {
                Text("Background")
                    .frame(width: 100, height: 100)
                Text("Front")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.green)
            }
        }, size: StandardSnapshotSizes.compact)

        assertSnapshot(of: swiftUIImage, as: .image, named: "zstack-basic-scals", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "zstack-basic-canonical", record: false)
    }

    // MARK: - VStack Spacing Tests

    @MainActor
    func testVStackWithSpacing() async throws {
        // Test VStack with various spacing values
        let spacings: [(CGFloat, String)] = [
            (8, "small"),
            (16, "medium"),
            (24, "large")
        ]

        for (spacing, name) in spacings {
            let children: [RenderNode] = [
                RenderNode(TextNode(content: "Item 1", textColor: .black, fontSize: 16)),
                RenderNode(TextNode(content: "Item 2", textColor: .black, fontSize: 16)),
                RenderNode(TextNode(content: "Item 3", textColor: .black, fontSize: 16))
            ]

            let container = ContainerNode(
                id: "vstack-spacing-\(name)",
                layoutType: .vstack,
                alignment: .center,
                spacing: spacing,
                children: children
            )

            let node = RenderNode(container)

            // SwiftUI
            let swiftUIImage = await RendererTestHelpers.renderSwiftUI(node, size: StandardSnapshotSizes.compact)
            assertSnapshot(of: swiftUIImage, as: .image, named: "vstack-spacing-\(name)-swiftui", record: false)

            // UIKit
            let uikitImage = await RendererTestHelpers.renderUIKit(node, size: StandardSnapshotSizes.compact)
            assertSnapshot(of: uikitImage, as: .image, named: "vstack-spacing-\(name)-uikit", record: false)

            // HTML
            let htmlImage = try await RendererTestHelpers.renderHTML(node, size: StandardSnapshotSizes.compact)
            assertSnapshot(of: htmlImage, as: .image, named: "vstack-spacing-\(name)-html", record: false)

            // Canonical
            let canonicalImage = await RendererTestHelpers.renderCanonicalView({
                VStack(spacing: spacing) {
                    Text("Item 1")
                    Text("Item 2")
                    Text("Item 3")
                }
                .font(.system(size: 16))
                .foregroundColor(.black)
            }, size: StandardSnapshotSizes.compact)

            assertSnapshot(of: swiftUIImage, as: .image, named: "vstack-spacing-\(name)-scals", record: false)
            assertSnapshot(of: canonicalImage, as: .image, named: "vstack-spacing-\(name)-canonical", record: false)
        }
    }

    // MARK: - VStack Alignment Tests

    @MainActor
    func testVStackWithAlignment() async throws {
        // Test VStack with different horizontal alignments
        let alignments: [(IR.Alignment, String)] = [
            (.leading, "leading"),
            (.center, "center"),
            (.trailing, "trailing")
        ]

        for (alignment, name) in alignments {
            let children: [RenderNode] = [
                RenderNode(TextNode(content: "Short", textColor: .black, fontSize: 16)),
                RenderNode(TextNode(content: "Medium Text", textColor: .black, fontSize: 16)),
                RenderNode(TextNode(content: "This is a longer line", textColor: .black, fontSize: 16))
            ]

            let container = ContainerNode(
                id: "vstack-align-\(name)",
                layoutType: .vstack,
                alignment: alignment,
                spacing: 8,
                children: children
            )

            let node = RenderNode(container)

            // SwiftUI
            let swiftUIImage = await RendererTestHelpers.renderSwiftUI(node, size: StandardSnapshotSizes.compact)
            assertSnapshot(of: swiftUIImage, as: .image, named: "vstack-align-\(name)-swiftui", record: false)

            // UIKit
            let uikitImage = await RendererTestHelpers.renderUIKit(node, size: StandardSnapshotSizes.compact)
            assertSnapshot(of: uikitImage, as: .image, named: "vstack-align-\(name)-uikit", record: false)

            // HTML
            let htmlImage = try await RendererTestHelpers.renderHTML(node, size: StandardSnapshotSizes.compact)
            assertSnapshot(of: htmlImage, as: .image, named: "vstack-align-\(name)-html", record: false)

            // Canonical
            let swiftUIAlignment: HorizontalAlignment = {
                switch alignment {
                case .leading: return .leading
                case .center: return .center
                case .trailing: return .trailing
                default: return .center
                }
            }()

            let canonicalImage = await RendererTestHelpers.renderCanonicalView({
                VStack(alignment: swiftUIAlignment, spacing: 8) {
                    Text("Short")
                    Text("Medium Text")
                    Text("This is a longer line")
                }
                .font(.system(size: 16))
                .foregroundColor(.black)
            }, size: StandardSnapshotSizes.compact)

            assertSnapshot(of: swiftUIImage, as: .image, named: "vstack-align-\(name)-scals", record: false)
            assertSnapshot(of: canonicalImage, as: .image, named: "vstack-align-\(name)-canonical", record: false)
        }
    }
}
