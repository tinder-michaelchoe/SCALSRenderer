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
        // Create a simple button with basic styling (flattened properties)
        let normalStyle = ButtonStateStyle(
            textColor: .white,
            fontSize: 16,
            fontWeight: .semibold,
            backgroundColor: IR.Color(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0), // iOS blue
            cornerRadius: 10,
            border: nil,
            shadow: nil,
            tintColor: nil,
            width: nil,
            height: .absolute(44),
            minWidth: nil,
            minHeight: nil,
            maxWidth: nil,
            maxHeight: nil,
            padding: IR.EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        )

        let button = ButtonNode(
            id: "test-button",
            label: "Tap Me",
            styleId: nil,
            styles: ButtonStyles(normal: normalStyle),
            isSelectedBinding: nil,
            fillWidth: false,
            onTap: nil,
            image: nil,
            imagePlacement: .leading,
            imageSpacing: 8,
            buttonShape: nil
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
                .padding(.horizontal, 20)
                .frame(height: 44)
                .background(Color(red: 0.0, green: 0.48, blue: 1.0))
                .cornerRadius(10)
        }, size: StandardSnapshotSizes.compact)

        assertSnapshot(of: swiftUIImage, as: .image, named: "button-basic-scals", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "button-basic-canonical", record: false)
    }

    // MARK: - Button State Tests

    @MainActor
    func testButtonWithStates() async throws {
        // Test button in different states: normal, disabled, selected (flattened properties)

        // Normal state
        let normalStyle = ButtonStateStyle(
            textColor: .white,
            fontSize: 16,
            fontWeight: .semibold,
            backgroundColor: IR.Color(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0),
            cornerRadius: 10,
            border: nil,
            shadow: nil,
            tintColor: nil,
            width: nil,
            height: .absolute(44),
            minWidth: nil,
            minHeight: nil,
            maxWidth: nil,
            maxHeight: nil,
            padding: IR.EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        )

        // Disabled state
        let disabledStyle = ButtonStateStyle(
            textColor: IR.Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3),
            fontSize: 16,
            fontWeight: .semibold,
            backgroundColor: IR.Color(red: 0.0, green: 0.48, blue: 1.0, alpha: 0.3),
            cornerRadius: 10,
            border: nil,
            shadow: nil,
            tintColor: nil,
            width: nil,
            height: .absolute(44),
            minWidth: nil,
            minHeight: nil,
            maxWidth: nil,
            maxHeight: nil,
            padding: IR.EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        )

        // Selected state
        let selectedStyle = ButtonStateStyle(
            textColor: .white,
            fontSize: 16,
            fontWeight: .semibold,
            backgroundColor: IR.Color(red: 0.0, green: 0.34, blue: 0.72, alpha: 1.0), // Darker blue
            cornerRadius: 10,
            border: nil,
            shadow: nil,
            tintColor: nil,
            width: nil,
            height: .absolute(44),
            minWidth: nil,
            minHeight: nil,
            maxWidth: nil,
            maxHeight: nil,
            padding: IR.EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        )

        let button = ButtonNode(
            id: "test-button-states",
            label: "Button States",
            styleId: nil,
            styles: ButtonStyles(
                normal: normalStyle,
                selected: selectedStyle,
                disabled: disabledStyle
            ),
            isSelectedBinding: nil,
            fillWidth: true,
            onTap: nil,
            image: nil,
            imagePlacement: .leading,
            imageSpacing: 8,
            buttonShape: nil
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
            let style = ButtonStateStyle(
                textColor: textColor,
                fontSize: 16,
                fontWeight: .semibold,
                backgroundColor: bgColor,
                cornerRadius: 10,
                border: nil,
                shadow: nil,
                tintColor: nil,
                width: nil,
                height: .absolute(44),
                minWidth: nil,
                minHeight: nil,
                maxWidth: nil,
                maxHeight: nil,
                padding: IR.EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            )

            let button = ButtonNode(
                id: "test-button-\(name)",
                label: "\(name.capitalized) Button",
                styleId: nil,
                styles: ButtonStyles(normal: style),
                isSelectedBinding: nil,
                fillWidth: true,
                onTap: nil,
                image: nil,
                imagePlacement: .leading,
                imageSpacing: 8,
                buttonShape: nil
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
                    .padding(.horizontal, 20)
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor))
                    .cornerRadius(10)
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
        let style = ButtonStateStyle(
            textColor: IR.Color(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0), // Blue text
            fontSize: 16,
            fontWeight: .semibold,
            backgroundColor: nil,
            cornerRadius: 10,
            border: IR.Border(color: IR.Color(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0), width: 2),
            shadow: nil,
            tintColor: nil,
            width: nil,
            height: .absolute(44),
            minWidth: nil,
            minHeight: nil,
            maxWidth: nil,
            maxHeight: nil,
            padding: IR.EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        )

        let button = ButtonNode(
            id: "test-button-border",
            label: "Bordered Button",
            styleId: nil,
            styles: ButtonStyles(normal: style),
            isSelectedBinding: nil,
            fillWidth: true,
            onTap: nil,
            image: nil,
            imagePlacement: .leading,
            imageSpacing: 8,
            buttonShape: nil
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
                .padding(.horizontal, 20)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.clear)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.0, green: 0.48, blue: 1.0), lineWidth: 2)
                )
                .padding(1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }, size: StandardSnapshotSizes.compact)

        assertSnapshot(of: swiftUIImage, as: .image, named: "button-border-scals", record: false)
        assertSnapshot(of: canonicalImage, as: .image, named: "button-border-canonical", record: false)
    }
}
