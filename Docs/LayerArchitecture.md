# Layer Architecture

Complete guide to the ScalsRenderer three-layer architecture with explicit, enforceable rules for each layer.

## The Golden Rule

**If you find yourself doing arithmetic, nil coalescing, or conditionals in a renderer to determine a final property value, that logic belongs in the Resolution layer, not the Renderer.**

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────┐
│                        Layer 1: Document                     │
│                      (JSON Representation)                    │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Multiple representations of properties:                 │ │
│  │ • Shorthand: horizontal, vertical                       │ │
│  │ • Specific: top, bottom, leading, trailing             │ │
│  │ • Style references: styleId (string)                   │ │
│  │ • Pure data structures, no business logic              │ │
│  └────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
                            │
                            │ IRConvertible protocol
                            │ .toIR() → simple conversion
                            ▼
┌──────────────────────────────────────────────────────────────┐
│                     Layer 2: Resolution                       │
│                  (Document → IR Conversion)                   │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Resolution logic:                                       │ │
│  │ • Flatten style inheritance → ResolvedStyle (temp)     │ │
│  │ • Merge node-level + style-level properties           │ │
│  │ • Arithmetic: base.padding + style.padding            │ │
│  │ • Apply defaults: backgroundColor ?? .clear            │ │
│  │ • Create canonical values: EdgeInsets(t,l,b,r)        │ │
│  └────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
                            │
                            │ IR initializers
                            │ IR.EdgeInsets(from:merging:)
                            ▼
┌──────────────────────────────────────────────────────────────┐
│                       Layer 3: IR                             │
│                   (Stable, Flat, Resolved)                    │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Fully resolved nodes with flattened properties:        │ │
│  │ • node.padding (IR.EdgeInsets) - final value          │ │
│  │ • node.backgroundColor (Color) - non-optional          │ │
│  │ • node.cornerRadius (CGFloat) - final value            │ │
│  │ • node.shadow (IR.Shadow?) - optional only if absent   │ │
│  │ • NO nested .style objects                             │ │
│  │ • NO optional properties requiring defaults            │ │
│  └────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
                            │
                            │ Renderer protocol
                            │ .render(_ tree: RenderTree) → Output
                            ▼
┌──────────────────────────────────────────────────────────────┐
│                      Layer 4: Renderers                       │
│                   (IR → Platform Output)                      │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Simple transformation:                                  │ │
│  │ • Read properties: node.backgroundColor                │ │
│  │ • Convert types: .swiftUI, .uiColor, .cssRGBA         │ │
│  │ • Create views: Text(...), UILabel(), <div>           │ │
│  │ • NO arithmetic, NO nil coalescing, NO resolution      │ │
│  └────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

## The Five Core IR Rules

The IR layer is the **most stable layer** in the architecture. Follow these rules strictly:

### 1. IR Must Be Fully Resolved
- All properties have their final, computed values
- No arithmetic operations needed at render time
- No optional properties requiring default values in renderers

### 2. IR Must Be Flat
- No nested `.style` objects or similar structures
- All properties directly on nodes (e.g., `node.backgroundColor`, not `node.style.backgroundColor`)
- Each node type declares exactly the properties it uses

### 3. IR Must Be Canonical
- Multiple Document representations resolve to single IR form
- Example: `Document.Padding` can have `horizontal`, `vertical`, `top`, `leading`, etc.
- IR always has: `IR.EdgeInsets(top, leading, bottom, trailing)` - one canonical representation

### 4. IR Must Be Platform-Agnostic
- Never import SwiftUI, UIKit, or AppKit in IR layer
- Platform conversions happen in renderers (e.g., `.swiftUI`, `.uiColor` extensions)

### 5. IR Nodes Must Have Explicit Properties
- Each node type (ContainerNode, TextNode, etc.) declares its own properties
- No shared IR.Style object - properties are duplicated across node types as needed
- This makes it impossible to forget resolving a property

## Layer 1: Document (JSON Representation)

**Purpose**: Represent the raw JSON schema types, preserving all input formats.

