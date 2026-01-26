# Dynamic Bottom Sheet Sizing Implementation

## Overview

Implemented dynamic bottom sheet sizing for ScalsRendererView that allows sheets to automatically adjust their height based on rendered content. This solves issues where fixed detents (`.medium`, `.large`) don't properly accommodate variable content sizes.

## Implementation Components

### 1. Size Measurement Infrastructure

**File:** `SCALS/Rendering/ScalsRendererSizing.swift`

Created a size measurement system using the standard SwiftUI GeometryReader + PreferenceKey pattern:

- `SizeMeasuringModifier`: ViewModifier that measures view size as it's laid out
- `SizePreferenceKey`: PreferenceKey for propagating size measurements up the view hierarchy
- `measuringSize(_:)` extension on `View`: Public API for measuring any view's size

**Why GeometryReader?**
- Measures actual allocated size after layout constraints are applied
- Handles text wrapping and width-dependent layout correctly
- Bottom sheets propose a specific width, and we need height given that width
- Standard SwiftUI approach for this use case

### 2. ScalsRendererView Extension

**File:** `SCALS/Rendering/ScalsRendererView.swift` (lines 431-472)

Added convenience method and supporting types:

```swift
extension ScalsRendererView {
    public func measuringSize(_ size: Binding<CGSize>) -> some View
}
```

This allows ScalsRendererView to report its size for dynamic sheet sizing.

### 3. Presentation System Updates

**File:** `ScalsExamples/ScalsExamplesView.swift`

#### Added Dynamic Height Support

1. **New DetentOption enum** (lines 14-18):
   - `.medium`: Standard medium detent
   - `.large`: Standard large detent
   - `.dynamic`: Dynamic height based on content

2. **State management** (lines 25-26):
   - `@State private var measuredSheetSize: CGSize = .zero`
   - `@AppStorage("selectedDetent") private var selectedDetent: String`
   - Persists user's detent preference between app launches

3. **PresentationStyle enum update** (line 289):
   - Added `.dynamicHeight` case

4. **PresentationStyleModifier enhancement** (lines 873-879):
   - Handles `.dynamicHeight` case
   - Applies `.measuringSize()` to content
   - Uses `.presentationDetents([.height(measuredSize.height + 20)])`
   - Adds 20pt padding buffer for visual spacing

5. **Detent selection menu** (lines 267-285 in ExampleRow):
   - Context menu with "Detent" submenu
   - Shows Medium, Large, Dynamic options
   - Checkmark indicates current selection
   - Persisted via @AppStorage

6. **Helper method** (lines 31-50):
   - `effectivePresentationStyle(for:)` determines which style to use
   - Respects user's detent preference
   - Full screen presentations unchanged

## How to Use

### For End Users (ScalsExamples App)

1. Long-press any example in the list
2. Select "Detent" from context menu
3. Choose your preferred mode:
   - **Medium**: Standard medium sheet height
   - **Large**: Full sheet height
   - **Dynamic**: Auto-sized to content

The selection persists between app launches.

### For Developers

#### Measuring Any View

```swift
@State private var viewSize: CGSize = .zero

SomeView()
    .measuringSize($viewSize)
```

#### Dynamic Sheet Height

```swift
@State private var contentSize: CGSize = .zero

.sheet(isPresented: $showSheet) {
    ScalsRendererView(document: document)
        .measuringSize($contentSize)
        .presentationDetents([.height(contentSize.height + 20)])
}
```

## Testing Recommendations

1. **Various Content Sizes**: Test examples with different content amounts
2. **Text Wrapping**: Verify text-heavy content measures correctly
3. **State Changes**: Test content that dynamically changes size
4. **Device Sizes**: Test on different device sizes (iPhone SE to Pro Max)
5. **Orientation**: Test portrait and landscape (if supported)
6. **Persistence**: Verify detent selection persists after app restart

### Suggested Test Cases

- **Images Example**: Set to dynamic, verify image fills full width
- **Text Examples**: Long text should wrap and measure correctly
- **Grid Layouts**: Complex layouts should measure accurately
- **State-Driven Content**: Toggle content and verify sheet adjusts

## Architecture Notes

### Why Not Custom Layout?

The plan initially suggested using a custom Layout with `.unspecified` proposal. We used GeometryReader instead because:

1. **Width Constraints Matter**: Bottom sheets propose specific width (screen width minus margins)
2. **Text Wrapping**: Text doesn't have fixed intrinsic size - needs width to determine height
3. **Actual Rendered Size**: We need size after all layout decisions, not ideal size in unlimited space
4. **Standard Pattern**: GeometryReader + PreferenceKey is the established SwiftUI approach

### Performance Considerations

- Size measurement happens during normal layout pass (no extra overhead)
- State updates are async on main queue to avoid blocking layout
- Measurement is opt-in (only applied when using `.measuringSize()`)

## Files Modified

1. **SCALS/Rendering/ScalsRendererSizing.swift** - NEW
   - Size measurement infrastructure

2. **SCALS/Rendering/ScalsRendererView.swift** - MODIFIED
   - Added size measurement extension (lines 431-472)

3. **ScalsExamples/ScalsExamplesView.swift** - MODIFIED
   - Added DetentOption enum
   - Added state management
   - Updated PresentationStyle enum
   - Updated PresentationStyleModifier
   - Added detent selection menu
   - Added effectivePresentationStyle helper

## Build Status

✅ SCALS framework builds successfully
✅ ScalsExamples app builds successfully
✅ New file automatically included in build
✅ No breaking changes to existing API

## Future Enhancements

1. **Per-Example Detent Memory**: Store detent preference per example
2. **Animation Support**: Smooth transitions when content size changes
3. **Min/Max Constraints**: Add optional height bounds for dynamic mode
4. **Detent Combinations**: Support multiple detents simultaneously (e.g., dynamic + large)
5. **Debug Overlay**: Optional size indicator for development
