# Document Schema Snapshots

This directory contains frozen snapshots of Document schema versions for reference and migration purposes.

## Purpose

Document schema snapshots preserve the exact structure of Document types (JSON API) as they existed at specific versions. These snapshots:

1. **Serve as historical reference** - Document what the JSON API looked like at each version
2. **Enable migration tooling** - Allow building converters between JSON schema versions
3. **Support backward compatibility analysis** - Help understand what changed between versions

## Policy

### Creating New Snapshots

Create a new snapshot **before** making breaking changes to the Document layer:

1. Bump the version in `DocumentVersioning.swift`
2. Create a new directory: `v{major}_{minor}_{patch}/`
3. Copy current types to snapshot before making changes
4. Document the changes in this file
5. Make changes to current types
6. **Make snapshot files read-only**: `chmod 444 v{version}/*.swift`

### Snapshot Immutability

**CRITICAL: Snapshot files must NEVER be modified after creation.**

Two layers of protection:
1. **Code comments** - Each file has a FROZEN SNAPSHOT header
2. **Filesystem permissions** - Files are made read-only (`chmod 444`)

If you need to fix a snapshot error, create a new snapshot with corrections and document the issue.

### When to Create Snapshots

Create snapshots for **breaking changes** that affect:
- Component property types or names
- Component removal
- Action signature changes
- Structural changes to the JSON format

**Do NOT** create snapshots for:
- Additive changes (new components, new optional properties)
- Internal implementation changes
- Documentation updates

## Version History

### v0.1.0 (Current)

**Snapshot Created:** Initial release

The initial Document schema with core components:
- Container (VStack, HStack, ZStack)
- Text
- Button
- Image
- TextField

## Directory Structure

```
Snapshots/
├── SnapshotPolicy.md     # This file
└── v{X}_{Y}_{Z}/
    ├── DocumentTypesV{version}.swift    # Core Document types
    └── ComponentsV{version}.swift       # Component definitions
```

## Usage

Snapshot types are namespaced under `DocumentSnapshot.V{version}`:

```swift
// Access v0.1.0 types
let component: DocumentSnapshot.V0_1_0.Component = ...
```

## Notes for Future Maintainers

1. **Snapshots are frozen** - Never modify existing snapshot files
2. **Keep snapshots minimal** - Only capture what changed; reference current types where possible
3. **Document thoroughly** - Each version's changes should be clearly explained
4. **Test migrations** - If building migration tooling, test against real document samples