### Rules

| Rule | Description | Example |
|------|-------------|---------|
| **Multiple representations** | Allow multiple ways to express the same concept | `horizontal` vs `leading`+`trailing` |
| **String references** | Style IDs, action IDs, data source IDs as strings | `styleId: "button-primary"` |
| **Pure data structures** | No business logic, no dependencies on other layers | Just `struct` with `Codable` |
| **NO IR imports** | Never import or depend on IR types | ❌ `import IR` |
| **NO resolution logic** | Don't resolve, merge, or calculate values | ❌ `var resolvedPadding` |

### Document Type Examples

```swift
// Document.Padding - Multiple representations
public struct Padding: Codable {
    public let all: CGFloat?
    public let horizontal: CGFloat?
    public let vertical: CGFloat?
    public let top: CGFloat?
    public let bottom: CGFloat?
    public let leading: CGFloat?
    public let trailing: CGFloat?

    // Computed properties for internal resolution (simple logic only)
    var resolvedTop: CGFloat { top ?? vertical ?? all ?? 0 }
    var resolvedBottom: CGFloat { bottom ?? vertical ?? all ?? 0 }
    var resolvedLeading: CGFloat { leading ?? horizontal ?? all ?? 0 }
    var resolvedTrailing: CGFloat { trailing ?? horizontal ?? all ?? 0 }
}

// Document.Style - References and properties
public struct Style: Codable {
    public let id: String?
    public let inherits: String?  // Style ID to inherit from
    public let backgroundColor: String?  // Hex color
    public let cornerRadius: CGFloat?
    public let paddingTop: CGFloat?
    public let paddingBottom: CGFloat?
    // ... more properties
}
```

### File Locations

```
SCALS/Document/
├── Document.swift         # Document namespace
├── Component.swift        # Document.Component
├── LayoutNode.swift       # Document.Layout, Document.LayoutNode
├── Style.swift            # Document.Style
├── IRConversions.swift    # IRConvertible protocol conformances
└── ...
```

## Layer 2: Resolution (Document → IR Conversion)

**Purpose**: Transform Document types to IR types, performing all resolution logic.

### Rules

| Rule | Description | Example |
|------|-------------|---------|
| **Use IRConvertible** | For simple Document→IR conversions | `padding.toIR()` |
| **Use IR initializers** | For complex merging/resolution | `IR.EdgeInsets(from:mergingTop:...)` |
| **Arithmetic here** | All calculations happen in this layer | `base.top + styleTop` |
| **Apply defaults here** | Nil coalescing and fallback values | `backgroundColor ?? .clear` |
| **ResolvedStyle is temporary** | Used during resolution, not stored in IR | `let resolved = styleResolver.resolve(...)` |
| **Flatten inheritance** | Style inheritance resolved to single values | `parentStyle.merge(childStyle)` |

### Conversion Patterns

#### Pattern 1: Simple Conversion (IRConvertible)

```swift
// In SCALS/Document/IRConversions.swift
extension Document.Padding: IRConvertible {
    public typealias IRType = IR.EdgeInsets

    public func toIR() -> IR.EdgeInsets {
        // Pure conversion: resolve internal representation
        return IR.EdgeInsets(
            top: resolvedTop,
            leading: resolvedLeading,
            bottom: resolvedBottom,
            trailing: resolvedTrailing
        )
    }
}

// Usage:
let edgeInsets = padding.toIR()  // Simple conversion, no merging
```

#### Pattern 2: Resolution with Merging (IR Initializers)

