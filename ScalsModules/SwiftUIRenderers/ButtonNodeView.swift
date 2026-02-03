//
//  ButtonNodeView.swift
//  ScalsModules
//
//  SwiftUI renderer and view for ButtonNode.
//

import SCALS
import SwiftUI

// MARK: - Button Node SwiftUI Renderer

public struct ButtonNodeSwiftUIRenderer: SwiftUINodeRendering {
    public static let nodeKind = RenderNodeKind.button

    public init() {}

    @MainActor
    public func render(_ node: RenderNode, context: SwiftUIRenderContext) -> AnyView {
        guard case .button(let buttonNode) = node else {
            return AnyView(EmptyView())
        }
        return AnyView(
            ButtonNodeView(node: buttonNode, actionContext: context.actionContext)
                .environmentObject(context.observableStateStore)
        )
    }
}

// MARK: - Button Node View

struct ButtonNodeView: View {
    let node: ButtonNode
    let actionContext: ActionContext
    @EnvironmentObject var stateStore: ObservableStateStore

    /// Check if button is selected based on state binding
    private var isSelected: Bool {
        guard let bindingPath = node.isSelectedBinding else { return false }
        return stateStore.get(bindingPath) as? Bool ?? false
    }

    /// Get the current style based on selection state
    private var currentStyle: ButtonStateStyle {
        node.styles.style(isSelected: isSelected)
    }

    /// Calculate effective corner radius based on buttonShape or style
    private var effectiveCornerRadius: CGFloat {
        guard let shape = node.buttonShape else {
            return currentStyle.cornerRadius
        }

        switch shape {
        case .circle:
            let width: CGFloat
            if case .absolute(let value) = currentStyle.width {
                width = value
            } else {
                width = 44
            }
            let height: CGFloat
            if case .absolute(let value) = currentStyle.height {
                height = value
            } else {
                height = 44
            }
            return min(width, height) / 2

        case .capsule:
            let height: CGFloat
            if case .absolute(let value) = currentStyle.height {
                height = value
            } else {
                height = 44
            }
            return height / 2

        case .roundedSquare:
            return 10  // Fixed moderate rounding
        }
    }

    var body: some View {
        Button(action: handleTap) {
            buttonLabel
                .applyTextStyle(from: currentStyle)
                .padding(.top, currentStyle.padding.top)
                .padding(.bottom, currentStyle.padding.bottom)
                .padding(.leading, currentStyle.padding.leading)
                .padding(.trailing, currentStyle.padding.trailing)
                .modifier(DimensionFrameModifier(
                    width: currentStyle.width,
                    height: currentStyle.height,
                    minWidth: currentStyle.minWidth,
                    minHeight: currentStyle.minHeight,
                    maxWidth: currentStyle.maxWidth,
                    maxHeight: currentStyle.maxHeight
                ))
                .frame(
                    maxWidth: node.fillWidth ? .infinity : nil,
                    alignment: .center
                )
                // Background (optional - only apply if specified)
                .modifier(OptionalBackgroundModifier(color: currentStyle.backgroundColor))
                .cornerRadius(effectiveCornerRadius)
                .overlay(
                    Group {
                        if let border = currentStyle.border, border.width > 0 {
                            RoundedRectangle(cornerRadius: effectiveCornerRadius)
                                .strokeBorder(border.color.swiftUI, lineWidth: border.width)
                        }
                    }
                )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var buttonLabel: some View {
        if let image = node.image {
            // Image + Text or Image-only
            labelWithImage(image)
        } else {
            // Text-only (existing)
            Text(node.label)
        }
    }

    @ViewBuilder
    private func labelWithImage(_ imageSource: ImageNode.Source) -> some View {
        let imageView = resolveImage(imageSource)

        switch node.imagePlacement {
        case .leading:
            HStack(spacing: node.imageSpacing) {
                imageView
                if !node.label.isEmpty {
                    Text(node.label)
                }
            }
        case .trailing:
            HStack(spacing: node.imageSpacing) {
                if !node.label.isEmpty {
                    Text(node.label)
                }
                imageView
            }
        case .top:
            VStack(spacing: node.imageSpacing) {
                imageView
                if !node.label.isEmpty {
                    Text(node.label)
                }
            }
        case .bottom:
            VStack(spacing: node.imageSpacing) {
                if !node.label.isEmpty {
                    Text(node.label)
                }
                imageView
            }
        }
    }

    @ViewBuilder
    private func resolveImage(_ source: ImageNode.Source) -> some View {
        switch source {
        case .sfsymbol(let name):
            Image(systemName: name)
                .renderingMode(currentStyle.tintColor != nil ? .template : .original)
                .foregroundStyle(currentStyle.tintColor?.swiftUI ?? Color.primary)
        case .asset(let name):
            Image(name)
                .renderingMode(currentStyle.tintColor != nil ? .template : .original)
                .foregroundStyle(currentStyle.tintColor?.swiftUI ?? Color.primary)
        case .url(let url):
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
        case .statePath(let template):
            // Dynamic URL from state - resolve template
            let resolvedURL = resolveTemplateURL(template)
            if let url = resolvedURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
            }

        case .activityIndicator:
            ProgressView()
        }
    }

    /// Resolves a template URL by replacing ${...} with state values
    private func resolveTemplateURL(_ template: String) -> URL? {
        var resolved = template
        let pattern = #"\$\{([^}]+)\}"#

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return URL(string: template)
        }

        let matches = regex.matches(in: template, range: NSRange(template.startIndex..., in: template))
        for match in matches.reversed() {
            if let range = Range(match.range, in: template),
               let pathRange = Range(match.range(at: 1), in: template) {
                let path = String(template[pathRange])
                if let value = stateStore.get(path) {
                    resolved.replaceSubrange(range, with: "\(value)")
                }
            }
        }

        return URL(string: resolved)
    }

    private func handleTap() {
        guard let binding = node.onTap else { return }
        Task { @MainActor in
            switch binding {
            case .reference(let actionId):
                await actionContext.executeAction(id: actionId)
            case .inline(let action):
                await actionContext.executeAction(action)
            }
        }
    }
}
