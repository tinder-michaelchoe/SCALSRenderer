//
//  ShapeUIKitRenderer.swift
//  ScalsModules
//
//  UIKit renderer for ShapeNode.
//

import SCALS
import UIKit

/// Renders ShapeNode to UIView with CAShapeLayer
public struct ShapeUIKitRenderer: UIKitNodeRendering {

    public static let nodeKind: RenderNodeKind = .shape

    public init() {}

    public func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard let shapeNode = node.data(ShapeNode.self) else {
            return UIView()
        }

        let shapeView = ShapeView()
        shapeView.configure(with: shapeNode)
        return shapeView
    }
}

// MARK: - Shape View

/// A UIView that renders shapes using CAShapeLayer
private final class ShapeView: UIView {
    private let shapeLayer = CAShapeLayer()
    private var currentNode: ShapeNode?

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(shapeLayer)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with node: ShapeNode) {
        currentNode = node
        updateShape()
        applyStyle()
    }

    private func updateShape() {
        guard let node = currentNode else { return }

        let width: CGFloat
        if case .absolute(let value) = node.width {
            width = value
        } else {
            width = bounds.width
        }
        let height: CGFloat
        if case .absolute(let value) = node.height {
            height = value
        } else {
            height = bounds.height
        }
        let rect = CGRect(x: 0, y: 0, width: width, height: height)

        let path: UIBezierPath
        switch node.shapeType {
        case .rectangle:
            path = UIBezierPath(rect: rect)
        case .circle:
            path = UIBezierPath(ovalIn: rect)
        case .roundedRectangle(let cornerRadius):
            path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        case .capsule:
            path = UIBezierPath(roundedRect: rect, cornerRadius: min(width, height) / 2)
        case .ellipse:
            path = UIBezierPath(ovalIn: rect)
        }

        shapeLayer.path = path.cgPath
    }

    private func applyStyle() {
        guard let node = currentNode else { return }

        // Apply fill color (non-optional)
        shapeLayer.fillColor = node.fillColor.uiColor.cgColor

        // Apply stroke
        if let strokeColor = node.strokeColor {
            shapeLayer.strokeColor = strokeColor.uiColor.cgColor
            shapeLayer.lineWidth = node.strokeWidth
        } else {
            shapeLayer.strokeColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 0
        }

        // Apply size constraints if specified
        if let width = node.width {
            switch width {
            case .absolute(let value):
                widthAnchor.constraint(equalToConstant: value).isActive = true
            case .fractional(let fraction):
                if let superview = superview {
                    widthAnchor.constraint(
                        equalTo: superview.widthAnchor,
                        multiplier: fraction
                    ).isActive = true
                } else {
                    print("Warning: Cannot apply fractional width - view has no superview")
                }
            }
        }
        if let height = node.height {
            switch height {
            case .absolute(let value):
                heightAnchor.constraint(equalToConstant: value).isActive = true
            case .fractional(let fraction):
                if let superview = superview {
                    heightAnchor.constraint(
                        equalTo: superview.heightAnchor,
                        multiplier: fraction
                    ).isActive = true
                } else {
                    print("Warning: Cannot apply fractional height - view has no superview")
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        updateShape()
    }
}
