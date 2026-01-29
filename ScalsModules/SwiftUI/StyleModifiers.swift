//
//  StyleModifiers.swift
//  SCALS
//
//  SwiftUI View extensions for applying IR.Style properties.
//

import SCALS
import SwiftUI

// MARK: - TextAlignment Extension

extension TextAlignment {
    func toFrameAlignment() -> Alignment {
        switch self {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        }
    }
}

// MARK: - Style Modifiers

public extension View {
    func applyTextStyle(_ style: IR.Style) -> some View {
        let alignment = style.textAlignment?.swiftUI ?? .leading

        return self
            .font(style.swiftUIFont)
            .foregroundColor(style.textColor?.swiftUI)
            .multilineTextAlignment(alignment)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            // For center/trailing alignment, expand to full width so alignment is visible
            .frame(maxWidth: (alignment == .center || alignment == .trailing) ? .infinity : nil, alignment: alignment.toFrameAlignment())
    }

    func applyContainerStyle(_ style: IR.Style) -> some View {
        self
            .padding(.top, style.paddingTop ?? 0)
            .padding(.bottom, style.paddingBottom ?? 0)
            .padding(.leading, style.paddingLeading ?? 0)
            .padding(.trailing, style.paddingTrailing ?? 0)
            .frame(width: style.width, height: style.height)
            .frame(minWidth: style.minWidth, minHeight: style.minHeight)
            .frame(maxWidth: style.maxWidth, maxHeight: style.maxHeight)
            .background(style.backgroundColor?.swiftUI ?? Color.clear)
            .cornerRadius(style.cornerRadius ?? 0)
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius ?? 0)
                    .stroke(style.borderColor?.swiftUI ?? Color.clear, lineWidth: style.borderWidth ?? 0)
            )
    }
}
