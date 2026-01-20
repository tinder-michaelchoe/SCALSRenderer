# CladsTools

Developer tools for the CLADS Framework - A collection of CLI utilities designed to make development easier, faster, and more consistent.

## Overview

CladsTools provides automated code generation, validation, and analysis tools specifically designed for LLM-assisted development of the CladsFramework.

## 📚 Documentation

**Complete documentation available in `docs/` directory**:

- **[Quick Start](docs/QUICK_START.md)** ⚡ - Get started in 5 minutes
- **[LLM Usage Guide](docs/LLM_USAGE_GUIDE.md)** 🤖 - For AI assistants
- **[Development Workflows](docs/DEVELOPMENT_WORKFLOWS.md)** 💻 - Real-world examples
- **[Maintainer Guide](docs/MAINTAINER_GUIDE.md)** 🔧 - Contributing guide
- **[Architecture](docs/ARCHITECTURE.md)** 🏗️ - Internal design

**👉 [Browse all documentation](docs/README.md)**

---

## Installation

### Build from source

```bash
cd CladsTools
swift build -c release
```

### Install executables

```bash
swift build -c release
cp .build/release/clads-* /usr/local/bin/
```

## Tools

### 1. Component Consistency Checker (`clads-consistency-checker`)

Ensures all components follow framework patterns and conventions.

**Purpose**: Validate component consistency across the framework

**Features**:
- Check naming conventions
- Verify property handling patterns
- Ensure ViewNode creation consistency
- Validate style resolution approach
- Check error handling patterns
- Verify test coverage requirements

**Usage**:
```bash
# Check current directory
clads-consistency-checker

# Check specific framework directory
clads-consistency-checker --framework-path /path/to/clads

# Auto-fix issues
clads-consistency-checker --fix

# Verbose output
clads-consistency-checker --verbose
```

**Output**:
```
==========================================================
CLADS Component Consistency Checker
==========================================================

ℹ️  Analyzing framework at: /path/to/CladsRenderer
⏳ Analyzing 8 component resolvers...

--- Component Resolvers ---
ℹ️  Found 8 component resolvers

⚠️  Missing test file: SliderComponentResolutionTests.swift

==========================================================
Summary
==========================================================

⚠️  Found 1 issue(s)
ℹ️  Run with --fix to auto-fix issues where possible
```

---

### 2. Component Property Validator (`clads-property-validator`)

Validates that component properties are handled consistently across all layers.

**Purpose**: Check Document → IR → Renderer pipeline consistency

**Usage**:
```bash
clads-property-validator --component button
```

---

### 3. Component Generator (`clads-component-generator`)

Generates boilerplate code for new component types.

**Purpose**: Speed up new component development

**Usage**:
```bash
clads-component-generator \
  --name video \
  --properties '{"url": "string", "autoplay": "boolean"}' \
  --platforms swiftui,html
```

**Output**: Generates complete component package with:
- `ComponentResolving` implementation
- `RenderNode` case and struct
- Registry code
- Platform renderers
- Test skeleton
- Documentation

---

### 4. Test Case Generator (`clads-test-generator`)

Auto-generates test cases from JSON schema definitions.

**Purpose**: Automate repetitive test writing

**Usage**:
```bash
clads-test-generator \
  --schema clads-schema.json \
  --component button
```

---

### 5. Integration Test Generator (`clads-integration-test-generator`)

Generates end-to-end tests for complete JSON examples.

**Purpose**: Create comprehensive integration tests

**Usage**:
```bash
clads-integration-test-generator \
  --example examples/dad-jokes.json
```

---

### 6. Component Reference Generator (`clads-reference-generator`)

Auto-generates component reference documentation.

**Purpose**: Keep documentation in sync with code

**Usage**:
```bash
clads-reference-generator \
  --component button \
  --output docs/components/button.md
```

---

### 7. Action Handler Generator (`clads-action-generator`)

Generates action handler implementations.

**Purpose**: Speed up action development

**Usage**:
```bash
clads-action-generator \
  --name playVideo \
  --parameters '{"url": "string"}'
```

---

### 8. Design System Provider Generator (`clads-design-system-generator`)

Generates design system provider from design tokens.

**Purpose**: Integrate design systems easily

**Usage**:
```bash
clads-design-system-generator \
  --tokens design-tokens.json \
  --output DesignSystemProvider.swift
```

---

### 9. Custom Component Template Generator (`clads-custom-component-generator`)

Generates complete custom component package.

**Purpose**: Create custom component scaffolding

**Usage**:
```bash
clads-custom-component-generator \
  --name videoPlayer \
  --output CustomComponents/
```

---

### 10. Component Migration Assistant (`clads-migration-assistant`)

Helps update existing components with new features.

**Purpose**: Simplify framework-wide updates

**Usage**:
```bash
clads-migration-assistant \
  --feature padding \
  --components all
```

---

### 11. Component Update Assistant (`clads-update-assistant`)

Helps update components across all layers.

**Purpose**: Coordinate multi-layer updates

**Usage**:
```bash
clads-update-assistant \
  --component button \
  --change "Add disabled state"
```

---

### 12. Performance Profiler (`clads-performance-profiler`)

Analyzes JSON parsing and resolution performance.

**Purpose**: Identify performance bottlenecks

**Usage**:
```bash
clads-performance-profiler \
  --example examples/*.json
```

---

## Development

### Project Structure

```
CladsTools/
├── Package.swift                 # Package manifest
├── Sources/
│   ├── CladsToolsCore/          # Shared utilities
│   │   ├── CLIUtilities.swift
│   │   ├── TemplateEngine.swift
│   │   └── SwiftCodeAnalyzer.swift
│   ├── ConsistencyChecker/      # 4.1
│   ├── PropertyValidator/       # 1.2
│   ├── ComponentGenerator/      # 1.1
│   ├── TestGenerator/           # 2.1
│   ├── IntegrationTestGenerator/# 2.3
│   ├── ReferenceGenerator/      # 3.1
│   ├── ActionGenerator/         # 6.1
│   ├── DesignSystemGenerator/   # 6.2
│   ├── CustomComponentGenerator/# 6.4
│   ├── MigrationAssistant/      # 1.3
│   ├── UpdateAssistant/         # 7.2
│   └── PerformanceProfiler/     # 4.4
└── Tests/
    └── CladsToolsCoreTests/
```

### Adding a New Tool

1. Add executable target to `Package.swift`
2. Create `Sources/[ToolName]/main.swift`
3. Implement `ParsableCommand` protocol
4. Use `CladsToolsCore` utilities
5. Add tests

### Dependencies

- **swift-argument-parser**: CLI argument handling
- **Stencil**: Template-based code generation
- **SwiftSyntax**: AST parsing and analysis

## License

Same as CladsFramework

## Contributing

These tools are designed for LLM-assisted development. When adding new tools:

1. Follow existing patterns in `CladsToolsCore`
2. Use `ArgumentParser` for CLI interface
3. Provide clear, actionable error messages
4. Include progress indicators for long operations
5. Add `--fix` flag for auto-fixable issues
6. Document usage in this README

## Future Enhancements

See `/Users/michael.choe/.claude/plans/graceful-wandering-toast.md` for the complete roadmap of planned tools.
