//
//  IRTypesV0_1_0.swift
//  ScalsRendererFramework
//
// ============================================================
// FROZEN SNAPSHOT - DO NOT MODIFY
// IR Schema Version: 0.1.0
// Snapshot Created: 2026-02-02
//
// This file represents the IR schema as it existed in v0.1.0.
// It is preserved for reference and migration purposes only.
// All new development should use the current IR types.
// ============================================================
//

import Foundation

// MARK: - IRSnapshot Namespace

/// Namespace for frozen IR schema snapshots.
///
/// Each version snapshot is nested under this enum to avoid type conflicts
/// with the current IR types.
public enum IRSnapshot {}

// MARK: - V0_1_0 Namespace

extension IRSnapshot {
    /// Frozen IR schema version 0.1.0.
    ///
    /// **Key Characteristics:**
    /// - `backgroundColor` is non-optional (`IR.Color`) with default `.clear`
    /// - All other value types unchanged from current
    ///
    /// **DO NOT MODIFY** - This is a historical snapshot.
    public enum V0_1_0 {}
}

// MARK: - Type Aliases for Unchanged Types

extension IRSnapshot.V0_1_0 {
    // These types have not changed between v0.1.0 and current.
    // We reference the current IR types directly.

    /// Platform-agnostic color (unchanged from current)
    public typealias Color = IR.Color

    /// Platform-agnostic edge insets (unchanged from current)
    public typealias EdgeInsets = IR.EdgeInsets

    /// Platform-agnostic shadow (unchanged from current)
    public typealias Shadow = IR.Shadow

    /// Platform-agnostic border (unchanged from current)
    public typealias Border = IR.Border

    /// Platform-agnostic alignment (unchanged from current)
    public typealias Alignment = IR.Alignment

    /// Horizontal alignment (unchanged from current)
    public typealias HorizontalAlignment = IR.HorizontalAlignment

    /// Vertical alignment (unchanged from current)
    public typealias VerticalAlignment = IR.VerticalAlignment

    /// Unit point for gradients (unchanged from current)
    public typealias UnitPoint = IR.UnitPoint

    /// Color scheme (unchanged from current)
    public typealias ColorScheme = IR.ColorScheme

    /// Font weight (unchanged from current)
    public typealias FontWeight = IR.FontWeight

    /// Text alignment (unchanged from current)
    public typealias TextAlignment = IR.TextAlignment

    /// Dimension value (unchanged from current)
    public typealias DimensionValue = IR.DimensionValue

    /// Section type (unchanged from current)
    public typealias SectionType = IR.SectionType

    /// Column config (unchanged from current)
    public typealias ColumnConfig = IR.ColumnConfig

    /// Section config (unchanged from current)
    public typealias SectionConfig = IR.SectionConfig

    /// Item dimensions (unchanged from current)
    public typealias ItemDimensions = IR.ItemDimensions

    /// Snap behavior (unchanged from current)
    public typealias SnapBehavior = IR.SnapBehavior

    /// Positioning (unchanged from current)
    public typealias Positioning = IR.Positioning

    /// Positioned edge inset (unchanged from current)
    public typealias PositionedEdgeInset = IR.PositionedEdgeInset

    /// Positioned edge insets (unchanged from current)
    public typealias PositionedEdgeInsets = IR.PositionedEdgeInsets
}
