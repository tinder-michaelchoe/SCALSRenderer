//
//  ScalsRendererSizing.swift
//  SCALS
//
//  Size measurement infrastructure for ScalsRendererView.
//

import SwiftUI

// MARK: - Size Measurement View Modifier

/// Internal view modifier that measures the size of content as it's laid out
private struct SizeMeasuringModifier: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geometry.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                DispatchQueue.main.async {
                    self.size = newSize
                }
            }
    }
}

/// Preference key for propagating size measurements
private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// MARK: - View Extension

extension View {
    /// Measures the size of this view and binds it to the provided binding.
    ///
    /// This modifier measures the view's size as it's laid out and updates
    /// the provided binding whenever the size changes.
    ///
    /// - Parameter size: Binding to store the measured size
    /// - Returns: A view that measures and reports its size
    public func measuringSize(_ size: Binding<CGSize>) -> some View {
        modifier(SizeMeasuringModifier(size: size))
    }
}
