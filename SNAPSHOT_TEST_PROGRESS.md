# Snapshot Test Progress

## Phase 1: Foundation ✅ COMPLETE

**Branch**: `snapshot-testing-phase-1`
**Completed**: 2026-01-28

### Deliverables
- ✅ Added swift-snapshot-testing package
- ✅ Created test directory structure (ScalsModulesTests/SnapshotTests/)
- ✅ Implemented StandardSnapshotSizes helper
- ✅ Implemented RendererTestHelpers with:
  - `renderSwiftUI()` - SwiftUI rendering with window-based capture
  - `renderUIKit()` - UIKit rendering
  - `renderHTML()` - HTML rendering via WKWebView
  - `renderCanonicalView()` - Canonical SwiftUI reference rendering
- ✅ Created custom SnapshotAssertions helper for external snapshot directory
- ✅ Configured external snapshot directory: `/Users/michael.choe/Desktop/PROGRAMMING/ScalsRenderer-Snapshots/__Snapshots__/`
- ✅ Created TextNodeSnapshotTests.swift with passing tests:
  - `testTextWithBasicStyle()` - Tests all 3 renderers (SwiftUI, UIKit, HTML)
  - `testTextWithCanonicalComparison()` - Validates SCALS vs canonical SwiftUI
- ✅ Fixed text alignment consistency across all renderers
  - SwiftUI is canonical reference with natural text spacing (~2pt)
  - UIKit and HTML modified to match SwiftUI's spacing
- ✅ All tests passing with record mode off

### Key Learnings
1. **Window-based rendering required**: SwiftUI views need proper window hierarchy to render correctly (not just UIHostingController)
2. **SwiftUI is canonical**: Other renderers must match SwiftUI's natural spacing and behavior
3. **External snapshots**: Using custom `assertSnapshot()` wrapper with `verifySnapshot()` for external directory
4. **Text spacing**: SwiftUI has ~2pt natural top spacing that UIKit/HTML must replicate

---

## Phase 2: Core Components 🚧 IN PROGRESS

**Branch**: `snapshot-testing-phase-1` (continuing)
**Started**: 2026-01-28

### Plan
Expand TextNode tests with more variants, then move to other core components (Button, Image, Container layouts).

### TextNode Tests
- ✅ testTextWithBasicStyle (SwiftUI, UIKit, HTML)
- ✅ testTextWithCanonicalComparison
- ✅ testTextWithColorSchemes (light/dark mode)
- ✅ testTextWithFontWeights (regular, medium, semibold, bold)
- ✅ testTextWithFontSizes (12pt, 16pt, 24pt, 32pt)
- ✅ testTextWithAlignment (leading, center, trailing)
- ✅ testTextWithMultiline
- ✅ testTextWithPadding

### ButtonNode Tests
- ⬜ testButtonWithBasicStyle
- ⬜ testButtonWithStates (normal, disabled, selected)
- ⬜ testButtonWithCustomColors
- ⬜ testButtonWithBorder

### Container Tests
- ⬜ testVStackBasic
- ⬜ testHStackBasic
- ⬜ testZStackBasic
- ⬜ testVStackWithSpacing
- ⬜ testVStackWithAlignment

### Progress
- **Tests Passing**: 8
- **Tests Failing**: 0
- **Components Covered**: TextNode (complete)

---

## Statistics

| Phase | Status | Tests | Components | Completion |
|-------|--------|-------|------------|------------|
| Phase 1 | ✅ Complete | 2/2 | TextNode (basic) | 100% |
| Phase 2 | 🚧 In Progress | 8/20 | TextNode (complete), Button, Containers | 40% |
| Phase 3 | ⬜ Not Started | 0 | Cross-renderer | 0% |
| Phase 4 | ⬜ Not Started | 0 | Examples | 0% |
| Phase 5 | ⬜ Not Started | 0 | Canonical | 0% |

**Overall Progress**: 8 tests passing, 0 tests failing
