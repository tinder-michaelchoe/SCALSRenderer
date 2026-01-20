# CladsTools - Quick Start Guide

Get up and running with CladsTools in 5 minutes

---

## Setup

```bash
cd CladsTools
swift build
```

---

## Your First Command

```bash
# Check framework consistency
swift run clads-consistency-checker --framework-path ..
```

**Expected output**:
```
============================================================
CLADS Component Consistency Checker
============================================================

ℹ️  Analyzing framework at: /path/to/CladsRenderer

--- Checking Component Resolvers ---
ℹ️  Found 8 resolver files
⚠️  Found 16 issue(s)
```

**Note**: Current issues are false positives. See `CONSISTENCY_REPORT.md`

---

## Common Tasks

### Check What Components Exist

```bash
ls ../CladsModules/ComponentResolvers/
```

Output:
- TextComponentResolver.swift
- ButtonComponentResolver.swift
- ImageComponentResolver.swift
- TextFieldComponentResolver.swift
- ToggleComponentResolver.swift
- SliderComponentResolver.swift
- GradientComponentResolver.swift
- DividerComponentResolver.swift

### Verbose Mode

```bash
swift run clads-consistency-checker --framework-path .. --verbose
```

Shows detailed analysis for each component

---

## Available Tools

Currently implemented:

1. **clads-consistency-checker** - Validate framework consistency
2-12. Other tools - Stubs only (coming soon)

List all:
```bash
ls .build/debug/clads-*
```

---

## Next Steps

### For Users
- Read `README.md` for tool descriptions
- Check `docs/LLM_USAGE_GUIDE.md` for integration with AI assistants

### For Developers
- Read `docs/MAINTAINER_GUIDE.md` for development guide
- Check `Package.swift` for tool structure
- Explore `Sources/CladsToolsCore/` for utilities

---

## Getting Help

```bash
# Show help for any tool
swift run clads-consistency-checker --help
```

Output:
```
USAGE: clads-consistency-checker [--framework-path <framework-path>] [--verbose]

OPTIONS:
  --framework-path <framework-path>
                          Path to the CLADS framework directory (default: ..)
  --verbose               Show verbose output
  -h, --help              Show help information.
```

---

## Troubleshooting

### Build Errors

```bash
swift package clean
swift package resolve
swift build
```

### Tool Not Found

Make sure you're in CladsTools directory:
```bash
cd CladsTools
pwd  # Should show: .../CladsRenderer/CladsTools
```

---

That's it! You're ready to use CladsTools. 🎉
