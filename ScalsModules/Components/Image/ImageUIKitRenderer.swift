//
//  ImageUIKitRenderer.swift
//  ScalsModules
//
//  Renders ImageNode to UIImageView.
//

import SCALS
import UIKit

/// Renders image nodes to UIImageView
public struct ImageUIKitRenderer: UIKitNodeRendering {

    public static let nodeKind: RenderNodeKind = .image

    public init() {}

    public func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard let imageNode = node.data(ImageNode.self) else {
            return UIView()
        }

        // Handle activity indicator as a special case
        if case .activityIndicator = imageNode.source {
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.startAnimating()

            if let width = imageNode.width {
                switch width {
                case .absolute(let value):
                    activityIndicator.widthAnchor.constraint(equalToConstant: value).isActive = true
                case .fractional(let fraction):
                    if let superview = activityIndicator.superview {
                        activityIndicator.widthAnchor.constraint(
                            equalTo: superview.widthAnchor,
                            multiplier: fraction
                        ).isActive = true
                    } else {
                        print("Warning: Cannot apply fractional width - view has no superview")
                    }
                }
            }
            if let height = imageNode.height {
                switch height {
                case .absolute(let value):
                    activityIndicator.heightAnchor.constraint(equalToConstant: value).isActive = true
                case .fractional(let fraction):
                    if let superview = activityIndicator.superview {
                        activityIndicator.heightAnchor.constraint(
                            equalTo: superview.heightAnchor,
                            multiplier: fraction
                        ).isActive = true
                    } else {
                        print("Warning: Cannot apply fractional height - view has no superview")
                    }
                }
            }

            return activityIndicator
        }

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Set placeholder while loading
        let placeholderImage: UIImage? = {
            switch imageNode.placeholder ?? .sfsymbol(name: "photo") {
            case .sfsymbol(let name):
                return UIImage(systemName: name)
            case .asset(let name):
                return UIImage(named: name)
            case .url, .statePath:
                return UIImage(systemName: "photo")
            case .activityIndicator:
                return nil // Don't use image for activity indicator placeholder
            }
        }()

        switch imageNode.source {
        case .sfsymbol(let name):
            imageView.image = UIImage(systemName: name)
        case .asset(let name):
            imageView.image = UIImage(named: name)
        case .url(let url):
            imageView.image = placeholderImage
            loadImageAsync(from: url, into: imageView, placeholder: placeholderImage)
        case .statePath:
            // statePath should be resolved to a URL by the resolver before reaching here
            // If it reaches here, show placeholder
            imageView.image = placeholderImage
        case .activityIndicator:
            // Already handled above
            break
        }

        if let width = imageNode.width {
            switch width {
            case .absolute(let value):
                imageView.widthAnchor.constraint(equalToConstant: value).isActive = true
            case .fractional(let fraction):
                if let superview = imageView.superview {
                    imageView.widthAnchor.constraint(
                        equalTo: superview.widthAnchor,
                        multiplier: fraction
                    ).isActive = true
                } else {
                    print("Warning: Cannot apply fractional width - view has no superview")
                }
            }
        }
        if let height = imageNode.height {
            switch height {
            case .absolute(let value):
                imageView.heightAnchor.constraint(equalToConstant: value).isActive = true
            case .fractional(let fraction):
                if let superview = imageView.superview {
                    imageView.heightAnchor.constraint(
                        equalTo: superview.heightAnchor,
                        multiplier: fraction
                    ).isActive = true
                } else {
                    print("Warning: Cannot apply fractional height - view has no superview")
                }
            }
        }

        return imageView
    }

    private func loadImageAsync(from url: URL, into imageView: UIImageView, placeholder: UIImage?) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        imageView.image = image
                    }
                }
            } catch {
                print("Failed to load image from \(url): \(error)")
                await MainActor.run {
                    imageView.image = UIImage(systemName: "questionmark.circle")
                }
            }
        }
    }
}
