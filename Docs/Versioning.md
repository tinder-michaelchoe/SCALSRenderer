# SCALS Versioning System

This document explains the SCALS versioning system, its design rationale, and implementation details.

## Overview

SCALS uses a dual-versioning strategy with two independent version schemes:

1. **Document Schema Version** - The user-facing API for JSON documents
2. **IR Schema Version** - The stability layer between Resolution and Renderers

## Why Two Version Schemes?

### The Problem

When SCALS JSON evolves with new features, older renderers may not be able to handle them. We needed to answer:
- How do old renderers handle new JSON?
- How do we protect renderer investments from breaking changes?
- How do we enable rapid evolution of user-facing features?

### The Solution

**Document Schema** (evolves frequently):
- Represents the user-facing JSON API
- Can add new components, actions, and properties with minor versions
- Changes don't break renderers if Resolution layer handles them

**IR Schema** (extremely stable):
- The contract between Resolution and ALL renderers (SwiftUI, UIKit, HTML, etc.)
- Breaking changes are rare and require major version bumps
- Protects renderer investments - one IR change affects all platforms

This separation follows the LLVM model: frontends (JSON parsers) can evolve independently from backends (renderers) as long as the IR remains stable.

## Version Detection

### Document Version

JSON documents can declare their schema version:

```json
{
  "id": "my-document",
  "version": "0.1.0",
  "root": { ... }
}
```

Access in Swift:
```swift
let document = try Document.Definition(jsonString: json)
if let version = document.version {
    print("Document version: \(version)")
}
```

### IR Version

The `RenderTree` includes the IR version used to create it:

```swift
let tree = try resolver.resolve()
print("IR version: \(tree.irVersion.string)")  // "0.1.0"
```

### Version Constants

```swift
// Current versions
DocumentVersion.current     // Document schema: 0.1.0
DocumentVersion.currentIR   // IR schema: 0.1.0

// Comparison
if document.version == "0.1.0" { ... }
if tree.irVersion >= DocumentVersion(1, 0, 0) { ... }
```

## Capability Discovery vs Minimum Version

### Why We Prefer Explicit Requirements

Instead of just declaring `minimumVersion: "1.5.0"`, we encourage explicit capability requirements (planned feature):

```json
{
  "requirements": {
    "components": ["videoPlayer"],
    "actions": ["biometric"]
  }
}
```

**Benefits:**
- **More precise** - Know exactly what's missing
- **Better fallbacks** - Can provide fallbacks per feature
- **Less constraining** - Document might work on v1.0 if only using basic features

**When to use minimumVersion:**
- Major version checks (v1.x vs v2.x)
- Core behavior dependencies that can't be expressed as component/action requirements

## JSON-Defined Fallbacks (Planned)

### Rationale

We chose to let JSON authors define fallbacks rather than Swift developers because:
1. JSON authors know the context and can provide appropriate alternatives
2. Fallbacks travel with the JSON - no separate configuration needed
3. Different documents can have different fallback strategies

### Component Fallbacks

```json
{
  "type": "videoPlayer",
  "url": "video.mp4",
  "fallback": {
    "type": "image",
    "src": "thumbnail.jpg"
  }
}
```

### Action Fallbacks

```json
{
  "actions": {
    "biometricAuth": {
      "type": "biometric",
      "reason": "Login",
      "fallback": "passwordAuth"
    }
  }
}
```

## Schema File Versioning

### Filename Convention

Schema files include version in filename: `{name}-v{major}.{minor}.{patch}.json`

```
SCALS/Schema/
  scals-document-v0.1.0.json    ← Versioned, immutable
  scals-document-latest.json   ← Symlink to latest
  scals-ir-v0.1.0.json         ← Versioned, immutable
  scals-ir-latest.json         ← Symlink to latest
```

### Immutability

Old schema versions are **immutable** - they are historical records that should never be modified.

**Why?**
- Documents reference specific schema versions
- Breaking immutability breaks reproducibility
- Old schemas serve as API documentation for that version

**Planned protection mechanisms:**
1. Manual review during code review
2. Documentation about immutability
3. Future: `.claudeignore` - Would prevent Claude Code from editing
4. Future: Pre-commit hooks - Would prevent Git commits that modify old schemas
5. Future: Post-commit hooks - Would make files read-only (chmod 444)

See Future Enhancements section below for details on deferred automation.

## Version Comparison Rules

