# Failing Tests

## Summary
No failing tests at this time. All implemented tests are passing.

---

## How to Use This Document

This document tracks tests that fail after reasonable debugging attempts (3+ iterations). For each failing test, document:

1. **Test Name**: Full test identifier
2. **Renderers Affected**: Which renderers fail (SwiftUI, UIKit, HTML)
3. **Failure Description**: What's wrong
4. **Expected vs Actual**: Visual description or diff
5. **Root Cause**: Known or suspected cause
6. **Attempts Made**: What fixes were tried
7. **Blocked By**: Dependencies or issues blocking resolution
8. **Workaround**: Temporary skip or tolerance adjustment
9. **Priority**: P0 (critical), P1 (important), P2 (nice to have)

---

## Example Entry Format

### testButtonWithHoverState
**Renderers Affected**: HTML
**Failure Description**: Button hover state not captured in snapshot
**Expected**: Button should show hover styling
**Actual**: Button shows normal state
**Root Cause**: WKWebView doesn't support simulated hover events
**Attempts Made**:
- Tried injecting hover CSS class
- Tried JavaScript to trigger :hover
- Tried webkit touch events
**Blocked By**: WKWebView limitations with pseudo-classes
**Workaround**: Skip HTML hover tests, document limitation
**Priority**: P2 (hover states are less critical for mobile)
**Status**: ❌ Skipped

---

## Active Failures

_No active failures_

---

## Resolved Failures

### testTextWithBasicStyle - Text Alignment Inconsistency
**Date Resolved**: 2026-01-28
**Renderers Affected**: UIKit, HTML
**Issue**: Text positioned flush to top in UIKit/HTML while SwiftUI had natural spacing
**Resolution**: Added 2pt top padding to UIKit TextNodeRenderer and HTML CSSGenerator to match SwiftUI's natural text spacing. Established SwiftUI as canonical reference.
