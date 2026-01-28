//
//  RendererTestHelpers.swift
//  ScalsModulesTests
//
//  Helper functions for rendering nodes and trees to images for snapshot testing.
//

import SwiftUI
import UIKit
import WebKit
import SCALS
@testable import ScalsModules

/// Helper functions for rendering nodes and trees to UIImage for snapshot testing
struct RendererTestHelpers {

    // MARK: - HTML Capture State Management

    /// Temporary storage for active webViews to prevent deallocation during capture
    private static var activeWebViews: [String: WKWebView] = [:]
    private static let webViewLock = NSLock()

    // MARK: - SwiftUI Rendering

    /// Renders a RenderNode using SwiftUI renderer and captures it as an image
    /// - Parameters:
    ///   - node: The node to render
    ///   - size: The size to render at
    ///   - traits: UITraitCollection for customizing appearance (light/dark mode, etc.)
    /// - Returns: A UIImage of the rendered node
    @MainActor
    static func renderSwiftUI(_ node: RenderNode, size: CGSize, traits: UITraitCollection = UITraitCollection()) async -> UIImage {
        let tree = RenderTree(root: RootNode(children: [node]), stateStore: StateStore(), actions: [:])
        return await renderSwiftUITree(tree, size: size, traits: traits)
    }

    /// Renders a RenderTree using SwiftUI renderer and captures it as an image
    /// - Parameters:
    ///   - tree: The tree to render
    ///   - size: The size to render at
    ///   - traits: UITraitCollection for customizing appearance (light/dark mode, etc.)
    /// - Returns: A UIImage of the rendered tree
    @MainActor
    static func renderSwiftUITree(_ tree: RenderTree, size: CGSize, traits: UITraitCollection = UITraitCollection()) async -> UIImage {
        // Create renderer dependencies
        let stateStore = StateStore()
        let actionContext = ActionContext(
            stateStore: stateStore,
            actionDefinitions: [:],
            registry: ActionRegistry()
        )
        let registry = SwiftUINodeRendererRegistry.default

        // Create renderer
        let renderer = SwiftUIRenderer(
            actionContext: actionContext,
            rendererRegistry: registry,
            designSystemProvider: nil
        )

        // Render and capture
        let view = renderer.render(tree)
        return await captureSwiftUIView(view, size: size, traits: traits)
    }

    /// Renders a canonical SwiftUI view (for comparison) and captures it as an image
    /// - Parameters:
    ///   - content: ViewBuilder closure that creates the canonical view
    ///   - size: The size to render at
    ///   - traits: UITraitCollection for customizing appearance (light/dark mode, etc.)
    /// - Returns: A UIImage of the rendered canonical view
    @MainActor
    static func renderCanonicalView<Content: View>(
        @ViewBuilder _ content: () -> Content,
        size: CGSize,
        traits: UITraitCollection = UITraitCollection()
    ) async -> UIImage {
        let view = content()
        return await captureSwiftUIView(view, size: size, traits: traits)
    }

    // MARK: - UIKit Rendering

    /// Renders a RenderNode using UIKit renderer and captures it as an image
    /// - Parameters:
    ///   - node: The node to render
    ///   - size: The size to render at
    ///   - traits: UITraitCollection for customizing appearance (light/dark mode, etc.)
    /// - Returns: A UIImage of the rendered node
    @MainActor
    static func renderUIKit(_ node: RenderNode, size: CGSize, traits: UITraitCollection = UITraitCollection()) async -> UIImage {
        let tree = RenderTree(root: RootNode(children: [node]), stateStore: StateStore(), actions: [:])
        return await renderUIKitTree(tree, size: size, traits: traits)
    }

    /// Renders a RenderTree using UIKit renderer and captures it as an image
    /// - Parameters:
    ///   - tree: The tree to render
    ///   - size: The size to render at
    ///   - traits: UITraitCollection for customizing appearance (light/dark mode, etc.)
    /// - Returns: A UIImage of the rendered tree
    @MainActor
    static func renderUIKitTree(_ tree: RenderTree, size: CGSize, traits: UITraitCollection = UITraitCollection()) async -> UIImage {
        // Create renderer dependencies
        let stateStore = StateStore()
        let actionContext = ActionContext(
            stateStore: stateStore,
            actionDefinitions: [:],
            registry: ActionRegistry()
        )
        let registry = UIKitNodeRendererRegistry.default

        // Create renderer
        let renderer = UIKitRenderer(
            actionContext: actionContext,
            registry: registry
        )

        // Render and capture
        let view = renderer.render(tree)
        return await captureUIKitView(view, size: size, traits: traits)
    }

    // MARK: - HTML Rendering

    /// Renders a RenderNode using HTML renderer and captures it as an image
    /// - Parameters:
    ///   - node: The node to render
    ///   - size: The size to render at
    /// - Returns: A UIImage of the rendered HTML
    @MainActor
    static func renderHTML(_ node: RenderNode, size: CGSize) async throws -> UIImage {
        let tree = RenderTree(root: RootNode(children: [node]), stateStore: StateStore(), actions: [:])
        return try await renderHTMLTree(tree, size: size)
    }

