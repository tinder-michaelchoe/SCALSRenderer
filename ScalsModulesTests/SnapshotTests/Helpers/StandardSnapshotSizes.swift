//
//  StandardSnapshotSizes.swift
//  ScalsModulesTests
//
//  Standard snapshot sizes for testing on iPhone 13 (390x844pt)
//

import CoreGraphics

/// Standard snapshot sizes for consistent testing across all snapshot tests.
/// All sizes use iPhone 13 screen width (390pt) to match the primary test device.
struct StandardSnapshotSizes {
    /// iPhone 13 full screen size (390x844pt)
    static let iPhone13 = CGSize(width: 390, height: 844)

    /// iPhone 13 screen width constant (390pt)
    static let iPhone13ScreenWidth: CGFloat = 390

    /// Compact size for small components like single text elements or buttons (390x100pt)
    static let compact = CGSize(width: 390, height: 100)

    /// Standard size for typical components like cards or list items (390x200pt)
    static let standard = CGSize(width: 390, height: 200)

    /// Medium size for larger components or component groups (390x400pt)
    static let medium = CGSize(width: 390, height: 400)

    /// Large size for complex layouts or multiple components (390x600pt)
    static let large = CGSize(width: 390, height: 600)

    /// Full screen size for complete views (390x844pt)
    static let fullscreen = iPhone13

    /// Create a custom size with iPhone 13 width and specified height
    /// - Parameter height: The desired height in points
    /// - Returns: A CGSize with width=390pt and the specified height
    static func custom(height: CGFloat) -> CGSize {
        return CGSize(width: iPhone13ScreenWidth, height: height)
    }
}
