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
    ///   - pinToEdges: If true, pins content to top-leading. If false (default), centers content.
    /// - Returns: A UIImage of the rendered node
    @MainActor
    static func renderSwiftUI(_ node: RenderNode, size: CGSize, traits: UITraitCollection = UITraitCollection(), pinToEdges: Bool = false) async -> UIImage {
        let tree = RenderTree(root: RootNode(children: [node]), stateStore: StateStore(), actions: [:])
        return await renderSwiftUITree(tree, size: size, traits: traits, pinToEdges: pinToEdges)
    }

    /// Renders a RenderTree using SwiftUI renderer and captures it as an image
    /// - Parameters:
    ///   - tree: The tree to render
    ///   - size: The size to render at
    ///   - traits: UITraitCollection for customizing appearance (light/dark mode, etc.)
    ///   - pinToEdges: If true, pins content to top-leading. If false (default), centers content.
    /// - Returns: A UIImage of the rendered tree
    @MainActor
    static func renderSwiftUITree(_ tree: RenderTree, size: CGSize, traits: UITraitCollection = UITraitCollection(), pinToEdges: Bool = false) async -> UIImage {
        // Create renderer dependencies using CoreManifest registries
        let registries = CoreManifest.createRegistries()
        let stateStore = StateStore()
        let document = Document.Definition(
            id: "test",
            root: Document.RootComponent(children: [])
        )
        let actionResolver = ActionResolver(registry: registries.actionResolverRegistry)
        let actionContext = ActionContext(
            stateStore: stateStore,
            actionDefinitions: [:],
            registry: registries.actionRegistry,
            actionResolver: actionResolver,
            document: document
        )

        // Create renderer
        let renderer = SwiftUIRenderer(
            actionContext: actionContext,
            rendererRegistry: registries.swiftUIRegistry,
            designSystemProvider: nil
        )

        // Render and capture
        let view = renderer.render(tree)
        return await captureSwiftUIView(view, size: size, traits: traits, pinToEdges: pinToEdges)
    }

    /// Renders a canonical SwiftUI view (for comparison) and captures it as an image
    /// - Parameters:
    ///   - content: ViewBuilder closure that creates the canonical view
    ///   - size: The size to render at
    ///   - traits: UITraitCollection for customizing appearance (light/dark mode, etc.)
    ///   - pinToEdges: If true, pins content to top-leading. If false (default), centers content.
    /// - Returns: A UIImage of the rendered canonical view
    @MainActor
    static func renderCanonicalView<Content: View>(
        @ViewBuilder _ content: () -> Content,
        size: CGSize,
        traits: UITraitCollection = UITraitCollection(),
        pinToEdges: Bool = false
    ) async -> UIImage {
        let view: some View = {
            VStack {
                content()
            }
        }()
        return await captureSwiftUIView(view, size: size, traits: traits, pinToEdges: pinToEdges)
    }

    // MARK: - UIKit Rendering

    /// Renders a RenderNode using UIKit renderer and captures it as an image
    /// - Parameters:
    ///   - node: The node to render
    ///   - size: The size to render at
    ///   - traits: UITraitCollection for customizing appearance (light/dark mode, etc.)
    ///   - pinToEdges: If true, pins content to top-leading. If false (default), centers content.
    /// - Returns: A UIImage of the rendered node
    @MainActor
    static func renderUIKit(_ node: RenderNode, size: CGSize, traits: UITraitCollection = UITraitCollection(), pinToEdges: Bool = false) async -> UIImage {
        let tree = RenderTree(root: RootNode(children: [node]), stateStore: StateStore(), actions: [:])
        return await renderUIKitTree(tree, size: size, traits: traits, pinToEdges: pinToEdges)
    }

    /// Renders a RenderTree using UIKit renderer and captures it as an image
    /// - Parameters:
    ///   - tree: The tree to render
    ///   - size: The size to render at
    ///   - traits: UITraitCollection for customizing appearance (light/dark mode, etc.)
    ///   - pinToEdges: If true, pins content to top-leading. If false (default), centers content.
    /// - Returns: A UIImage of the rendered tree
    @MainActor
    static func renderUIKitTree(_ tree: RenderTree, size: CGSize, traits: UITraitCollection = UITraitCollection(), pinToEdges: Bool = false) async -> UIImage {
        // Create renderer dependencies using CoreManifest registries
        let registries = CoreManifest.createRegistries()
        let stateStore = StateStore()
        let document = Document.Definition(
            id: "test",
            root: Document.RootComponent(children: [])
        )
        let actionResolver = ActionResolver(registry: registries.actionResolverRegistry)
        let actionContext = ActionContext(
            stateStore: stateStore,
            actionDefinitions: [:],
            registry: registries.actionRegistry,
            actionResolver: actionResolver,
            document: document
        )

        // Create renderer
        let renderer = UIKitRenderer(
            actionContext: actionContext,
            registry: registries.uiKitRegistry
        )

        // Render and capture
        let view = renderer.render(tree)
        return await captureUIKitView(view, size: size, traits: traits, pinToEdges: pinToEdges)
    }

    // MARK: - HTML Rendering

    /// Renders a RenderNode using HTML renderer and captures it as an image
    /// - Parameters:
    ///   - node: The node to render
    ///   - size: The size to render at
    ///   - pinToEdges: If true, pins content to top-leading. If false (default), centers content.
    /// - Returns: A UIImage of the rendered HTML
    @MainActor
    static func renderHTML(_ node: RenderNode, size: CGSize, pinToEdges: Bool = false) async throws -> UIImage {
        let tree = RenderTree(root: RootNode(children: [node]), stateStore: StateStore(), actions: [:])
        return try await renderHTMLTree(tree, size: size, pinToEdges: pinToEdges)
    }

    /// Renders a RenderTree using HTML renderer and captures it as an image
    /// - Parameters:
    ///   - tree: The tree to render
    ///   - size: The size to render at
    ///   - pinToEdges: If true, pins content to top-leading. If false (default), centers content.
    /// - Returns: A UIImage of the rendered HTML
    @MainActor
    static func renderHTMLTree(_ tree: RenderTree, size: CGSize, pinToEdges: Bool = false) async throws -> UIImage {
        // Create renderer
        let renderer = HTMLRenderer()

        // Render to HTML
        let output = renderer.render(tree)

        // Capture HTML as image using WKWebView
        return try await captureHTML(output.fullDocument, size: size, pinToEdges: pinToEdges)
    }

    // MARK: - Private Capture Methods

    /// Captures a SwiftUI view as a UIImage
    /// - Parameter pinToEdges: If true, aligns content to top-leading. If false, centers content.
    @MainActor
    private static func captureSwiftUIView<Content: View>(_ view: Content, size: CGSize, traits: UITraitCollection, pinToEdges: Bool = false) async -> UIImage {
        // Create a container view that will hold the content
        let containerView = UIView(frame: CGRect(origin: .zero, size: size))
        containerView.backgroundColor = .systemBackground

        // Apply trait collection
        if let userInterfaceStyle = traits.userInterfaceStyle as UIUserInterfaceStyle? {
            containerView.overrideUserInterfaceStyle = userInterfaceStyle
        }

        // Wrap content in a ScrollView to provide container context for containerRelativeFrame.
        // The ScrollView provides the sizing context that containerRelativeFrame needs to
        // calculate fractional widths/heights. Without this, fractional dimensions won't work.
        let alignment: SwiftUI.Alignment = pinToEdges ? .topLeading : .center
        let wrappedView = Group {
            view
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
        }
        .scrollDisabled(true)  // Disable scrolling - we just need the container context
        .frame(width: size.width, height: size.height)

        // Create the hosting controller with the wrapped view
        let controller = UIHostingController(rootView: wrappedView)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.backgroundColor = .clear

        // Add hosting controller's view to container
        containerView.addSubview(controller.view)

        // Pin the hosting controller's view to fill the container
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        // Create window and add container (needed for proper SwiftUI rendering)
        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.addSubview(containerView)
        window.makeKeyAndVisible()

        // Force layout
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()

        // Small delay to ensure SwiftUI has rendered
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        // Render the container to image
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            containerView.layer.render(in: context.cgContext)
        }

        // Clean up
        window.isHidden = true

        return image
    }

    /// Captures a UIKit view as a UIImage
    /// - Parameter pinToEdges: If true, pins content to top-leading. If false, centers content.
    @MainActor
    private static func captureUIKitView(_ view: UIView, size: CGSize, traits: UITraitCollection, pinToEdges: Bool = false) async -> UIImage {
        // Create a container view that will hold the content
        let containerView = UIView(frame: CGRect(origin: .zero, size: size))
        containerView.backgroundColor = .systemBackground

        // Apply trait collection
        if let userInterfaceStyle = traits.userInterfaceStyle as UIUserInterfaceStyle? {
            containerView.overrideUserInterfaceStyle = userInterfaceStyle
        }

        // Add the rendered view to container with Auto Layout
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)

        if pinToEdges {
            // Pin to all edges horizontally to allow fractional width elements to expand.
            // This ensures text alignment within those elements works correctly.
            // Keep vertical centering.
            NSLayoutConstraint.activate([
                view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                view.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor),
                view.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            ])
        } else {
            // Center the view using Auto Layout (default behavior)
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            ])
            // Prevent overflow with edge constraints
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor),
                view.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor),
                view.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor),
                view.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            ])
        }

        // Create window for proper rendering
        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.addSubview(containerView)
        window.makeKeyAndVisible()

        // Force layout
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()

        // Render the container to image
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            containerView.layer.render(in: context.cgContext)
        }

        // Clean up
        window.isHidden = true

        return image
    }

    /// Captures HTML as a UIImage using WKWebView
    /// - Parameter pinToEdges: If true, pins content to top-left. If false, centers content.
    @MainActor
    private static func captureHTML(_ html: String, size: CGSize, pinToEdges: Bool = false) async throws -> UIImage {
        let overrideCSS: String
        if pinToEdges {
            // Fill width and keep vertical centering.
            // This allows text-align and width percentage properties to work correctly.
            overrideCSS = """
            <style>
            html { height: 100%; }
            body { display: flex; justify-content: center; align-items: center; height: 100%; margin: 0; background-color: white !important; }
            .scals-root { min-height: auto !important; width: 100%; }
            </style>
            </head>
            """
        } else {
            // Center content (default behavior)
            overrideCSS = """
            <style>
            html { height: 100%; }
            body { display: flex; justify-content: center; align-items: center; height: 100%; margin: 0; background-color: white !important; }
            .scals-root { min-height: auto !important; }
            </style>
            </head>
            """
        }

        let styledHTML = html.replacingOccurrences(
            of: "</head>",
            with: overrideCSS
        )

        // Create unique ID for this capture operation
        let captureId = UUID().uuidString

        return try await withCheckedThrowingContinuation { continuation in
            let webView = WKWebView(frame: CGRect(origin: .zero, size: size))
            webView.isOpaque = false
            webView.backgroundColor = .white
            webView.scrollView.contentInset = .zero
            webView.scrollView.scrollIndicatorInsets = .zero
            webView.scrollView.contentInsetAdjustmentBehavior = .never

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

            // Load HTML with centering
            webView.loadHTMLString(styledHTML, baseURL: nil)
        }
    }
}
