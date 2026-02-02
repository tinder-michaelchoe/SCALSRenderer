# ScalsRenderer

A server-driven UI framework for iOS that renders native SwiftUI and UIKit views from JSON definitions.

## Overview

ScalsRenderer uses an LLVM-inspired multi-stage pipeline to transform JSON into native UI:

```
JSON → Document (AST) → IR (Resolved) → Renderer → Native UI
```

This architecture enables:
- **Server-driven UI**: Update your app's UI without app store releases
- **Multiple renderers**: SwiftUI, UIKit, HTML (with Tailwind CSS), and debug output from the same IR
- **Type-safe resolution**: Styles, data bindings, and actions resolved at parse time
- **Flattened IR**: Fully resolved, platform-agnostic intermediate representation with no nested style objects
- **Reactive state**: Built-in state management with two-way binding

## Quick Start

```swift
import SwiftUI
import ScalsRendererFramework

struct ContentView: View {
    var body: some View {
        if let view = ScalsRendererView(jsonString: jsonDocument) {
            view
        }
    }
}
```

## Example JSON

```json
{
  "id": "hello-world",
  "version": "1.0",
  "styles": {
    "title": {
      "fontSize": 24,
      "fontWeight": "bold"
    }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "children": [
      {
        "type": "vstack",
        "spacing": 16,
        "children": [
          { "type": "label", "label": "Hello, World!", "styleId": "title" },
          { "type": "button", "label": "Tap Me" }
        ]
      }
    ]
  }
}
```

## Documentation

### Core Concepts

| Document | Description |
|----------|-------------|
| [Layer Architecture](Docs/LayerArchitecture.md) | The three-layer architecture: Document, Resolution, and IR layers with strict separation of concerns |
| [Rendering Pipeline](Docs/RenderingPipeline.md) | How JSON transforms into native UI through the multi-stage pipeline |
| [Components](Docs/Components.md) | Available UI components (label, button, textfield, image, gradient) |
| [Layouts](Docs/Layouts.md) | Layout containers (vstack, hstack, zstack, sectionLayout) |
| [Styling](Docs/Styling.md) | Style system with inheritance and resolution |
| [Actions](Docs/Actions.md) | Action system for handling user interactions |
| [State](Docs/State.md) | State management and data binding |

### Reference

| Document | Description |
|----------|-------------|
| [Future Enhancements](Docs/FutureEnhancements.md) | Planned features and potential renderer implementations |

## Architecture

The framework follows a strict three-layer architecture with explicit separation:

```
SCALS/                   # Core framework
├── Document/            # Layer 1: JSON schema types (AST)
│   ├── Document.swift        # Document.Definition, Document.StateValue
│   ├── Component.swift       # Document.Component
│   ├── LayoutNode.swift      # Document.LayoutNode, Document.Layout
│   ├── SectionLayout.swift   # Document.SectionLayout, Document.SectionDefinition
│   ├── Style.swift           # Document.Style
│   ├── Action.swift          # Document.Action
│   ├── DataSource.swift      # Document.DataSource
│   └── IRConversions.swift   # IRConvertible protocol for simple conversions
├── IR/                  # Layer 3: Fully resolved intermediate representation
│   ├── IR.swift              # IR types (Color, EdgeInsets, Shadow, etc.)
│   ├── RenderTree.swift      # RenderTree, RenderNode, flattened node types
│   ├── DocumentIRConversion.swift  # High-level conversion orchestration
│   ├── IRInitializers.swift  # IR initializers for merging logic
│   ├── Resolver.swift        # Main resolver entry point
│   └── Resolution/           # Layer 2: Document → IR conversion logic
│       ├── ComponentResolving.swift
│       ├── ContentResolver.swift
│       ├── LayoutResolver.swift
│       ├── ResolutionContext.swift
│       └── ResolvedStyle.swift  # Temporary style merging artifact
├── State/               # State management (thread-safe)
│   └── StateStore.swift
└── ViewTree/            # View tracking for reactive updates
    └── ViewNode.swift

ScalsModules/            # Renderers and extensions
├── SwiftUIRenderers/    # SwiftUI output
├── UIKitRenderers/      # UIKit output
├── HTMLRenderers/       # HTML output
├── iOS26HTMLRenderer/   # iOS 26-styled HTML with Tailwind CSS
├── ComponentResolvers/  # Component resolution implementations
└── ActionHandlers/      # Action handler implementations

ScalsRenderer/           # Example application
└── Examples/            # Comprehensive example catalog
    ├── ExampleCatalog.swift
    ├── Actions/         # Action system examples
    ├── Components/      # Component showcase
    ├── Complex/         # Real-world apps (Weather, Shopping, etc.)
    ├── CustomComponents/ # Custom component examples
    ├── Data/            # State and data binding
    ├── Layouts/         # Layout system examples
    └── Styles/          # Style inheritance and resolution
```

