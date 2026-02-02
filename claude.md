# Cardinal Rules for AI Assistants

This document contains the most important architectural rules for working on the ScalsRenderer codebase. These rules ensure long-term maintainability and consistency.

## The Golden Rule

**If you find yourself doing arithmetic, nil coalescing, or conditionals in a renderer to determine a final property value, that logic belongs in the Resolution layer, not the Renderer.**

Examples of violations:
```swift
// ❌ BAD - Arithmetic in renderer
.padding(.top, node.padding.top + (node.style.paddingTop ?? 0))

// ❌ BAD - Nil coalescing in renderer
.background(node.style.backgroundColor ?? .clear)

// ❌ BAD - Conditional logic in renderer
if let shadowColor = node.style.shadowColor,
   let shadowRadius = node.style.shadowRadius {
    // combine shadow properties
}
```

Examples of correct approach:
```swift
// ✅ GOOD - Direct property access
.padding(node.padding.swiftUI)
.background(node.backgroundColor.swiftUI)

// ✅ GOOD - Optional property already resolved
if let shadow = node.shadow {
    .shadow(color: shadow.color.swiftUI, radius: shadow.radius, x: shadow.x, y: shadow.y)
}
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

## Layer Responsibilities

### Layer 1: Document (JSON Representation)
- **What**: Represents the raw JSON schema types
- **Rules**:
  - Multiple ways to express properties (shorthand, specific values)
  - NO dependencies on IR types
  - Pure data structures

### Layer 2: Resolution (Document → IR Conversion)
- **What**: Converts Document types to IR types, performing all resolution logic
- **Rules**:
  - Use `IRConvertible` protocol for simple conversions
  - Use IR initializers for complex merging (e.g., `IR.EdgeInsets(from:mergingTop:...)`)
  - Resolve style inheritance via `ResolvedStyle` (temporary artifact, not stored in IR)
  - Combine multiple sources (node-level + style-level) into single values
  - This is where arithmetic happens: `base.top + styleTop`

### Layer 3: IR (The Stable Layer)
- **What**: Fully resolved, canonical representation ready for rendering
- **Rules**: See "The Five Core IR Rules" above
- **Properties**: Direct on nodes, no nested structures, non-optional where possible

### Layer 4: Renderers (IR → Platform Output)
- **What**: Transform IR to SwiftUI, UIKit, HTML, etc.
- **Rules**:
  - Read properties directly from nodes
  - NO arithmetic: `node.padding`, not `node.padding + something`
  - NO nil coalescing: `node.backgroundColor`, not `node.backgroundColor ?? .clear`
  - NO resolution logic - just transform types (`.swiftUI`, `.uiColor`, `.cssRGBA`)

## Common Anti-Patterns to Avoid

### ❌ Arithmetic in Renderers
```swift
// WRONG - Don't do this
.padding(.top, node.padding.top + node.style.paddingTop ?? 0)
```

### ❌ Nil Coalescing in Renderers
```swift
// WRONG - Don't do this
.background(node.style.backgroundColor ?? .clear)
```

### ❌ IR.Style in Final IR Tree
```swift
// WRONG - Don't do this
public struct ContainerNode {
    public let style: IR.Style  // ❌ NO nested style objects
}
```

### ❌ Document Layer Depending on IR or ResolvedStyle
```swift
// WRONG - Don't do this
extension Document.Padding {
    func resolved(with style: IR.Style) -> IR.EdgeInsets { ... }  // ❌ Coupling to IR
    func resolved(with style: ResolvedStyle) -> IR.EdgeInsets { ... }  // ❌ Coupling to Resolution
}
```

### ❌ Optional Properties Requiring Defaults in Renderers
```swift
// WRONG - Don't do this
public struct ContainerNode {
    public let backgroundColor: Color?  // ❌ Should be non-optional
}
// Renderer forced to: node.backgroundColor ?? .clear
```

## Correct Patterns

### ✅ Protocol-Based Conversion (Document → IR, Simple)
```swift
// In SCALS/Document/IRConversions.swift
extension Document.Padding: IRConvertible {
    public typealias IRType = IR.EdgeInsets

