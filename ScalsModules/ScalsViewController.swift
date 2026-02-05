//
//  ScalsViewController.swift
//  ScalsModules
//
//  Main UIKit entry point for rendering SCALS documents.
//  Uses configuration-based initialization and delegate pattern for callbacks.
//

import SCALS
import UIKit

// MARK: - Delegate Protocol

/// Delegate protocol for ScalsViewController callbacks
@MainActor
public protocol ScalsViewControllerDelegate: AnyObject {
    /// Called when any state value changes
    func scalsViewController(_ viewController: ScalsViewController, didChangeState path: String, from oldValue: Any?, to newValue: Any?)

    /// Called when an action is about to be executed
    func scalsViewController(_ viewController: ScalsViewController, willExecuteAction actionId: String)

    /// Called when an action has finished executing
    func scalsViewController(_ viewController: ScalsViewController, didExecuteAction actionId: String)

    /// Called when a dismiss action is triggered
    func scalsViewControllerDidRequestDismiss(_ viewController: ScalsViewController)

    /// Called when a navigation action is triggered
    func scalsViewController(_ viewController: ScalsViewController, didRequestNavigation destination: String, presentation: Document.NavigationPresentation?)

    /// Called when an alert action is triggered
    func scalsViewController(_ viewController: ScalsViewController, didRequestAlert config: AlertConfiguration)
}

/// Default implementations (all optional)
public extension ScalsViewControllerDelegate {
    func scalsViewController(_ viewController: ScalsViewController, didChangeState path: String, from oldValue: Any?, to newValue: Any?) {}
    func scalsViewController(_ viewController: ScalsViewController, willExecuteAction actionId: String) {}
    func scalsViewController(_ viewController: ScalsViewController, didExecuteAction actionId: String) {}
    func scalsViewControllerDidRequestDismiss(_ viewController: ScalsViewController) {}
    func scalsViewController(_ viewController: ScalsViewController, didRequestNavigation destination: String, presentation: Document.NavigationPresentation?) {}
    func scalsViewController(_ viewController: ScalsViewController, didRequestAlert config: AlertConfiguration) {}
}

// MARK: - ScalsViewController

/// Main UIKit view controller for rendering SCALS documents.
///
/// This is the primary UIKit entry point for the SCALS renderer.
/// Uses configuration-based initialization and delegate pattern for callbacks.
///
/// Example usage:
/// ```swift
/// // Simplest usage
/// let vc = ScalsViewController(document: doc)
/// present(vc, animated: true)
///
/// // With configuration
/// let config = UIKitRendererConfiguration(
///     customComponents: [MyComponent.self],
///     designSystemProvider: myDesignSystem,
///     debugMode: true
/// )
/// let vc = ScalsViewController(document: doc, configuration: config)
/// vc.delegate = self
/// present(vc, animated: true)
/// ```
open class ScalsViewController: UIViewController {

    // MARK: - Public Properties

    /// Delegate for receiving callbacks
    public weak var delegate: ScalsViewControllerDelegate?

    /// The internal renderer view (accessible for embedding scenarios)
    public private(set) var rendererView: UIView!

    /// Access to the current state snapshot
    public var stateSnapshot: [String: Any] {
        return internalView.stateSnapshot
    }

    // MARK: - Private Properties

    private let internalView: ScalsUIKitView
    private let configuration: UIKitRendererConfiguration

    // MARK: - Initialization

