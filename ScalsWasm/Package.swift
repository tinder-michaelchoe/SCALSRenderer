// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScalsWasm",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .executable(
            name: "ScalsWasm",
            targets: ["ScalsWasm"]
        ),
    ],
    dependencies: [
        // No external dependencies - using local SCALS module
    ],
    targets: [
        // SCALS core library
        .target(
            name: "SCALS",
            path: "SCALS",
            exclude: [
                // Lifecycle modifier (depends on SwiftUI)
                "Lifecycle/LifecycleModifier.swift",
                // Extensibility custom components (depend on SwiftUI/UIKit)
                "Extensibility/CustomComponent.swift",
                "Extensibility/CustomComponentRenderNode.swift",
                "Extensibility/CustomComponentResolver.swift"
            ],
            swiftSettings: [
                .swiftLanguageVersion(.v5),
                .unsafeFlags([
                    "-Xfrontend", "-disable-availability-checking",
                    "-Xfrontend", "-assume-single-threaded"
                ])
            ]
        ),
        // ScalsResolvers module (component and layout resolvers)
        .target(
            name: "ScalsResolvers",
            dependencies: ["SCALS"],
            path: "ScalsModules",
            exclude: [
                // Root-level platform-specific files
                "ScalsViewController.swift",
                "ScalsRendererView.swift",

                // Platform-specific directories
                "Configuration",
                "UIKit",
                "SwiftUI",
                "Presenters",
                "SectionLayoutRenderers",
                "iOS26HTMLRenderer",

                // Platform-specific renderers in Components
                "Components/Button/ButtonUIKitRenderer.swift",
                "Components/Button/ButtonSwiftUIRenderer.swift",
                "Components/Container/ContainerUIKitRenderer.swift",
                "Components/Container/ContainerSwiftUIRenderer.swift",
                "Components/Divider/DividerUIKitRenderer.swift",
                "Components/Divider/DividerSwiftUIRenderer.swift",
                "Components/Gradient/GradientUIKitRenderer.swift",
                "Components/Gradient/GradientSwiftUIRenderer.swift",
                "Components/Image/ImageUIKitRenderer.swift",
                "Components/Image/ImageSwiftUIRenderer.swift",
                "Components/PageIndicator/PageIndicatorUIKitRenderer.swift",
                "Components/PageIndicator/PageIndicatorSwiftUIRenderer.swift",
                "Components/SectionLayout/SectionLayoutUIKitRenderer.swift",
                "Components/SectionLayout/SectionLayoutSwiftUIRenderer.swift",
                "Components/Shape/ShapeUIKitRenderer.swift",
                "Components/Shape/ShapeSwiftUIRenderer.swift",
                "Components/Slider/SliderSwiftUIRenderer.swift",
                "Components/Spacer/SpacerUIKitRenderer.swift",
                "Components/Spacer/SpacerSwiftUIRenderer.swift",
                "Components/Text/TextUIKitRenderer.swift",
                "Components/Text/TextSwiftUIRenderer.swift",
                "Components/TextField/TextFieldUIKitRenderer.swift",
                "Components/TextField/TextFieldSwiftUIRenderer.swift",
                "Components/Toggle/ToggleSwiftUIRenderer.swift",

                // All component bundles (depend on ComponentBundle protocol from Manifests)
                "Components/Button/ButtonBundle.swift",
                "Components/Container/ContainerBundle.swift",
                "Components/Divider/DividerBundle.swift",
                "Components/Gradient/GradientBundle.swift",
                "Components/Image/ImageBundle.swift",
                "Components/PageIndicator/PageIndicatorBundle.swift",
                "Components/SectionLayout/SectionLayoutBundle.swift",
                "Components/Shape/ShapeBundle.swift",
                "Components/Slider/SliderBundle.swift",
                "Components/Spacer/SpacerBundle.swift",
                "Components/Text/TextBundle.swift",
                "Components/TextField/TextFieldBundle.swift",
                "Components/Toggle/ToggleBundle.swift",

                // Manifests (not needed for WASM)
                "Manifests",

                // Documentation
                "CladsModules.docc",
                "HTMLRenderers/HTMLRenderer.docc",
                "HTMLRenderers/Resources",

                // Debug tools (depend on SwiftUI)
                "Debug",

                // Platform-specific extensibility files (UIKit/SwiftUI)
                "Extensibility/CustomComponentSwiftUIRenderer.swift",
                "Extensibility/ScalsActionsModifier.swift",
                "Extensibility/ScalsStyleModifier.swift",
                "Extensibility/ComponentRegistration.swift",

                // Action handlers (not needed for WASM - no interactivity)
                "Actions/Dismiss/DismissHandler.swift",
                "Actions/Navigate/NavigateHandler.swift",
                "Actions/OpenURL/OpenURLHandler.swift",
                "Actions/Request/RequestHandler.swift",
                "Actions/SetState/SetStateHandler.swift",
                "Actions/Sequence/SequenceHandler.swift",
                "Actions/ShowAlert/ShowAlertHandler.swift",
                "Actions/ToggleState/ToggleStateHandler.swift"
            ],
            sources: [
                "Components",
                "Actions",
                "SectionLayoutResolvers",
                "Resolution",
                "Extensions",
                "Extensibility",
                "Debug",
                "ViewTree",
                "HTMLRenderers"
            ],
            swiftSettings: [
                .swiftLanguageVersion(.v5),
                .unsafeFlags([
                    "-Xfrontend", "-disable-availability-checking",
                    "-Xfrontend", "-assume-single-threaded"
                ])
            ]
        ),
        // Main executable
        .executableTarget(
            name: "ScalsWasm",
            dependencies: [
                "SCALS",
                "ScalsResolvers"
            ],
            path: "Sources/ScalsWasm",
            swiftSettings: [
                .swiftLanguageVersion(.v5),
                .unsafeFlags([
                    "-Xfrontend", "-disable-availability-checking",
                    "-Xfrontend", "-assume-single-threaded"
                ])
            ]
        ),
    ]
)
