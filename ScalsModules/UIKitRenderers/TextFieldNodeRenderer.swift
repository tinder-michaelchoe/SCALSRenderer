//
//  TextFieldNodeRenderer.swift
//  ScalsModules
//
//  Renders TextFieldNode to UITextField.
//

import SCALS
import Combine
import UIKit

/// Renders text field nodes to BoundTextField
public struct TextFieldNodeRenderer: UIKitNodeRendering {

    public static let nodeKind: RenderNodeKind = .textField

    public init() {}

    public func render(_ node: RenderNode, context: UIKitRenderContext) -> UIView {
        guard case .textField(let textFieldNode) = node else {
            return UIView()
        }

        let field = BoundTextField(
            bindingPath: textFieldNode.bindingPath,
            stateStore: context.stateStore
        )
        field.placeholder = textFieldNode.placeholder
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.applyStyle(textFieldNode.style)

        return field
    }
}
