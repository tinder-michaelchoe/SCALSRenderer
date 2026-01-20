// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CladsWasm",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .executable(
            name: "CladsWasm",
            targets: ["CladsWasm"]
        ),
    ],
    dependencies: [
        // No external dependencies - using local CLADS module
    ],
    targets: [
        // CLADS core library
        .target(
            name: "CLADS",
            path: "CLADS",
            exclude: [
                // SwiftUI/UIKit renderers
                "Renderers/SwiftUI",
                "Renderers/UIKit",
                "Renderers/CladsUIKitView.swift",
                "Renderers/DebugRenderer.swift",
                "Renderers/UIKitRenderer.swift",
                "Rendering",
                // Extensibility (all depends on SwiftUI/UIKit)
                "Extensibility",
                // Lifecycle modifier (depends on SwiftUI)
                "Lifecycle/LifecycleModifier.swift"
            ],
            swiftSettings: [
                .swiftLanguageVersion(.v5),
                .unsafeFlags([
                    "-Xfrontend", "-disable-availability-checking",
                    "-Xfrontend", "-assume-single-threaded"
                ])
            ]
        ),
        // CladsResolvers module (component and layout resolvers)
        .target(
            name: "CladsResolvers",
            dependencies: ["CLADS"],
            path: "CladsModules",
            exclude: [
                "ComponentResolvers/PageIndicatorComponentResolver.swift",
                "ComponentResolvers/ShapeComponentResolver.swift"
            ],
            sources: [
                "ComponentResolvers",
                "SectionLayoutResolvers",
                "Extensions/SectionLayoutConfigResolverRegistry+Default.swift",
                "Extensions/Document+ComponentKind.swift"
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
            name: "CladsWasm",
            dependencies: [
                "CLADS",
                "CladsResolvers"
            ],
            path: "Sources/CladsWasm",
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