```swift
// In SCALS/IR/IRInitializers.swift
extension IR.EdgeInsets {
    /// Create EdgeInsets from Document.Padding, merging with style padding
    init(
        from padding: Document.Padding?,
        mergingTop: CGFloat = 0,
        mergingBottom: CGFloat = 0,
        mergingLeading: CGFloat = 0,
        mergingTrailing: CGFloat = 0
    ) {
        let base = padding?.toIR() ?? .zero
        self.init(
            top: base.top + mergingTop,        // ✅ Arithmetic in Resolution layer
            leading: base.leading + mergingLeading,
            bottom: base.bottom + mergingBottom,
            trailing: base.trailing + mergingTrailing
        )
    }
}

// Usage in resolver:
let resolvedStyle = styleResolver.resolve(styleId, inline: inlineStyle)
let padding = IR.EdgeInsets(
    from: layout.padding,
    mergingTop: resolvedStyle.paddingTop ?? 0,
    mergingBottom: resolvedStyle.paddingBottom ?? 0,
    mergingLeading: resolvedStyle.paddingLeading ?? 0,
    mergingTrailing: resolvedStyle.paddingTrailing ?? 0
)
```

#### Pattern 3: Style-Only Properties (Failable Initializers)

```swift
// In SCALS/IR/IRInitializers.swift
extension IR.Shadow {
    /// Create Shadow from ResolvedStyle
    /// Returns nil if no shadow properties are defined
    init?(from resolvedStyle: ResolvedStyle) {
        guard resolvedStyle.shadowColor != nil ||
              resolvedStyle.shadowRadius != nil else {
            return nil
        }

        self.init(
            color: resolvedStyle.shadowColor ?? .clear,
            radius: resolvedStyle.shadowRadius ?? 0,
            x: resolvedStyle.shadowX ?? 0,
            y: resolvedStyle.shadowY ?? 0
        )
    }
}

// Usage:
let shadow = IR.Shadow(from: resolvedStyle)  // nil if no shadow defined
```

### ResolvedStyle: Temporary Artifact

**IMPORTANT**: `ResolvedStyle` exists ONLY during Document→IR conversion. It is **NOT** part of the IR tree.

```swift
// In SCALS/IR/Resolution/ResolvedStyle.swift
public struct ResolvedStyle {
    // Flattened, resolved style properties from inheritance chain
    public var backgroundColor: Color?
    public var cornerRadius: CGFloat?
    public var paddingTop: CGFloat?
    public var paddingBottom: CGFloat?
    public var paddingLeading: CGFloat?
    public var paddingTrailing: CGFloat?
    public var shadowColor: Color?
    public var shadowRadius: CGFloat?
    // ... etc

    // Note: This type is used ONLY during resolution
    // Properties are extracted and placed on IR nodes
}

// StyleResolver returns ResolvedStyle (not IR.Style)
public class StyleResolver {
    public func resolve(_ styleId: String?, inline: Document.Style?) -> ResolvedStyle {
        // Flatten style inheritance
        // Return temporary ResolvedStyle
    }
}
```

### Resolution Flow

```swift
// In LayoutResolver.resolveLayout()

// 1. Resolve style (temporary ResolvedStyle created)
let resolvedStyle = context.styleResolver.resolve(layout.styleId, inline: layout.style)

// 2. Extract and merge properties (arithmetic happens here)
let padding = IR.EdgeInsets(
    from: layout.padding,
    mergingTop: resolvedStyle.paddingTop ?? 0,
    mergingBottom: resolvedStyle.paddingBottom ?? 0,
    mergingLeading: resolvedStyle.paddingLeading ?? 0,
    mergingTrailing: resolvedStyle.paddingTrailing ?? 0
)

let backgroundColor = resolvedStyle.backgroundColor ?? .clear
let cornerRadius = resolvedStyle.cornerRadius ?? 0
let shadow = IR.Shadow(from: resolvedStyle)  // failable init
let border = IR.Border(from: resolvedStyle)  // failable init

// 3. Create IR node with flattened properties (ResolvedStyle discarded)
let node = ContainerNode(
    id: layout.id,
    padding: padding,                // ✅ Fully resolved
    children: resolvedChildren,
    backgroundColor: backgroundColor, // ✅ Non-optional
    cornerRadius: cornerRadius,      // ✅ Final value
    shadow: shadow,                  // ✅ Optional only if absent
    border: border,
    width: resolvedStyle.width,
    height: resolvedStyle.height
    // NO .style property ✅
)

// ResolvedStyle is now out of scope, not stored in IR
```

