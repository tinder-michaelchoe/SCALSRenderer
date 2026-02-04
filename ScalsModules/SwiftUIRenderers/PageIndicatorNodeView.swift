//
//  PageIndicatorNodeView.swift
//  ScalsModules
//
//  SwiftUI renderer for PageIndicatorNode
//

import SCALS
import SwiftUI

/// SwiftUI renderer for page indicator nodes
public struct PageIndicatorNodeSwiftUIRenderer: SwiftUINodeRendering {
    public static let nodeKind = RenderNodeKind.pageIndicator

    public init() {}

    @MainActor
    public func render(_ node: RenderNode, context: SwiftUIRenderContext) -> AnyView {
        guard let indicatorNode = node.data(PageIndicatorNode.self) else {
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
        // Get current page from state
        return stateStore.get(node.currentPagePath, as: Int.self) ?? 0
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
            top: node.padding.top,
            leading: node.padding.leading,
            bottom: node.padding.bottom,
            trailing: node.padding.trailing
        ))
    }
}
