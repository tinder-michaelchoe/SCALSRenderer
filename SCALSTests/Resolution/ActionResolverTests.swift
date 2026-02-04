//
//  ActionResolverTests.swift
//  SCALSTests
//
//  Unit tests for ActionResolver - converting Document.Action to ActionDefinition.
//

import Foundation
import Testing
@testable import SCALS
@testable import ScalsModules

// MARK: - Test Helpers

/// Creates a minimal ResolutionContext for testing
fileprivate func makeTestContext() -> ResolutionContext {
    let document = Document.Definition(
        id: "test",
        root: Document.RootComponent(children: [])
    )
    let stateStore = StateStore()
    return ResolutionContext.withoutTracking(
        document: document,
        stateStore: stateStore,
        designSystemProvider: nil
    )
}

// MARK: - Dismiss Action Tests

struct ActionResolverDismissTests {

    @Test func resolvesDismissAction() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .dismiss, parameters: [:])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .dismiss)
    }
}

// MARK: - SetState Action Tests

struct ActionResolverSetStateTests {

    @Test func resolvesSetStateWithLiteralString() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .setState, parameters: [
            "path": .stringValue("user.name"),
            "value": .stringValue("John")
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .setState)
        let path: String = try result.requiredParameter("path")
        let value: String = try result.requiredParameter("value")
        #expect(path == "user.name")
        #expect(value == "John")
    }

    @Test func resolvesSetStateWithLiteralInt() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .setState, parameters: [
            "path": .stringValue("counter"),
            "value": .intValue(42)
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .setState)
        let path: String = try result.requiredParameter("path")
        let value: Int = try result.requiredParameter("value")
        #expect(path == "counter")
        #expect(value == 42)
    }

    @Test func resolvesSetStateWithLiteralBool() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .setState, parameters: [
            "path": .stringValue("isActive"),
            "value": .boolValue(true)
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .setState)
        let path: String = try result.requiredParameter("path")
        let value: Bool = try result.requiredParameter("value")
        #expect(path == "isActive")
        #expect(value == true)
    }

    @Test func resolvesSetStateWithExpression() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .setState, parameters: [
            "path": .stringValue("count"),
            "value": .objectValue(["$expr": .stringValue("${count} + 1")])
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .setState)
        let path: String = try result.requiredParameter("path")
        let expression: String = try result.requiredParameter("expression")
        #expect(path == "count")
        #expect(expression == "${count} + 1")
    }

    @Test func resolvesSetStateWithNestedPath() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .setState, parameters: [
            "path": .stringValue("user.profile.settings.theme"),
            "value": .stringValue("dark")
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .setState)
        let path: String = try result.requiredParameter("path")
        #expect(path == "user.profile.settings.theme")
    }
}

// MARK: - ToggleState Action Tests

struct ActionResolverToggleStateTests {

    @Test func resolvesToggleStateAction() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .toggleState, parameters: [
            "path": .stringValue("isEnabled")
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .toggleState)
        let path: String = try result.requiredParameter("path")
        #expect(path == "isEnabled")
    }

    @Test func resolvesToggleStateWithNestedPath() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .toggleState, parameters: [
            "path": .stringValue("settings.notifications.enabled")
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .toggleState)
        let path: String = try result.requiredParameter("path")
        #expect(path == "settings.notifications.enabled")
    }
}

// MARK: - ShowAlert Action Tests

struct ActionResolverShowAlertTests {

