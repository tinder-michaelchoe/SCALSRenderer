//
//  ButtonNodeSnapshotTests.swift
//  ScalsModulesTests
//
//  Snapshot tests for ButtonNode rendering across SwiftUI, UIKit, and HTML renderers.
//

import XCTest
import SnapshotTesting
import SwiftUI
import SCALS
@testable import ScalsModules

final class ButtonNodeSnapshotTests: XCTestCase {

    // MARK: - Basic Button Tests

    @MainActor
    func testButtonWithBasicStyle() async throws {
        // Create a simple button with basic styling
        var normalStyle = IR.Style()
        normalStyle.fontSize = 16
        normalStyle.fontWeight = .semibold
        normalStyle.textColor = IR.Color.white
        normalStyle.backgroundColor = IR.Color(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0) // iOS blue
        normalStyle.cornerRadius = 10
        normalStyle.height = 44
        normalStyle.paddingLeading = 20
        normalStyle.paddingTrailing = 20

        let button = ButtonNode(
            id: "test-button",
            label: "Tap Me",
            styles: ButtonStyles(normal: normalStyle),
            fillWidth: true
        )

        let node = RenderNode.button(button)

        // Render with SwiftUI
        let swiftUIImage = await RendererTestHelpers.renderSwiftUI(
            node,
            size: StandardSnapshotSizes.compact
        )
        assertSnapshot(
            of: swiftUIImage,
            as: .image,
            named: "button-basic-swiftui",
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
            named: "button-basic-uikit",
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
            named: "button-basic-html",
            record: false
        )

        // Canonical comparison
        let canonicalImage = await RendererTestHelpers.renderCanonicalView({
            Button("Tap Me") {}
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.0, green: 0.48, blue: 1.0))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }, size: StandardSnapshotSizes.compact)

        assertSnapshot(of: swiftUIImage, as: .image, named: "button-basic-scals", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "button-basic-canonical", record: false)
    }

    // MARK: - Button State Tests

    @MainActor
    func testButtonWithStates() async throws {
        // Test button in different states: normal, disabled, selected

        // Normal state
        var normalStyle = IR.Style()
        normalStyle.fontSize = 16
        normalStyle.fontWeight = .semibold
        normalStyle.textColor = IR.Color.white
        normalStyle.backgroundColor = IR.Color(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        normalStyle.cornerRadius = 10
        normalStyle.height = 44
        normalStyle.paddingLeading = 20
        normalStyle.paddingTrailing = 20

        // Disabled state
        var disabledStyle = IR.Style()
        disabledStyle.fontSize = 16
        disabledStyle.fontWeight = .semibold
        disabledStyle.textColor = IR.Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        disabledStyle.backgroundColor = IR.Color(red: 0.0, green: 0.48, blue: 1.0, alpha: 0.3)
        disabledStyle.cornerRadius = 10
        disabledStyle.height = 44
        disabledStyle.paddingLeading = 20
        disabledStyle.paddingTrailing = 20

        // Selected state
        var selectedStyle = IR.Style()
        selectedStyle.fontSize = 16
        selectedStyle.fontWeight = .semibold
        selectedStyle.textColor = IR.Color.white
        selectedStyle.backgroundColor = IR.Color(red: 0.0, green: 0.34, blue: 0.72, alpha: 1.0) // Darker blue
        selectedStyle.cornerRadius = 10
        selectedStyle.height = 44
        selectedStyle.paddingLeading = 20
        selectedStyle.paddingTrailing = 20

        let button = ButtonNode(
            id: "test-button-states",
            label: "Button States",
            styles: ButtonStyles(
                normal: normalStyle,
                selected: selectedStyle,
                disabled: disabledStyle
            ),
            fillWidth: true
        )

        let node = RenderNode.button(button)

        // Render normal state
        let swiftUIImage = await RendererTestHelpers.renderSwiftUI(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: swiftUIImage, as: .image, named: "button-states-normal-swiftui", record: false)

        let uikitImage = await RendererTestHelpers.renderUIKit(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: uikitImage, as: .image, named: "button-states-normal-uikit", record: false)

        let htmlImage = try await RendererTestHelpers.renderHTML(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: htmlImage, as: .image, named: "button-states-normal-html", record: false)
    }

    // MARK: - Button Color Tests

    @MainActor
    func testButtonWithCustomColors() async throws {
        // Test buttons with different color schemes
        let colorSchemes: [(String, IR.Color, IR.Color)] = [
            ("red", IR.Color(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0), IR.Color.white),
            ("green", IR.Color(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0), IR.Color.white),
            ("gray", IR.Color(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.0), IR.Color.white)
        ]

        for (name, bgColor, textColor) in colorSchemes {
            var style = IR.Style()
            style.fontSize = 16
            style.fontWeight = .semibold
            style.textColor = textColor
            style.backgroundColor = bgColor
            style.cornerRadius = 10
            style.height = 44
            style.paddingLeading = 20
            style.paddingTrailing = 20

            let button = ButtonNode(
                id: "test-button-\(name)",
                label: "\(name.capitalized) Button",
                styles: ButtonStyles(normal: style),
                fillWidth: true
            )

            let node = RenderNode.button(button)

            // SwiftUI
            let swiftUIImage = await RendererTestHelpers.renderSwiftUI(node, size: StandardSnapshotSizes.compact)
            assertSnapshot(of: swiftUIImage, as: .image, named: "button-color-\(name)-swiftui", record: false)

            // UIKit
            let uikitImage = await RendererTestHelpers.renderUIKit(node, size: StandardSnapshotSizes.compact)
            assertSnapshot(of: uikitImage, as: .image, named: "button-color-\(name)-uikit", record: false)

            // HTML
            let htmlImage = try await RendererTestHelpers.renderHTML(node, size: StandardSnapshotSizes.compact)
            assertSnapshot(of: htmlImage, as: .image, named: "button-color-\(name)-html", record: false)

            // Canonical
            let uiColor = UIColor(red: bgColor.red, green: bgColor.green, blue: bgColor.blue, alpha: bgColor.alpha)
            let canonicalImage = await RendererTestHelpers.renderCanonicalView({
                Button("\(name.capitalized) Button") {}
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(textColor.uiColor))
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }, size: StandardSnapshotSizes.compact)

            assertSnapshot(of: swiftUIImage, as: .image, named: "button-color-\(name)-scals", record: false)
            assertSnapshot(of: canonicalImage, as: .image, named: "button-color-\(name)-canonical", record: false)
        }
    }

    // MARK: - Button Border Tests

    @MainActor
    func testButtonWithBorder() async throws {
        // Test button with border styling
        var style = IR.Style()
        style.fontSize = 16
        style.fontWeight = .semibold
        style.textColor = IR.Color(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0) // Blue text
        style.backgroundColor = IR.Color.clear
        style.borderColor = IR.Color(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0) // Blue border
        style.borderWidth = 2
        style.cornerRadius = 10
        style.height = 44
        style.paddingLeading = 20
        style.paddingTrailing = 20

        let button = ButtonNode(
            id: "test-button-border",
            label: "Bordered Button",
            styles: ButtonStyles(normal: style),
            fillWidth: true
        )

        let node = RenderNode.button(button)

        // SwiftUI
        let swiftUIImage = await RendererTestHelpers.renderSwiftUI(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: swiftUIImage, as: .image, named: "button-border-swiftui", record: false)

        // UIKit
        let uikitImage = await RendererTestHelpers.renderUIKit(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: uikitImage, as: .image, named: "button-border-uikit", record: false)

        // HTML
        let htmlImage = try await RendererTestHelpers.renderHTML(node, size: StandardSnapshotSizes.compact)
        assertSnapshot(of: htmlImage, as: .image, named: "button-border-html", record: false)

        // Canonical
        let canonicalImage = await RendererTestHelpers.renderCanonicalView({
            Button("Bordered Button") {}
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0))
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.clear)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.0, green: 0.48, blue: 1.0), lineWidth: 2)
                )
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }, size: StandardSnapshotSizes.compact)

        assertSnapshot(of: swiftUIImage, as: .image, named: "button-border-scals", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "button-border-canonical", record: false)
    }
}