### File Locations

```
SCALS/IR/
├── DocumentIRConversion.swift    # IRConvertible protocol
├── IRInitializers.swift          # IR initializers with resolution logic
└── Resolution/
    ├── ResolvedStyle.swift       # Temporary resolution artifact
    ├── StyleResolver.swift       # Returns ResolvedStyle
    ├── LayoutResolver.swift      # Uses IR initializers for merging
    └── ...
```

## Layer 3: IR (Stable, Flat, Resolved)

**Purpose**: Fully resolved, canonical, platform-agnostic representation ready for rendering.

### Rules

| Rule | Description | Violation Example |
|------|-------------|-------------------|
| **All properties resolved** | Final values, no computation needed | ❌ `padding + stylePadding` |
| **Flat structure** | No nested `.style` objects | ❌ `node.style.backgroundColor` |
| **Non-optional where possible** | Use defaults during resolution | ❌ `backgroundColor: Color?` |
| **Platform-agnostic** | No SwiftUI/UIKit imports | ❌ `import SwiftUI` |
| **Explicit properties per node** | Each node declares its properties | ✅ `ContainerNode` has `backgroundColor` |
| **Canonical representation** | One way to represent each concept | ✅ Always `EdgeInsets(t,l,b,r)` |

### IR Node Examples

```swift
// ContainerNode - Flattened properties
public struct ContainerNode {
    public let id: String
    public let type: LayoutType  // .vstack, .hstack, .zstack
    public let spacing: CGFloat
    public let alignment: IR.Alignment
    public let padding: IR.EdgeInsets      // ✅ Fully resolved (node + style merged)
    public let children: [RenderNode]

    // Flattened style properties (NO .style field)
    public let backgroundColor: Color      // ✅ Non-optional
    public let cornerRadius: CGFloat       // ✅ Final value
    public let shadow: IR.Shadow?          // ✅ Optional only when truly absent
    public let border: IR.Border?          // ✅ Optional only when truly absent
    public let width: IR.DimensionValue?
    public let height: IR.DimensionValue?
    // ... other container-specific properties
}

// TextNode - Flattened text properties
public struct TextNode {
    public let id: String
    public let content: String
    public let padding: IR.EdgeInsets      // ✅ Fully resolved

    // Flattened text style properties
    public let textColor: Color            // ✅ Non-optional
    public let fontSize: CGFloat           // ✅ Final value
    public let fontWeight: IR.FontWeight   // ✅ Non-optional enum
    public let textAlignment: IR.TextAlignment  // ✅ Non-optional enum
    public let backgroundColor: Color      // ✅ Non-optional
    // ... other text-specific properties
}

// ButtonNode - Flattened button properties
public struct ButtonNode {
    public let id: String
    public let label: String
    public let onTap: String?              // Action ID
    public let padding: IR.EdgeInsets      // ✅ Fully resolved

    // Flattened button style properties
    public let backgroundColor: Color      // ✅ Non-optional
    public let textColor: Color            // ✅ Non-optional
    public let fontSize: CGFloat           // ✅ Final value
    public let cornerRadius: CGFloat       // ✅ Final value
    public let border: IR.Border?          // ✅ Optional only when absent
    // ... other button-specific properties
}
```

### IR Value Types

Platform-agnostic value types with conversion extensions:

```swift
// IR.Shadow - Combined shadow properties
public struct Shadow: Equatable, Sendable {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
}

// IR.Border - Combined border properties
public struct Border: Equatable, Sendable {
    public let color: Color
    public let width: CGFloat
}

// IR.EdgeInsets - Canonical padding representation
public struct EdgeInsets: Equatable, Sendable {
    public let top: CGFloat
    public let leading: CGFloat
    public let bottom: CGFloat
    public let trailing: CGFloat

    public static let zero = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
}
```

### File Locations