    @Test func resolvesShowAlertWithTitleOnly() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .showAlert, parameters: [
            "title": .stringValue("Alert Title")
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .showAlert)
        let title: String = try result.requiredParameter("title")
        let message: String? = result.parameter("message")
        let buttons: [[String: Any]] = result.parameter("buttons") ?? []
        #expect(title == "Alert Title")
        #expect(message == nil)
        #expect(buttons.isEmpty)
    }

    @Test func resolvesShowAlertWithStaticMessage() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .showAlert, parameters: [
            "title": .stringValue("Error"),
            "message": .stringValue("Something went wrong")
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .showAlert)
        let title: String = try result.requiredParameter("title")
        let message: String? = result.parameter("message")
        let isTemplate: Bool = result.parameter("messageIsTemplate") ?? false
        #expect(title == "Error")
        #expect(message == "Something went wrong")
        #expect(isTemplate == false)
    }

    @Test func resolvesShowAlertWithTemplateMessage() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .showAlert, parameters: [
            "title": .stringValue("Welcome"),
            "message": .objectValue(["$template": .stringValue("Hello ${username}!")])
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .showAlert)
        let title: String = try result.requiredParameter("title")
        let message: String? = result.parameter("message")
        let isTemplate: Bool = result.parameter("messageIsTemplate") ?? false
        #expect(title == "Welcome")
        #expect(message == "Hello ${username}!")
        #expect(isTemplate == true)
    }

    @Test func resolvesShowAlertWithButtons() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .showAlert, parameters: [
            "title": .stringValue("Confirm"),
            "buttons": .arrayValue([
                .objectValue(["label": .stringValue("OK"), "style": .stringValue("default")]),
                .objectValue(["label": .stringValue("Cancel"), "style": .stringValue("cancel")])
            ])
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .showAlert)
        let buttons: [[String: Any]] = try result.requiredParameter("buttons")
        #expect(buttons.count == 2)
        #expect(buttons[0]["label"] as? String == "OK")
        #expect(buttons[0]["style"] as? String == "default")
        #expect(buttons[1]["label"] as? String == "Cancel")
        #expect(buttons[1]["style"] as? String == "cancel")
    }

    @Test func resolvesShowAlertWithButtonAction() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .showAlert, parameters: [
            "title": .stringValue("Delete?"),
            "buttons": .arrayValue([
                .objectValue([
                    "label": .stringValue("Delete"),
                    "style": .stringValue("destructive"),
                    "action": .stringValue("confirmDelete")
                ])
            ])
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .showAlert)
        let buttons: [[String: Any]] = try result.requiredParameter("buttons")
        #expect(buttons[0]["action"] as? String == "confirmDelete")
        #expect(buttons[0]["style"] as? String == "destructive")
    }

    @Test func resolvesShowAlertWithDefaultButtonStyle() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .showAlert, parameters: [
            "title": .stringValue("Info"),
            "buttons": .arrayValue([
                .objectValue(["label": .stringValue("OK")])
            ])
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .showAlert)
        let buttons: [[String: Any]] = try result.requiredParameter("buttons")
        // Default style is "default"
        #expect(buttons[0]["style"] as? String == "default")
    }
}

// MARK: - Navigate Action Tests

struct ActionResolverNavigateTests {

    @Test func resolvesNavigateWithDefaultPresentation() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .navigate, parameters: [
            "destination": .stringValue("settings")
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .navigate)
        let destination: String = try result.requiredParameter("destination")
        let presentation: Document.NavigationPresentation = try result.requiredParameter("presentation")
        #expect(destination == "settings")
        #expect(presentation == .push)
    }

    @Test func resolvesNavigateWithPush() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .navigate, parameters: [
            "destination": .stringValue("profile"),
            "presentation": .stringValue("push")
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .navigate)
        let destination: String = try result.requiredParameter("destination")
        let presentation: Document.NavigationPresentation = try result.requiredParameter("presentation")
        #expect(destination == "profile")
        #expect(presentation == .push)
    }

    @Test func resolvesNavigateWithPresent() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .navigate, parameters: [
            "destination": .stringValue("modal"),
            "presentation": .stringValue("present")
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .navigate)
        let presentation: Document.NavigationPresentation = try result.requiredParameter("presentation")
        #expect(presentation == .present)
    }

    @Test func resolvesNavigateWithFullScreen() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .navigate, parameters: [
            "destination": .stringValue("fullscreen"),
            "presentation": .stringValue("fullScreen")
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .navigate)
        let presentation: Document.NavigationPresentation = try result.requiredParameter("presentation")
        #expect(presentation == .fullScreen)
    }
}

// MARK: - Sequence Action Tests

struct ActionResolverSequenceTests {

