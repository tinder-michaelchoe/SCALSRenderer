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

    // MARK: - Test Configuration

    override class func setUp() {
        super.setUp()
        // Configure SnapshotTesting to use external snapshot directory
        // This must be set before any tests run
        setenv("SNAPSHOT_REFERENCE_DIR", "/Users/michael.choe/Desktop/PROGRAMMING/ScalsRenderer-Snapshots", 1)
    }

    override func setUp() {
        super.setUp()
        // Snapshots will be saved to ScalsRenderer-Snapshots directory (outside repo)
    }

    // MARK: - Basic Text Tests

    @MainActor
    func testTextWithBasicStyle() async throws {
        // Create a simple text node with basic styling
        var style = IR.Style()
        style.fontSize = 16
        style.textColor = IR.Color.black

        let node = RenderNode.text(TextNode(
            content: "Hello World",
            style: style,
            padding: .zero
        ))

        // Render with SwiftUI
        let swiftUIImage = await RendererTestHelpers.renderSwiftUI(
            node,
            size: StandardSnapshotSizes.compact
        )
        assertSnapshot(of: swiftUIImage, as: .image, named: "swiftui-text-basic")

        // Render with UIKit
        let uikitImage = await RendererTestHelpers.renderUIKit(
            node,
            size: StandardSnapshotSizes.compact
        )
        assertSnapshot(of: uikitImage, as: .image, named: "uikit-text-basic")

        // Render with HTML
        let htmlImage = try await RendererTestHelpers.renderHTML(
            node,
            size: StandardSnapshotSizes.compact
        )
        assertSnapshot(of: htmlImage, as: .image, named: "html-text-basic")
    }

    @MainActor
    func testTextWithCanonicalComparison() async throws {
        // Test that SCALS renderer output matches canonical SwiftUI
        var style = IR.Style()
        style.fontSize = 16
        style.textColor = IR.Color.black

        let node = RenderNode.text(TextNode(
            content: "Hello World",
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
            Text("Hello World")
                .font(.system(size: 16))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }, size: StandardSnapshotSizes.compact)

        // Compare SCALS vs canonical
        assertSnapshot(of: scalsImage, as: .image, named: "scals-text-basic")
        assertSnapshot(of: canonicalImage, as: .image, named: "canonical-text-basic")
    }
}
