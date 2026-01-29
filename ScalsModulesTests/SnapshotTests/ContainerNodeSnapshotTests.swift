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
        // Create a simple VStack with three text children
        var textStyle = IR.Style()
        textStyle.fontSize = 16
        textStyle.textColor = IR.Color.black

        let children: [RenderNode] = [
            .text(TextNode(content: "First Item", style: textStyle, padding: .zero)),
            .text(TextNode(content: "Second Item", style: textStyle, padding: .zero)),
            .text(TextNode(content: "Third Item", style: textStyle, padding: .zero))
        ]

        let container = ContainerNode(
            id: "vstack-basic",
            layoutType: .vstack,
            alignment: .center,
            spacing: 0,
            children: children
        )

        let node = RenderNode.container(container)

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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }, size: StandardSnapshotSizes.compact)

        assertSnapshot(of: swiftUIImage, as: .image, named: "vstack-basic-scals", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "vstack-basic-canonical", record: false)
    }

    @MainActor
    func testHStackBasic() async throws {
        // Create a simple HStack with three text children
        var textStyle = IR.Style()
        textStyle.fontSize = 16
        textStyle.textColor = IR.Color.black

        let children: [RenderNode] = [
            .text(TextNode(content: "A", style: textStyle, padding: .zero)),
            .text(TextNode(content: "B", style: textStyle, padding: .zero)),
            .text(TextNode(content: "C", style: textStyle, padding: .zero))
        ]

        let container = ContainerNode(
            id: "hstack-basic",
            layoutType: .hstack,
            alignment: .center,
            spacing: 0,
            children: children
        )

        let node = RenderNode.container(container)

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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }, size: StandardSnapshotSizes.compact)

        assertSnapshot(of: swiftUIImage, as: .image, named: "hstack-basic-scals", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "hstack-basic-canonical", record: false)
    }

    @MainActor
    func testZStackBasic() async throws {
        // Create a simple ZStack with overlapping elements
        var bgStyle = IR.Style()
        bgStyle.backgroundColor = IR.Color(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        bgStyle.width = 100
        bgStyle.height = 100

        var textStyle = IR.Style()
        textStyle.fontSize = 20
        textStyle.fontWeight = .bold
        textStyle.textColor = IR.Color.black

        let children: [RenderNode] = [
            .text(TextNode(content: "Background", style: bgStyle, padding: .zero)),
            .text(TextNode(content: "Front", style: textStyle, padding: .zero))
        ]

        let container = ContainerNode(
            id: "zstack-basic",
            layoutType: .zstack,
            alignment: .center,
            spacing: 0,
            children: children
        )

        let node = RenderNode.container(container)

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
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                Text("Front")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
            var textStyle = IR.Style()
            textStyle.fontSize = 16
            textStyle.textColor = IR.Color.black

            let children: [RenderNode] = [
                .text(TextNode(content: "Item 1", style: textStyle, padding: .zero)),
                .text(TextNode(content: "Item 2", style: textStyle, padding: .zero)),
                .text(TextNode(content: "Item 3", style: textStyle, padding: .zero))
            ]

            let container = ContainerNode(
                id: "vstack-spacing-\(name)",
                layoutType: .vstack,
                alignment: .center,
                spacing: spacing,
                children: children
            )

            let node = RenderNode.container(container)

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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
            var textStyle = IR.Style()
            textStyle.fontSize = 16
            textStyle.textColor = IR.Color.black

            let children: [RenderNode] = [
                .text(TextNode(content: "Short", style: textStyle, padding: .zero)),
                .text(TextNode(content: "Medium Text", style: textStyle, padding: .zero)),
                .text(TextNode(content: "This is a longer line", style: textStyle, padding: .zero))
            ]

            let container = ContainerNode(
                id: "vstack-align-\(name)",
                layoutType: .vstack,
                alignment: alignment,
                spacing: 8,
                children: children
            )

            let node = RenderNode.container(container)

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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }, size: StandardSnapshotSizes.compact)

            assertSnapshot(of: swiftUIImage, as: .image, named: "vstack-align-\(name)-scals", record: false)
            assertSnapshot(of: canonicalImage, as: .image, named: "vstack-align-\(name)-canonical", record: false)
        }
    }
}