    public func toIR() -> IR.EdgeInsets {
        return IR.EdgeInsets(
            top: resolvedTop,
            leading: resolvedLeading,
            bottom: resolvedBottom,
            trailing: resolvedTrailing
        )
    }
}
```

### ✅ IR Initializer Pattern (Resolution with Merging)
```swift
// In SCALS/IR/IRInitializers.swift
extension IR.EdgeInsets {
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
```

### ✅ Flat IR Node Structure
```swift
// In SCALS/IR/IR.swift
public struct ContainerNode {
    public let id: String
    public let padding: IR.EdgeInsets     // ✅ Fully resolved
    public let backgroundColor: Color      // ✅ Non-optional, direct property
    public let cornerRadius: CGFloat       // ✅ Direct property
    public let shadow: IR.Shadow?          // ✅ Optional only when truly optional
    public let children: [RenderNode]
    // NO .style property ✅
}
```

### ✅ Simple Renderer Logic
```swift
// In SwiftUI renderer
contentView
    .padding(node.padding.swiftUI)              // ✅ Direct access
    .background(node.backgroundColor.swiftUI)   // ✅ No nil coalescing
    .cornerRadius(node.cornerRadius)            // ✅ Just read the value

// Optional properties checked with if-let
if let shadow = node.shadow {
    contentView.shadow(
        color: shadow.color.swiftUI,
        radius: shadow.radius,
        x: shadow.x,
        y: shadow.y
    )
}
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

## Quick Reference: Where Does Logic Go?

| Task | Correct Layer | Incorrect Layer |
|------|--------------|----------------|
| Parse JSON | Document | ❌ IR |
| Resolve `horizontal` → `leading`/`trailing` | Resolution | ❌ Renderer |
| Merge node.padding + style.padding | Resolution | ❌ Renderer |
| Combine shadowColor + shadowRadius | Resolution | ❌ Renderer |
| Apply defaults (e.g., `.clear` for backgroundColor) | Resolution | ❌ Renderer |
| Convert `IR.Color` → `SwiftUI.Color` | Renderer | ❌ Resolution |
| Create `UIView` from `IR.ContainerNode` | Renderer | ❌ IR |
| Add HTML attributes for accessibility | Renderer | ❌ IR |

## Thread Safety in Resolution Layer

The Resolution layer (Document → IR conversion) has been optimized for WebAssembly compatibility:

### ⚠️ Important Discovery: All Resolution Requires MainActor

After attempting to remove `@MainActor` from the resolution layer, we discovered that **component resolution inherently requires MainActor** because:

1. **ViewNode Creation**: All component resolvers create `ViewNode` instances (even without tracking)
2. **DependencyTracker Interaction**: Component resolvers call `context.tracker?.recordRead()` which is `@MainActor`
3. **Shared Resolution Path**: Component resolvers are used by both tracked and non-tracked resolution

**Conclusion**: The entire resolution layer must remain `@MainActor` because it creates view nodes and interacts with the view tree infrastructure.

### What This Means

- **All resolution** (`resolve()` and `resolveWithTracking()`) runs on main thread
- **WebAssembly**: No issues - WebAssembly is single-threaded, so `@MainActor` becomes a no-op
- **iOS/macOS**: Resolution happens on main thread (where it needs to be anyway for ViewNode)

### Thread Safety That Remains

These components are still thread-safe and protected by NSLock:
- **StateStore**: Can be accessed from any thread (protected by NSLock)
- **ResolutionContext**: Immutable during resolution, safe to pass across threads
- **ComponentResolverRegistry**: Uses `@unchecked Sendable` with immutable storage

### Why MainActor Is Required

```swift
// Component resolvers do this:
let viewNode = ViewNode(id: nodeId, nodeType: .button(...))  // ViewNode is a class
context.tracker?.recordRead(path)  // @MainActor method
```

Even when tracking is disabled, `ViewNode` instances are created and passed around. These are reference types that must be on MainActor for thread safety.

### Best Practices

Resolution should always be called from MainActor context:

```swift
// Correct - all resolution is @MainActor
Task { @MainActor in
    let tree = try resolver.resolve()
    updateUI(with: tree)
}

// Or in async MainActor context
func loadDocument() async {
    let tree = try await resolver.resolve()
    // Already on MainActor
}
```

### What Remains @MainActor (Everything in Resolution)

The **entire resolution and rendering pipeline** is `@MainActor`:
- **Resolution layer**: All component resolvers, layout resolvers, section resolvers
- **View tree layer**: `ViewNode`, `ViewTreeUpdater`, `DependencyTracker`
- **Rendering layer**: `CustomComponent`, `ActionHandler`, SwiftUI view code

**Key Principle**: Resolution creates ViewNodes which are part of the view tree infrastructure. The view tree must be on MainActor. Therefore, resolution must be on MainActor.

## For More Details

See the full plan at: `.claude/plans/lovely-growing-stallman.md`

See comprehensive layer documentation at: `Docs/LayerArchitecture.md` (to be created)

---

**Remember**: The IR layer is the most stable layer. Keep it flat, fully resolved, and platform-agnostic.
