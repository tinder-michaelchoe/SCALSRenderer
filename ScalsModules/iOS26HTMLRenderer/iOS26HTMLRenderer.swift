//
//  iOS26HTMLRenderer.swift
//  ScalsRendererFramework
//
//  Main renderer for generating iOS 26-styled HTML with Tailwind CSS.
//

import Foundation
import SCALS

/// iOS 26 HTML renderer that generates pure HTML with Tailwind CSS classes
public struct iOS26HTMLRenderer: Renderer {
    public typealias Output = String

    /// Initialize the iOS 26 HTML renderer
    public init() {}

    /// Render a RenderTree to a complete HTML document
    ///
    /// - Parameter tree: The resolved render tree to render
    /// - Returns: Complete HTML document string with Tailwind CSS
    public func render(_ tree: RenderTree) -> String {
        var nodeRenderer = iOS26HTMLNodeRenderer()
        let bodyContent = nodeRenderer.render(tree.root)

        return iOS26DesignTokens.wrapInDocument(
            html: bodyContent,
            colorScheme: tree.root.colorScheme,
            backgroundColor: tree.root.backgroundColor
        )
    }
}