### Layer Architecture

ScalsRenderer follows a strict three-layer architecture:

| Layer | Purpose | Key Principle |
|-------|---------|---------------|
| **Layer 1: Document** | JSON schema types (AST) | Multiple ways to express properties, no business logic |
| **Layer 2: Resolution** | Document → IR conversion | All arithmetic, nil coalescing, merging, and defaults happen here |
| **Layer 3: IR** | Fully resolved representation | Flat, canonical, platform-agnostic nodes ready for rendering |

**The Golden Rule**: If you're doing arithmetic, nil coalescing, or conditionals in a renderer to determine a final property value, that logic belongs in the Resolution layer.

### Type Namespaces

| Layer | Namespace | Description |
|-------|-----------|-------------|
| Document (Layer 1) | `Document.*` | JSON types: `Document.Definition`, `Document.Component`, `Document.Style` |
| Resolution (Layer 2) | `ResolvedStyle` | Temporary artifacts used during resolution (not stored in final IR) |
| IR (Layer 3) | `IR.*`, node types | Fully resolved types: `IR.Color`, `IR.EdgeInsets`, `ContainerNode`, `TextNode` |

## Features

### Components
- **label**: Text display with static or dynamic content
- **button**: Interactive buttons with action handlers
- **textfield**: Text input with two-way state binding
- **image**: System icons, assets, or remote URLs
- **gradient**: Linear gradients with light/dark mode support
- **spacer**: Flexible spacing

### Layouts
- **vstack**: Vertical arrangement
- **hstack**: Horizontal arrangement
- **zstack**: Overlapping layers
- **sectionLayout**: Complex section-based layouts (horizontal scroll, list, grid)

### Styling
- Named styles with inheritance
- Font, color, size, and appearance properties
- Style resolution and flattening

### Actions
- **dismiss**: Close the current view
- **setState**: Update state values
- **showAlert**: Display alert dialogs
- **sequence**: Chain multiple actions
- **navigate**: Navigate between screens

### State
- Observable state store
- Path-based access (dot notation)
- Template interpolation
- Two-way binding for text fields

## Examples

The project includes a comprehensive example catalog demonstrating all features:

### Component Examples
- **Buttons, Labels, TextFields, Toggles, Sliders**: Core UI components
- **Images**: System symbols, assets, remote URLs
- **Gradients**: Linear gradients with color stops
- **Shapes**: Rectangles, circles, rounded rectangles

### Layout Examples
- **VStack, HStack, ZStack**: Basic layout containers
- **SectionLayout**: Advanced section-based layouts (horizontal scroll, list, grid, flow)
- **Alignment & Spacing**: Spacers and alignment options
- **Nested Layouts**: Complex nested structures

### Style Examples
- **Basic Styles**: Fonts, colors, padding, borders
- **Style Inheritance**: Cascading styles with overrides
- **Conditional Styles**: Dynamic styling based on state
- **Shadows**: Shadow effects with blur radius
- **Fractional Sizing**: Percentage-based dimensions

### Data & State Examples
- **Static Data**: Hardcoded values
- **Binding Data**: Two-way data binding
- **Expressions**: Dynamic expressions and template interpolation

### Action Examples
- **setState, toggleState**: State mutations
- **showAlert, dismiss**: Navigation and dialogs
- **navigate**: Screen navigation
- **sequence**: Action chaining
- **HTTP requests**: Network data fetching
- **Array operations**: List manipulation

### Complex Examples
Real-world application examples:
- **Weather Dashboard**: Multi-day forecast with icons
- **Shopping Cart**: E-commerce cart with item management
- **Task Manager**: Todo list with filtering
- **Music Player**: Audio player UI with controls
- **Plant Care Tracker**: Plant watering schedule
- **Dad Jokes**: API integration example
- **Astrology Mode**: Complex UI with animations
- **Met Museum**: Gallery browser

### Custom Component Examples
- **Photo Touch-Up**: Before/after comparison slider
- **Feedback Survey**: Rating and feedback form
- **Double Date**: Custom date picker component

## Renderers

| Renderer | Output | Use Case |
|----------|--------|----------|
| `SwiftUIRenderer` | SwiftUI `View` | Primary iOS/macOS rendering |
| `UIKitRenderer` | `UIView` | UIKit apps, custom integrations |
| `iOS26HTMLRenderer` | HTML + Tailwind CSS | iOS 26-styled web rendering with design tokens |
| `DebugRenderer` | `String` | Debugging, logging |

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+ (Swift 6 compatible)

## License

[Your License Here]
