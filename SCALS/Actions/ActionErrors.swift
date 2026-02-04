//
//  ActionErrors.swift
//  ScalsRendererFramework
//
//  Error types for the action system.
//

import Foundation

/// Errors that can occur during action execution (IR → Platform effects).
public enum ActionExecutionError: Error, CustomStringConvertible {
    /// Required parameter is missing from action definition
    case missingParameter(String)

    /// Parameter exists but has wrong type
    case invalidParameterType(String, expected: String, got: String)

    /// Action execution failed with an underlying error
    case executionFailed(String, underlyingError: Error)

    public var description: String {
        switch self {
        case .missingParameter(let key):
            return "Required parameter '\(key)' not found in action definition"
        case .invalidParameterType(let key, let expected, let got):
            return "Parameter '\(key)' has wrong type (expected \(expected), got \(got))"
        case .executionFailed(let kind, let error):
            return "Action execution failed for '\(kind)': \(error.localizedDescription)"
        }
    }
}
