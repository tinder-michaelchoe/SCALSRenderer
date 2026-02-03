# IR Schema Snapshots

This directory contains frozen snapshots of IR schema versions for reference and migration purposes.

## Purpose

IR schema snapshots preserve the exact structure of IR types as they existed at specific versions. These snapshots:

1. **Serve as historical reference** - Document what the IR looked like at each version
2. **Enable migration tooling** - Allow building converters between schema versions
3. **Support backward compatibility analysis** - Help understand what changed between versions

## Policy

### Creating New Snapshots

Create a new snapshot **before** making breaking changes to the IR:

1. Bump the version in `DocumentVersioning.swift`
2. Create a new directory: `v{major}_{minor}_{patch}/`
3. Copy current types to snapshot before making changes
4. Document the changes in this README
5. Make breaking changes to current types
6. **Make snapshot files read-only**: `chmod 444 v{version}/*.swift`

### Snapshot Immutability

**CRITICAL: Snapshot files must NEVER be modified after creation.**

Two layers of protection:
1. **Code comments** - Each file has a FROZEN SNAPSHOT header
2. **Filesystem permissions** - Files are made read-only (`chmod 444`)

If you need to fix a snapshot error, create a new snapshot with corrections and document the issue.

### When to Create Snapshots

Create snapshots for **breaking changes** that affect:
- Property types (e.g., `Color` to `Color?`)
- Property removal
- Structural changes (e.g., nesting changes)
- Semantic changes that affect renderers

**Do NOT** create snapshots for:
- Additive changes (new optional properties)
- Internal implementation changes
- Documentation updates

## Version History

### v0.1.0 (Initial Release)

**Snapshot Created:** 2026-02-02

The initial IR schema with non-optional backgroundColor properties.

**Key Characteristics:**
- `backgroundColor: IR.Color` (non-optional, default `.clear`)
- Applied to: RootNode, ContainerNode, TextNode, ButtonStateStyle, TextFieldNode, ImageNode

### v0.2.0 (Current)

**Changes from v0.1.0:**
- `backgroundColor: IR.Color?` (optional, default `nil`)
- `nil` means "no background applied" (different from `.clear` which renders transparent)
- Allows renderers to distinguish between "explicitly clear" and "no background"

| Node | v0.1.0 | v0.2.0 |
|------|--------|--------|
| RootNode.backgroundColor | `IR.Color` (default `.clear`) | `IR.Color?` (default `nil`) |
| ContainerNode.backgroundColor | `IR.Color` (default `.clear`) | `IR.Color?` (default `nil`) |
| TextNode.backgroundColor | `IR.Color` (default `.clear`) | `IR.Color?` (default `nil`) |
| ButtonStateStyle.backgroundColor | `IR.Color` (default `.clear`) | `IR.Color?` (default `nil`) |
| TextFieldNode.backgroundColor | `IR.Color` (default `.clear`) | `IR.Color?` (default `nil`) |
| ImageNode.backgroundColor | `IR.Color` (default `.clear`) | `IR.Color?` (default `nil`) |

## Directory Structure

```
Snapshots/
├── README.md              # This file
└── v0_1_0/
    ├── IRTypesV0_1_0.swift      # Core IR types (references current since unchanged)
    └── RenderTreeV0_1_0.swift   # Node types with v0.1.0 schema
```

## Usage

Snapshot types are namespaced under `IRSnapshot.V{version}`:

```swift
// Access v0.1.0 types
let container: IRSnapshot.V0_1_0.ContainerNode = ...

// These types reference current IR.* value types where unchanged
container.padding  // Returns IR.EdgeInsets (current type)
container.backgroundColor  // Returns IR.Color (non-optional in v0.1.0)
```

## Notes for Future Maintainers

1. **Snapshots are frozen** - Never modify existing snapshot files
2. **Keep snapshots minimal** - Only capture what changed; reference current types where possible
3. **Document thoroughly** - Each version's changes should be clearly explained
4. **Test migrations** - If building migration tooling, test against real document samples