| Document Schema | IR Schema | Compatible? |
|----------------|-----------|-------------|
| 1.0 | 1.0 | ✅ Perfect match |
| 1.5 | 1.0 | ✅ Resolution handles new features |
| 2.0 | 1.0 | ⚠️ Might need IR v1.1 for new nodes |
| 1.0 | 2.0 | ❌ Old documents can't produce new IR |

## Debug Logging

In DEBUG builds, `ScalsRendererView` logs version information:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📄 SCALS Version Info
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Document: v0.1.0
   Renderer: v0.1.0
   IR:       v0.1.0
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

If the document lacks a version field:
```
   Document: ⚠️  No version specified (defaulting to v0.1.0)
```

---

## Future Enhancements

These features were designed but deferred pending team coordination:

### Git Pre-Commit Hooks

**Status**: Deferred - tooling is ready, needs team approval for hook installation

Automatic validation on commit using hybrid bash + Swift approach:
- **Bash entry point** - Fast, universal, CI-friendly
- **Swift validation** - Type-safe, reuses SCALS types (`DocumentVersion`, `Document.Definition`)
- Validates JSON syntax, version field presence, schema immutability

**Implementation**:
```bash
# .git/hooks/pre-commit
#!/bin/bash

# Phase 1: Quick checks (bash)
# - JSON syntax validation
# - Schema file immutability check
# - CHANGELOG update reminders

# Phase 2: Type-safe validation (Swift)
.build/release/scals-validate --staged
```

**Benefits**:
- Catch errors before commit
- Enforce schema immutability
- Automatic CHANGELOG reminders
- Type-safe validation using shared SCALS code

**Why Deferred**: Needs coordination with team on git hook conventions and CI/CD integration

### Git Post-Commit Hooks

**Status**: Deferred - needs team approval

Automatic schema file locking after commit:
- Makes versioned schema files read-only (`chmod 444`)
- Enforces immutability at file system level
- Prevents accidental edits even outside of Git

**Implementation**:
```bash
# .git/hooks/post-commit
#!/bin/bash

# Lock newly committed schema versions
NEW_SCHEMAS=$(git diff-tree --no-commit-id --name-only --diff-filter=A HEAD | grep -E 'SCALS/Schema/.*-v[0-9]+\.[0-9]+\.[0-9]+\.json$')

for schema in $NEW_SCHEMAS; do
    chmod 444 "$schema"
    echo "🔒 Locked: $schema (read-only)"
done
```

**Benefits**:
- File system-level protection
- Automatic enforcement
- Clear feedback to developers

**Why Deferred**: Needs team approval for automated file permission changes

### CI/CD Integration (GitHub Actions)

**Status**: Deferred - needs team CI/CD coordination

Automatic validation in pull requests:

```yaml
name: SCALS Validation

on:
  pull_request:
    paths:
      - 'SCALS/**/*.json'
      - 'ScalsModules/**/*.json'
      - 'SCALS/Schema/*.json'

jobs:
  validate:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3

      - name: Build Swift validator
        run: swift build --package-path ScalsTools --product scals-validate --configuration release

      - name: Run SCALS validator
        run: .build/release/scals-validate

      - name: Check CHANGELOG updates
        run: |
          SCHEMA_CHANGED=$(git diff --name-only origin/${{ github.base_ref }} | grep -c 'SCALS/Schema/' || true)
          CHANGELOG_CHANGED=$(git diff --name-only origin/${{ github.base_ref }} | grep -c 'CHANGELOG' || true)

          if [ $SCHEMA_CHANGED -gt 0 ] && [ $CHANGELOG_CHANGED -eq 0 ]; then
            echo "❌ Schema files changed but no CHANGELOG updated"
            exit 1
          fi
```

**Benefits**:
- Automated validation on every PR
- Prevents invalid JSON from merging
- Enforces CHANGELOG updates

**Why Deferred**: Needs coordination with CI/CD team on workflow integration

### Compatibility Validator Tool

**Status**: Phase 4 - optional feature

Static analysis tool to check if a JSON document is compatible with older renderer versions:
- Input: JSON document + target renderer version
- Output: Report of breaking issues, graceful degradations, ignored properties
- Use in CI/CD to validate backward compatibility before release

**Usage**:
```bash
scals-compat-check my-document.json --target-version 1.5.0
```

---

## Further Reading

- `CHANGELOG-DOCUMENT.md` - Document schema version history
- `CHANGELOG-IR.md` - IR schema version history
- `SCALS/Schema/README.md` - Schema file management
- `CLAUDE.md` - Architectural principles (IR stability)
