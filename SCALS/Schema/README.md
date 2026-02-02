# SCALS Schema Files

This directory contains JSON Schema definitions for SCALS documents and IR (Intermediate Representation).

## File Naming Convention

Schema files include version in filename: `{name}-v{major}.{minor}.{patch}.json`

Examples:
- `scals-document-v0.1.0.json` - Document schema version 0.1.0
- `scals-ir-v0.1.0.json` - IR schema version 0.1.0

## Symlinks

Symlinks point to the latest version for convenience:
- `scals-document-latest.json` → `scals-document-v0.1.0.json`
- `scals-ir-latest.json` → `scals-ir-v0.1.0.json`

Use the `-latest` symlinks in your IDE configuration for autocomplete and validation.

## Schema Purposes

### Document Schema (`scals-document-*.json`)

The **user-facing JSON API** that can evolve frequently:
- Defines valid JSON document structure
- Multiple ways to express properties (shorthand, specific values)
- Used for IDE autocomplete and validation when authoring JSON

### IR Schema (`scals-ir-*.json`)

The **renderer contract** that remains extremely stable:
- Defines the resolved, canonical representation
- All styles fully resolved and flattened
- Breaking changes are rare and require ecosystem-wide coordination

## Immutability

**Old schema versions are immutable** - they are historical records that should never be modified.

### Why?

- Documents may reference specific schema versions
- Breaking immutability breaks reproducibility
- Old schemas serve as API documentation for that version

### Creating a New Version

1. **Copy the latest version:**
   ```bash
   cp scals-document-v0.1.0.json scals-document-v0.2.0.json
   ```

2. **Update the version field inside the new file:**
   ```json
   {
     "version": "0.2.0",
     ...
   }
   ```

3. **Make your changes to the new file**

4. **Update the symlink:**
   ```bash
   ln -sf scals-document-v0.2.0.json scals-document-latest.json
   ```

5. **Update CHANGELOG-DOCUMENT.md** at the project root

6. **Commit both the new schema and updated symlink**

### Protection

Old schema versions are protected by:
- Manual review during code review
- Documentation about immutability (this file)
- Future: Git hooks for automated enforcement

## Schema Validation

Use the latest schema for validation:
```bash
# Using jsonschema tool
jsonschema -i my-document.json scals-document-latest.json

# Using ajv
ajv validate -s scals-document-latest.json -d my-document.json
```

Or validate against a specific version:
```bash
jsonschema -i my-document.json scals-document-v0.1.0.json
```

## IDE Configuration

### VS Code

Add to `.vscode/settings.json`:
```json
{
  "json.schemas": [
    {
      "fileMatch": ["**/*.scals.json"],
      "url": "./SCALS/Schema/scals-document-latest.json"
    }
  ]
}
```

### IntelliJ / Android Studio

Configure JSON Schema mappings in Preferences → Languages & Frameworks → Schemas and DTDs → JSON Schema Mappings.

## Version History

See the CHANGELOG files at the project root:
- `CHANGELOG-DOCUMENT.md` - Document schema changes
- `CHANGELOG-IR.md` - IR schema changes (rare)