```
SCALS/IR/
├── IR.swift              # IR namespace, value types (Shadow, Border, EdgeInsets, etc.)
├── RenderTree.swift      # RenderTree, RenderNode enum, node types with flattened properties
└── ...
```

## Layer 4: Renderers (IR → Platform Output)

**Purpose**: Transform IR to platform-specific UI (SwiftUI, UIKit, HTML).

### Rules

| Rule | Description | Example |
|------|-------------|---------|
| **Direct property access** | Read properties from nodes | ✅ `node.backgroundColor` |
| **Type conversions only** | Use `.swiftUI`, `.uiColor`, `.cssRGBA` | ✅ `.swiftUI` extension |
| **NO arithmetic** | All calculations done in Resolution | ❌ `node.padding + extra` |
| **NO nil coalescing** | Properties already have defaults | ❌ `node.backgroundColor ?? .clear` |
| **NO resolution logic** | Just transform and render | ❌ `merge(node, style)` |
| **Check optionals with if-let** | For truly optional properties | ✅ `if let shadow = node.shadow` |

### Renderer Examples

#### SwiftUI Renderer

```swift
// Simple, declarative rendering
case .container(let container):
    contentView
        .padding(container.padding.swiftUI)            // ✅ Direct access
        .background(container.backgroundColor.swiftUI) // ✅ No nil coalescing
        .cornerRadius(container.cornerRadius)          // ✅ Just read value

    // Optional properties checked with if-let
    if let shadow = container.shadow {
        contentView.shadow(
            color: shadow.color.swiftUI,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }

    if let border = container.border {
        contentView.overlay(
            RoundedRectangle(cornerRadius: container.cornerRadius)
                .stroke(border.color.swiftUI, lineWidth: border.width)
        )
    }

case .text(let text):
    Text(text.content)
        .foregroundColor(text.textColor.swiftUI)       // ✅ Direct access
        .font(.system(size: text.fontSize, weight: text.fontWeight.swiftUI))
        .multilineTextAlignment(text.textAlignment.swiftUI)
        .padding(text.padding.swiftUI)
        .background(text.backgroundColor.swiftUI)
```

#### UIKit Renderer

```swift
// Equally simple
case .text(let text):
    let label = UILabel()
    label.text = text.content
    label.textColor = text.textColor.uiColor          // ✅ Direct access
    label.font = .systemFont(
        ofSize: text.fontSize,
        weight: text.fontWeight.uiKit
    )
    label.textAlignment = text.textAlignment.uiKit
    return label

case .container(let container):
    let view = containerView

    // Apply padding (already resolved)
    if container.padding != .zero {
        view = wrapWithPadding(view, padding: container.padding)
    }

    // Background color (no nil check needed)
    view.backgroundColor = container.backgroundColor.uiColor

    // Corner radius
    view.layer.cornerRadius = container.cornerRadius
    if container.cornerRadius > 0 {
        view.clipsToBounds = true
    }

    // Optional shadow
    if let shadow = container.shadow {
        view.layer.shadowColor = shadow.color.uiColor.cgColor
        view.layer.shadowRadius = shadow.radius
        view.layer.shadowOffset = CGSize(width: shadow.x, height: shadow.y)
        view.layer.shadowOpacity = Float(shadow.color.alpha)
    }
```

### Platform Conversion Extensions

```swift
// In ScalsModules/SwiftUI/IRTypeConversions.swift
extension IR.Color {
    public var swiftUI: SwiftUI.Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}

extension IR.EdgeInsets {
    public var swiftUI: SwiftUI.EdgeInsets {
        EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
}

// In ScalsModules/UIKitRenderers/IRTypeConversions.swift
extension IR.Color {
    public var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
```

### File Locations

```
ScalsModules/
├── SwiftUI/
│   ├── SwiftUIRenderer.swift
│   ├── StyleModifiers.swift       # Conversion extensions
│   └── ...
├── SwiftUIRenderers/
│   ├── ContainerNodeView.swift
│   ├── TextNodeView.swift
│   └── ...
├── UIKitRenderers/
│   ├── UIKitRenderer.swift
│   ├── ContainerNodeRenderer.swift
│   ├── TextNodeRenderer.swift
│   └── ...
└── HTMLRenderers/
    ├── HTMLRenderer.swift
    ├── CSSGenerator.swift
    └── ...
```