    @Test func resolvesEmptySequence() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .sequence, parameters: [
            "steps": .arrayValue([])
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .sequence)
        let steps: [IR.ActionDefinition] = try result.requiredParameter("steps")
        #expect(steps.isEmpty)
    }

    @Test func resolvesSingleStepSequence() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .sequence, parameters: [
            "steps": .arrayValue([
                .objectValue(["type": .stringValue("dismiss")])
            ])
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .sequence)
        let steps: [IR.ActionDefinition] = try result.requiredParameter("steps")
        #expect(steps.count == 1)
        #expect(steps[0].kind == .dismiss)
    }

    @Test func resolvesMultiStepSequence() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .sequence, parameters: [
            "steps": .arrayValue([
                .objectValue([
                    "type": .stringValue("setState"),
                    "path": .stringValue("loading"),
                    "value": .boolValue(true)
                ]),
                .objectValue([
                    "type": .stringValue("showAlert"),
                    "title": .stringValue("Processing...")
                ]),
                .objectValue(["type": .stringValue("dismiss")])
            ])
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .sequence)
        let steps: [IR.ActionDefinition] = try result.requiredParameter("steps")
        #expect(steps.count == 3)
        #expect(steps[0].kind == .setState)
        #expect(steps[1].kind == .showAlert)
        #expect(steps[2].kind == .dismiss)
    }

    @Test func resolvesNestedSequence() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(type: .sequence, parameters: [
            "steps": .arrayValue([
                .objectValue([
                    "type": .stringValue("sequence"),
                    "steps": .arrayValue([
                        .objectValue(["type": .stringValue("dismiss")])
                    ])
                ])
            ])
        ])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind == .sequence)
        let steps: [IR.ActionDefinition] = try result.requiredParameter("steps")
        #expect(steps.count == 1)
        #expect(steps[0].kind == .sequence)
        let nested: [IR.ActionDefinition] = try steps[0].requiredParameter("steps")
        #expect(nested.count == 1)
        #expect(nested[0].kind == .dismiss)
    }
}

// MARK: - Custom Action Tests

struct ActionResolverCustomTests {

    @Test func throwsErrorForUnregisteredActionType() {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(
            type: Document.ActionKind(rawValue: "analytics.track"),
            parameters: [:]
        )
        let context = makeTestContext()

        #expect(throws: ActionResolutionError.self) {
            try resolver.resolve(action, context: context)
        }
    }

    @Test func throwsErrorForUnregisteredActionWithParameters() {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let action = Document.Action(
            type: Document.ActionKind(rawValue: "api.call"),
            parameters: [
                "endpoint": .stringValue("/users"),
                "method": .stringValue("GET")
            ]
        )
        let context = makeTestContext()

        #expect(throws: ActionResolutionError.self) {
            try resolver.resolve(action, context: context)
        }
    }

    @Test func canResolveCustomActionWithRegisteredResolver() throws {
        // Create a registry with a custom resolver
        let registry = ActionResolverRegistry.default

        // Define custom action kind
        let customKind = Document.ActionKind(rawValue: "custom.test")

        // Register a simple custom resolver
        struct CustomTestResolver: ActionResolving {
            static let actionKind = Document.ActionKind(rawValue: "custom.test")
            func resolve(_ action: Document.Action, context: ResolutionContext) throws -> IR.ActionDefinition {
                return IR.ActionDefinition(kind: Self.actionKind, executionData: [:])
            }
        }
        registry.register(CustomTestResolver())

        let resolver = ActionResolver(registry: registry)
        let action = Document.Action(type: customKind, parameters: [:])
        let context = makeTestContext()

        let result = try resolver.resolve(action, context: context)

        #expect(result.kind.rawValue == "custom.test")
    }
}

// MARK: - ResolveAll Tests

struct ActionResolverResolveAllTests {

    @Test func resolvesNilActionsToEmptyDictionary() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let context = makeTestContext()

        let result = try resolver.resolveAll(nil, context: context)

        #expect(result.isEmpty)
    }

    @Test func resolvesEmptyActionsToEmptyDictionary() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let context = makeTestContext()

        let result = try resolver.resolveAll([:], context: context)

        #expect(result.isEmpty)
    }

    @Test func resolvesMultipleActions() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let actions: [String: Document.Action] = [
            "close": Document.Action(type: .dismiss, parameters: [:]),
            "toggle": Document.Action(type: .toggleState, parameters: ["path": .stringValue("flag")]),
            "submit": Document.Action(type: .navigate, parameters: ["destination": .stringValue("confirmation")])
        ]
        let context = makeTestContext()

        let result = try resolver.resolveAll(actions, context: context)

        #expect(result.count == 3)
        #expect(result.keys.contains("close"))
        #expect(result.keys.contains("toggle"))
        #expect(result.keys.contains("submit"))
    }

    @Test func preservesActionIds() throws {
        let resolver = ActionResolver(registry: ActionResolverRegistry.default)
        let actions: [String: Document.Action] = [
            "mySpecialAction": Document.Action(type: .dismiss, parameters: [:])
        ]
        let context = makeTestContext()

        let result = try resolver.resolveAll(actions, context: context)

        #expect(result["mySpecialAction"]?.kind == .dismiss)
    }
}
