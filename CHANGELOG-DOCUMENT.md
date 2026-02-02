# SCALS Document Schema Changelog

All notable changes to the SCALS Document schema will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**Note**: This changelog tracks the user-facing JSON API. For IR changes, see `CHANGELOG-IR.md`.

---

## [Unreleased]

### Added
- `version` field for documents to declare schema version
- `requirements` section for capability declaration (planned)
- `fallback` property on components (planned)

---

## [0.1.0] - 2025-02-01

### Initial Release

#### Core Components
- `container` - Layout container with padding, margin, background, border, shadow
- `text` - Text display with font, color, alignment, line limits
- `button` - Interactive button with tap handler
- `image` - Image display with URL, aspect ratio, content mode
- `textField` - Text input field with placeholder, binding, keyboard type
- `toggle` - Boolean toggle switch with binding
- `spacer` - Flexible spacing with min length
- `divider` - Visual separator with color and thickness
- `gradient` - Linear/radial gradient backgrounds
- `shape` - Basic shapes (rectangle, circle, rounded rectangle)
- `slider` - Numeric slider input with range
- `pageIndicator` - Page indicator dots

#### Layout Types
- `hStack` - Horizontal layout with spacing and alignment
- `vStack` - Vertical layout with spacing and alignment
- `zStack` - Layered layout with alignment
- `scrollView` - Scrollable container
- `forEach` - Data-driven repetition
- `sectionLayout` - Section-based layouts (list, grid, carousel, pager)

#### Actions
- `dismiss` - Dismiss current view
- `setState` - Set state value at path
- `toggleState` - Toggle boolean state
- `showAlert` - Display alert dialog
- `navigate` - Navigate to destination
- `sequence` - Execute actions in sequence
- `custom` - Custom action handlers (plugin)

#### Features
- State management with type-safe bindings
- Named styles with inheritance (`styleId`, `extends`)
- Data sources for dynamic content
- Design system integration (`designSystem` field)
- Expression evaluation (`{{state.value}}`)
- Lifecycle actions (`onAppear`, `onDisappear`)
- Accessibility properties
- Custom components via plugins