    /// Initialize with a Document and configuration.
    ///
    /// - Parameters:
    ///   - document: The document definition to render
    ///   - configuration: Configuration containing registries and settings
    public init(
        document: Document.Definition,
        configuration: UIKitRendererConfiguration = UIKitRendererConfiguration()
    ) {
        self.configuration = configuration

        // Set up custom components if provided
        if !configuration.customComponents.isEmpty {
            let customRegistry = CustomComponentRegistry()
            customRegistry.register(configuration.customComponents)
            configuration.componentRegistry.setCustomComponentRegistry(customRegistry)

            // Register the custom component UIKit renderer
            let customRenderer = CustomComponentUIKitRenderer(customComponentRegistry: customRegistry)
            configuration.rendererRegistry.register(customRenderer)
        }

        // Create the internal UIKit view
        self.internalView = ScalsUIKitView(
            document: document,
            actionRegistry: configuration.actionRegistry,
            actionResolverRegistry: configuration.actionResolverRegistry,
            componentRegistry: configuration.componentRegistry,
            rendererRegistry: configuration.rendererRegistry,
            actionDelegate: configuration.actionDelegate,
            designSystemProvider: configuration.designSystemProvider,
            debugMode: configuration.debugMode
        )

        super.init(nibName: nil, bundle: nil)

        // Set up internal delegate forwarding
        internalView.delegate = self
    }

    /// Initialize from a JSON string with configuration.
    ///
    /// - Parameters:
    ///   - jsonString: JSON string defining the document
    ///   - configuration: Configuration containing registries and settings
    public convenience init?(
        jsonString: String,
        configuration: UIKitRendererConfiguration = UIKitRendererConfiguration()
    ) {
        guard let document = try? Document.Definition(jsonString: jsonString) else {
            return nil
        }
        self.init(document: document, configuration: configuration)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the renderer view
        rendererView = internalView
        view.addSubview(internalView)
        internalView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            internalView.topAnchor.constraint(equalTo: view.topAnchor),
            internalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            internalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            internalView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - State Access

    /// Set a state value programmatically
    public func setState(_ path: String, value: Any?) {
        internalView.setState(path, value: value)
    }

    /// Set typed state programmatically
    public func setTypedState<T: Encodable>(_ value: T) {
        internalView.setTypedState(value)
    }

    /// Set typed state at a specific path
    public func setTypedState<T: Encodable>(_ path: String, value: T) {
        internalView.setTypedState(path, value: value)
    }

    /// Get a state value
    public func getState(_ path: String) -> Any? {
        return internalView.getState(path)
    }

    /// Get a typed state value
    public func getState<T>(_ path: String, as type: T.Type = T.self) -> T? {
        return internalView.getState(path, as: type)
    }

    /// Get typed state
    public func getTypedState<T: Decodable>(_ type: T.Type = T.self) -> T? {
        return internalView.getTypedState(type)
    }

    // MARK: - Action Execution

    /// Execute an action by ID
    public func executeAction(_ actionId: String) {
        internalView.executeAction(actionId)
    }

    /// Force a full re-render of the view tree
    public func rerender() {
        internalView.rerender()
    }
}

// MARK: - ScalsRendererDelegate Conformance

extension ScalsViewController: ScalsRendererDelegate {
    public func scalsRenderer(_ view: ScalsUIKitView, didChangeState path: String, from oldValue: Any?, to newValue: Any?) {
        delegate?.scalsViewController(self, didChangeState: path, from: oldValue, to: newValue)
    }

    public func scalsRenderer(_ view: ScalsUIKitView, willExecuteAction actionId: String) {
        delegate?.scalsViewController(self, willExecuteAction: actionId)
    }

    public func scalsRenderer(_ view: ScalsUIKitView, didExecuteAction actionId: String) {
        delegate?.scalsViewController(self, didExecuteAction: actionId)
    }

    public func scalsRendererDidRequestDismiss(_ view: ScalsUIKitView) {
        if let delegate = delegate {
            delegate.scalsViewControllerDidRequestDismiss(self)
        } else {
            // Default behavior: dismiss the view controller
            dismiss(animated: true)
        }
    }

    public func scalsRenderer(_ view: ScalsUIKitView, didRequestNavigation destination: String, presentation: Document.NavigationPresentation) {
        delegate?.scalsViewController(self, didRequestNavigation: destination, presentation: presentation)
    }

    public func scalsRenderer(_ view: ScalsUIKitView, didRequestAlert config: AlertConfiguration) {
        if let delegate = delegate {
            delegate.scalsViewController(self, didRequestAlert: config)
        } else {
            // Default behavior: present the alert
            AlertPresenter.present(config)
        }
    }
}