## Anti-Patterns and Violations

### ❌ Arithmetic in Renderers

```swift
// WRONG - Don't do this
.padding(.top, node.padding.top + (node.style.paddingTop ?? 0))

// WHY: Resolution logic in renderer, not IR layer
// FIX: Resolve during Document→IR conversion
```

### ❌ Nil Coalescing in Renderers

```swift
// WRONG - Don't do this
.background(node.style.backgroundColor ?? .clear)

// WHY: Default application in renderer, should be in Resolution
// FIX: Apply default during resolution, store non-optional on node
```

### ❌ Nested .style Objects in IR

```swift
// WRONG - Don't do this
public struct ContainerNode {
    public let style: IR.Style  // ❌ NO nested objects
}

// WHY: Violates "IR Must Be Flat" rule
// FIX: Flatten properties directly on node
```

### ❌ Document Types Depending on IR

```swift
// WRONG - Don't do this
extension Document.Padding {
    func resolved(with style: IR.Style) -> IR.EdgeInsets { ... }
}

// WHY: Creates circular dependency, violates layer boundaries
// FIX: Use IRConvertible protocol and IR initializers
```

### ❌ ResolvedStyle Stored in IR Tree

```swift
// WRONG - Don't do this
public struct ContainerNode {
    public let resolvedStyle: ResolvedStyle  // ❌ Temporary artifact
}

// WHY: ResolvedStyle is for resolution only, not IR storage
// FIX: Extract properties from ResolvedStyle, place on node
```

## Code Review Checklist

When reviewing code or your own changes, check:

- [ ] **No arithmetic in renderers** - All calculations done in Resolution layer
- [ ] **No nil coalescing in renderers** - Properties resolved to non-optional when possible
- [ ] **IR nodes have no `.style` field** - All properties directly on nodes
- [ ] **Document types don't import/depend on IR** - Use protocols for conversion
- [ ] **Resolution logic in IR initializers** - Not in Document extensions
- [ ] **IR types are platform-agnostic** - No SwiftUI/UIKit imports in IR layer
- [ ] **Properties fully resolved** - IR has final values, not partial data
- [ ] **Canonical representation** - One way to represent each property in IR
- [ ] **ResolvedStyle is temporary** - Not stored in IR tree
- [ ] **Each node has explicit properties** - No shared style objects

## Quick Reference: Where Does Logic Go?

| Task | Correct Layer | Incorrect Layer |
|------|--------------|----------------|
| Parse JSON | Document | ❌ IR |
| Resolve `horizontal` → `leading`/`trailing` | Document (internal) or Resolution | ❌ Renderer |
| Merge node.padding + style.padding | Resolution | ❌ Renderer |
| Combine shadowColor + shadowRadius | Resolution | ❌ Renderer |
| Apply defaults (e.g., `.clear` for backgroundColor) | Resolution | ❌ Renderer |
| Flatten style inheritance | Resolution | ❌ Document or Renderer |
| Convert `IR.Color` → `SwiftUI.Color` | Renderer | ❌ Resolution |
| Create `UIView` from `IR.ContainerNode` | Renderer | ❌ IR |
| Add HTML attributes for accessibility | Renderer | ❌ IR |
| Arithmetic operations (padding + style) | Resolution | ❌ Document or Renderer |

## Summary

The three-layer architecture ensures:

1. **Document Layer**: Clean JSON representation with multiple input formats
2. **Resolution Layer**: All complex logic, merging, arithmetic, defaults application
3. **IR Layer**: Stable, flat, fully-resolved, platform-agnostic intermediate representation
4. **Renderer Layer**: Simple transformation to platform-specific UI

**Remember**: The IR layer is the most stable layer. Keep it flat, fully resolved, and platform-agnostic.
