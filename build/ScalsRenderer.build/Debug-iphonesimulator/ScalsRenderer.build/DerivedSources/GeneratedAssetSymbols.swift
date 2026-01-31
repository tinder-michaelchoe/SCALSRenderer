import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "DoubleDateHero" asset catalog image resource.
    static let doubleDateHero = DeveloperToolsSupport.ImageResource(name: "DoubleDateHero", bundle: resourceBundle)

    /// The "astrology" asset catalog image resource.
    static let astrology = DeveloperToolsSupport.ImageResource(name: "astrology", bundle: resourceBundle)

    /// The "touchUpAfter" asset catalog image resource.
    static let touchUpAfter = DeveloperToolsSupport.ImageResource(name: "touchUpAfter", bundle: resourceBundle)

    /// The "touchUpBefore" asset catalog image resource.
    static let touchUpBefore = DeveloperToolsSupport.ImageResource(name: "touchUpBefore", bundle: resourceBundle)

    /// The "womanAligator" asset catalog image resource.
    static let womanAligator = DeveloperToolsSupport.ImageResource(name: "womanAligator", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "DoubleDateHero" asset catalog image.
    static var doubleDateHero: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .doubleDateHero)
#else
        .init()
#endif
    }

    /// The "astrology" asset catalog image.
    static var astrology: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .astrology)
#else
        .init()
#endif
    }

    /// The "touchUpAfter" asset catalog image.
    static var touchUpAfter: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .touchUpAfter)
#else
        .init()
#endif
    }

    /// The "touchUpBefore" asset catalog image.
    static var touchUpBefore: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .touchUpBefore)
#else
        .init()
#endif
    }

    /// The "womanAligator" asset catalog image.
    static var womanAligator: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .womanAligator)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "DoubleDateHero" asset catalog image.
    static var doubleDateHero: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .doubleDateHero)
#else
        .init()
#endif
    }

    /// The "astrology" asset catalog image.
    static var astrology: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .astrology)
#else
        .init()
#endif
    }

    /// The "touchUpAfter" asset catalog image.
    static var touchUpAfter: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .touchUpAfter)
#else
        .init()
#endif
    }

    /// The "touchUpBefore" asset catalog image.
    static var touchUpBefore: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .touchUpBefore)
#else
        .init()
#endif
    }

    /// The "womanAligator" asset catalog image.
    static var womanAligator: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .womanAligator)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

