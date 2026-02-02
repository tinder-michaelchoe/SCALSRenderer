# SCALS IR Schema Changelog

All notable changes to the SCALS IR (Intermediate Representation) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Important**: IR changes are intentionally rare. Breaking changes require ecosystem-wide coordination and affect ALL renderers (SwiftUI, UIKit, HTML, etc.).

---

## [Unreleased]

### Added
- `irVersion` property on `RenderTree` for version tracking

---

## [0.1.0] - 2025-02-01

### Initial IR

#### Node Types
- `ContainerNode` - Container with fully resolved layout and styling
- `TextNode` - Text with resolved font, color, alignment
- `ButtonNode` - Interactive button with resolved styling
- `ImageNode` - Image with resolved source and styling
- `TextFieldNode` - Text input with resolved configuration
- `ToggleNode` - Toggle with resolved binding and styling
- `SpacerNode` - Resolved spacing
- `DividerNode` - Resolved separator
- `GradientNode` - Resolved gradient rendering
- `ShapeNode` - Resolved shape with fill/stroke
- `SliderNode` - Resolved slider configuration
- `PageIndicatorNode` - Resolved page indicator
- `SectionLayoutNode` - Resolved section layout
- `CustomNode` - Extension point for custom components

#### Core Types
- `EdgeInsets` - Padding/margin with top, leading, bottom, trailing
- `Color` - Platform-agnostic color (hex with alpha)
- `Border` - Border with width, color, style
- `Shadow` - Shadow with color, radius, offset
- `Size` - Width/height dimensions

#### Principles
All IR nodes follow these principles:
- **Fully resolved** - No arithmetic operations needed at render time
- **Flat structure** - No nested `.style` objects, all properties directly on nodes
- **Canonical representation** - One way to express each property
- **Platform-agnostic** - No SwiftUI/UIKit imports in IR layer

---

## Breaking Change Guidelines

**Breaking changes (require major version bump):**
- Changing property names (e.g., `backgroundColor` → `bgColor`)
- Changing property types (e.g., `padding: EdgeInsets` → `padding: [CGFloat]`)
- Removing properties
- Changing enum case names
- Changing required vs optional

**Safe changes (minor version bump):**
- Adding NEW optional properties
- Adding NEW node types (with fallback strategy)
- Adding NEW enum cases (with fallback)

---

## Notes

The IR is the **stability layer** between the Resolution layer and Renderers. It should be as stable as LLVM IR - frontends (JSON parsers, visual editors) can evolve independently from backends (SwiftUI, UIKit, HTML renderers) as long as the IR remains stable.

For user-facing JSON API changes, see `CHANGELOG-DOCUMENT.md`.