    /// Renders a RenderTree using HTML renderer and captures it as an image
    /// - Parameters:
    ///   - tree: The tree to render
    ///   - size: The size to render at
    /// - Returns: A UIImage of the rendered HTML
    @MainActor
    static func renderHTMLTree(_ tree: RenderTree, size: CGSize) async throws -> UIImage {
        // Create renderer
        let renderer = HTMLRenderer()

        // Render to HTML
        let output = renderer.render(tree)

        // Capture HTML as image using WKWebView
        return try await captureHTML(output.fullDocument, size: size)
    }

    // MARK: - Private Capture Methods

    /// Captures a SwiftUI view as a UIImage
    @MainActor
    private static func captureSwiftUIView<Content: View>(_ view: Content, size: CGSize, traits: UITraitCollection) async -> UIImage {
        // Create a window to host the view (required for SwiftUI rendering)
        let window = UIWindow(frame: CGRect(origin: .zero, size: size))

        let controller = UIHostingController(rootView: view)
        controller.view.frame = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .systemBackground

        // Apply trait collection using traitOverrides (iOS 17+)
        if let userInterfaceStyle = traits.userInterfaceStyle as UIUserInterfaceStyle? {
            controller.traitOverrides.userInterfaceStyle = userInterfaceStyle
        }

        // Add controller to window
        window.rootViewController = controller
        window.makeKeyAndVisible()

        // Force layout
        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()

        // Small delay to ensure SwiftUI has rendered
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        // Render to image
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            controller.view.layer.render(in: context.cgContext)
        }

        // Clean up
        window.isHidden = true
        window.rootViewController = nil

        return image
    }

    /// Captures a UIKit view as a UIImage
    @MainActor
    private static func captureUIKitView(_ view: UIView, size: CGSize, traits: UITraitCollection) async -> UIImage {
        view.frame = CGRect(origin: .zero, size: size)

        // Apply trait collection using traitOverrides (iOS 17+)
        let controller = UIViewController()
        controller.view = view
        if let userInterfaceStyle = traits.userInterfaceStyle as UIUserInterfaceStyle? {
            controller.traitOverrides.userInterfaceStyle = userInterfaceStyle
        }

        // Force layout
        view.layoutIfNeeded()

        // Render to image
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            view.layer.render(in: context.cgContext)
        }
    }

    /// Captures HTML as a UIImage using WKWebView
    @MainActor
    private static func captureHTML(_ html: String, size: CGSize) async throws -> UIImage {
        // Create unique ID for this capture operation
        let captureId = UUID().uuidString

        return try await withCheckedThrowingContinuation { continuation in
            let webView = WKWebView(frame: CGRect(origin: .zero, size: size))
            webView.isOpaque = false
            webView.backgroundColor = .systemBackground

            // Store webView to prevent deallocation
            webViewLock.lock()
            activeWebViews[captureId] = webView
            webViewLock.unlock()

            // Create navigation delegate to track load completion
            class NavigationDelegate: NSObject, WKNavigationDelegate {
                var completion: ((Result<UIImage, Error>) -> Void)?
                let captureId: String

                init(captureId: String) {
                    self.captureId = captureId
                    super.init()
                }

                func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                    // Small delay to ensure rendering is complete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let config = WKSnapshotConfiguration()
                        config.rect = CGRect(origin: .zero, size: webView.frame.size)

                        webView.takeSnapshot(with: config) { image, error in
                            // Clean up stored webView
                            RendererTestHelpers.webViewLock.lock()
                            RendererTestHelpers.activeWebViews.removeValue(forKey: self.captureId)
                            RendererTestHelpers.webViewLock.unlock()

                            if let error = error {
                                self.completion?(.failure(error))
                            } else if let image = image {
                                self.completion?(.success(image))
                            } else {
                                self.completion?(.failure(NSError(domain: "RendererTestHelpers", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to capture HTML snapshot"])))
                            }
                        }
                    }
                }

                func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
                    // Clean up stored webView
                    RendererTestHelpers.webViewLock.lock()
                    RendererTestHelpers.activeWebViews.removeValue(forKey: captureId)
                    RendererTestHelpers.webViewLock.unlock()

                    completion?(.failure(error))
                }

                func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
                    // Clean up stored webView
                    RendererTestHelpers.webViewLock.lock()
                    RendererTestHelpers.activeWebViews.removeValue(forKey: captureId)
                    RendererTestHelpers.webViewLock.unlock()

                    completion?(.failure(error))
                }
            }

            let delegate = NavigationDelegate(captureId: captureId)
            delegate.completion = { result in
                continuation.resume(with: result)
            }

            // Retain delegate with webView
            let key = UnsafeRawPointer(bitPattern: "delegate".hashValue)!
            objc_setAssociatedObject(webView, key, delegate, .OBJC_ASSOCIATION_RETAIN)
            webView.navigationDelegate = delegate

            // Load HTML
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
}
