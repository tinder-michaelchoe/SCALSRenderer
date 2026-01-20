//
//  PageIndicatorNodeView.swift
//  CladsModules
//
//  SwiftUI renderer for PageIndicatorNode
//

import CLADS
import SwiftUI

/// SwiftUI renderer for page indicator nodes
public struct PageIndicatorNodeSwiftUIRenderer: SwiftUINodeRendering {
    public static let nodeKind = RenderNodeKind.pageIndicator

    public init() {}

    @MainActor
    public func render(_ node: RenderNode, context: SwiftUIRenderContext) -> AnyView {
        guard case .pageIndicator(let indicatorNode) = node else {
            return AnyView(EmptyView())
        }
        return AnyView(
            PageIndicatorView(node: indicatorNode)
                .environmentObject(context.observableStateStore)
        )
    }
}

// MARK: - Page Indicator View

struct PageIndicatorView: View {
    let node: PageIndicatorNode
    @EnvironmentObject var stateStore: ObservableStateStore

    private var currentPage: Int {
        // Try direct state path first
        if let path = node.currentPagePath {
            return stateStore.get(path, as: Int.self) ?? 0
        }
        // Try template (for now, treat as state path by extracting variable name)
        if let template = node.currentPageTemplate {
            // Simple extraction: "${varName}" -> "varName"
            let cleaned = template.replacingOccurrences(of: "${", with: "").replacingOccurrences(of: "}", with: "")
            return stateStore.get(cleaned, as: Int.self) ?? 0
        }
        return 0
    }

    private var pageCount: Int {
        // Try static value first
        if let staticCount = node.pageCountStatic {
            return staticCount
        }
        // Then try state path
        if let path = node.pageCountPath {
            return stateStore.get(path, as: Int.self) ?? 5
        }
        return 5
    }

    var body: some View {
        HStack(spacing: node.dotSpacing) {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? node.currentDotColor.swiftUI : node.dotColor.swiftUI)
                    .frame(width: node.dotSize, height: node.dotSize)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
        .padding(EdgeInsets(
            top: node.style.paddingTop ?? 0,
            leading: node.style.paddingLeading ?? 0,
            bottom: node.style.paddingBottom ?? 0,
            trailing: node.style.paddingTrailing ?? 0
        ))
    }
}
