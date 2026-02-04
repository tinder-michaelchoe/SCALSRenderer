//
//  ActionTests.swift
//  SCALSTests
//
//  Unit tests for Document.Action JSON parsing.
//

import Foundation
import Testing
@testable import SCALS
@testable import ScalsModules

// MARK: - Dismiss Action Tests

struct DismissActionTests {
    
    @Test func decodesDismissAction() throws {
        let json = """
        { "type": "dismiss" }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .dismiss)
        #expect(action.parameters.isEmpty)
    }
}

// MARK: - SetState Action Tests

struct SetStateActionTests {
    
    @Test func decodesSetStateWithStringLiteral() throws {
        let json = """
        {
            "type": "setState",
            "path": "user.name",
            "value": "John"
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .setState)
        #expect(action.parameters["path"] == .stringValue("user.name"))
        #expect(action.parameters["value"] == .stringValue("John"))
    }
    
    @Test func decodesSetStateWithIntLiteral() throws {
        let json = """
        {
            "type": "setState",
            "path": "counter",
            "value": 42
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .setState)
        #expect(action.parameters["path"] == .stringValue("counter"))
        #expect(action.parameters["value"] == .intValue(42))
    }
    
    @Test func decodesSetStateWithBoolLiteral() throws {
        let json = """
        {
            "type": "setState",
            "path": "isActive",
            "value": true
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .setState)
        #expect(action.parameters["path"] == .stringValue("isActive"))
        #expect(action.parameters["value"] == .boolValue(true))
    }
    
    @Test func decodesSetStateWithExpression() throws {
        let json = """
        {
            "type": "setState",
            "path": "counter",
            "value": { "$expr": "${counter} + 1" }
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .setState)
        #expect(action.parameters["path"] == .stringValue("counter"))
        // Expression is stored as an object in parameters
        if let valueDict = action.parameters["value"]?.objectValue,
           let expr = valueDict["$expr"]?.stringValue {
            #expect(expr == "${counter} + 1")
        } else {
            Issue.record("Expected expression value")
        }
    }
    
    @Test func decodesSetStateWithArrayLiteral() throws {
        let json = """
        {
            "type": "setState",
            "path": "items",
            "value": ["a", "b", "c"]
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .setState)
        #expect(action.parameters["path"] == .stringValue("items"))
        #expect(action.parameters["value"] == .arrayValue([
            .stringValue("a"),
            .stringValue("b"),
            .stringValue("c")
        ]))
    }
}

// MARK: - ToggleState Action Tests

struct ToggleStateActionTests {
    
    @Test func decodesToggleStateAction() throws {
        let json = """
        {
            "type": "toggleState",
            "path": "selected.technology"
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .toggleState)
        #expect(action.parameters["path"] == .stringValue("selected.technology"))
    }

    @Test func decodesToggleStateWithSimplePath() throws {
        let json = """
        {
            "type": "toggleState",
            "path": "isActive"
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .toggleState)
        #expect(action.parameters["path"] == .stringValue("isActive"))
    }
}

// MARK: - ShowAlert Action Tests

struct ShowAlertActionTests {
    
    @Test func decodesShowAlertWithStaticMessage() throws {
        let json = """
        {
            "type": "showAlert",
            "title": "Warning",
            "message": "Are you sure?"
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .showAlert)
        #expect(action.parameters["title"] == .stringValue("Warning"))
        #expect(action.parameters["message"] == .stringValue("Are you sure?"))
    }
    
    @Test func decodesShowAlertWithTemplateMessage() throws {
        let json = """
        {
            "type": "showAlert",
            "title": "Info",
            "message": {
                "type": "binding",
                "template": "Count is ${count}"
            }
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .showAlert)
        #expect(action.parameters["title"] == .stringValue("Info"))

        // Message is stored as an object with type and template
        if let messageDict = action.parameters["message"]?.objectValue,
           let type = messageDict["type"]?.stringValue,
           let template = messageDict["template"]?.stringValue {
            #expect(type == "binding")
            #expect(template == "Count is ${count}")
        } else {
            Issue.record("Expected template message object")
        }
    }
    
    @Test func decodesShowAlertWithButtons() throws {
        let json = """
        {
            "type": "showAlert",
            "title": "Confirm",
            "message": "Delete this item?",
            "buttons": [
                { "label": "Cancel", "style": "cancel" },
                { "label": "Delete", "style": "destructive", "action": "deleteItem" }
            ]
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .showAlert)
        #expect(action.parameters["title"] == .stringValue("Confirm"))
        #expect(action.parameters["message"] == .stringValue("Delete this item?"))

        // Buttons are stored as an array of objects
        if let buttonsArray = action.parameters["buttons"]?.arrayValue {
            #expect(buttonsArray.count == 2)

            if let button0 = buttonsArray[0].objectValue,
               let label0 = button0["label"]?.stringValue,
               let style0 = button0["style"]?.stringValue {
                #expect(label0 == "Cancel")
                #expect(style0 == "cancel")
            } else {
                Issue.record("Expected first button to decode properly")
            }

            if let button1 = buttonsArray[1].objectValue,
               let label1 = button1["label"]?.stringValue,
               let style1 = button1["style"]?.stringValue,
               let action1 = button1["action"]?.stringValue {
                #expect(label1 == "Delete")
                #expect(style1 == "destructive")
                #expect(action1 == "deleteItem")
            } else {
                Issue.record("Expected second button to decode properly")
            }
        } else {
            Issue.record("Expected buttons array")
        }
    }
    
    @Test func decodesShowAlertWithDefaultButton() throws {
        let json = """
        {
            "type": "showAlert",
            "title": "Notice",
            "buttons": [
                { "label": "OK", "style": "default" }
            ]
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .showAlert)
        #expect(action.parameters["title"] == .stringValue("Notice"))

        if let buttonsArray = action.parameters["buttons"]?.arrayValue,
           let button0 = buttonsArray[0].objectValue,
           let style0 = button0["style"]?.stringValue {
            #expect(style0 == "default")
        } else {
            Issue.record("Expected button with default style")
        }
    }
    
    @Test func decodesShowAlertWithoutMessage() throws {
        let json = """
        {
            "type": "showAlert",
            "title": "Title Only"
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .showAlert)
        #expect(action.parameters["title"] == .stringValue("Title Only"))
        #expect(action.parameters["message"] == nil)
    }
}

// MARK: - Navigate Action Tests

struct NavigateActionTests {
    
    @Test func decodesNavigateWithDestinationOnly() throws {
        let json = """
        {
            "type": "navigate",
            "destination": "home"
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .navigate)
        #expect(action.parameters["destination"] == .stringValue("home"))
        #expect(action.parameters["presentation"] == nil)
    }
    
    @Test func decodesNavigateWithPushPresentation() throws {
        let json = """
        {
            "type": "navigate",
            "destination": "details",
            "presentation": "push"
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .navigate)
        #expect(action.parameters["destination"] == .stringValue("details"))
        #expect(action.parameters["presentation"] == .stringValue("push"))
    }
    
    @Test func decodesNavigateWithPresentPresentation() throws {
        let json = """
        {
            "type": "navigate",
            "destination": "settings",
            "presentation": "present"
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .navigate)
        #expect(action.parameters["destination"] == .stringValue("settings"))
        #expect(action.parameters["presentation"] == .stringValue("present"))
    }
    
    @Test func decodesNavigateWithFullScreenPresentation() throws {
        let json = """
        {
            "type": "navigate",
            "destination": "onboarding",
            "presentation": "fullScreen"
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .navigate)
        #expect(action.parameters["destination"] == .stringValue("onboarding"))
        #expect(action.parameters["presentation"] == .stringValue("fullScreen"))
    }
}

// MARK: - Sequence Action Tests

struct SequenceActionTests {
    
    @Test func decodesSequenceWithMultipleActions() throws {
        let json = """
        {
            "type": "sequence",
            "steps": [
                { "type": "setState", "path": "loading", "value": true },
                { "type": "navigate", "destination": "results" },
                { "type": "dismiss" }
            ]
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .sequence)

        // Steps are stored as an array of action objects
        if let stepsArray = action.parameters["steps"]?.arrayValue {
            #expect(stepsArray.count == 3)

            // Check first step: setState
            if let step0 = stepsArray[0].objectValue,
               let type0 = step0["type"]?.stringValue,
               let path0 = step0["path"]?.stringValue {
                #expect(type0 == "setState")
                #expect(path0 == "loading")
            } else {
                Issue.record("Expected setState as first step")
            }

            // Check second step: navigate
            if let step1 = stepsArray[1].objectValue,
               let type1 = step1["type"]?.stringValue,
               let destination1 = step1["destination"]?.stringValue {
                #expect(type1 == "navigate")
                #expect(destination1 == "results")
            } else {
                Issue.record("Expected navigate as second step")
            }

            // Check third step: dismiss
            if let step2 = stepsArray[2].objectValue,
               let type2 = step2["type"]?.stringValue {
                #expect(type2 == "dismiss")
            } else {
                Issue.record("Expected dismiss as third step")
            }
        } else {
            Issue.record("Expected steps array")
        }
    }
    
    @Test func decodesSequenceWithSingleAction() throws {
        let json = """
        {
            "type": "sequence",
            "steps": [
                { "type": "dismiss" }
            ]
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .sequence)

        if let stepsArray = action.parameters["steps"]?.arrayValue {
            #expect(stepsArray.count == 1)
        } else {
            Issue.record("Expected steps array")
        }
    }
    
    @Test func decodesNestedSequence() throws {
        let json = """
        {
            "type": "sequence",
            "steps": [
                {
                    "type": "sequence",
                    "steps": [
                        { "type": "dismiss" }
                    ]
                }
            ]
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == .sequence)

        if let stepsArray = action.parameters["steps"]?.arrayValue {
            // Check first step is a nested sequence
            if let step0 = stepsArray[0].objectValue,
               let type0 = step0["type"]?.stringValue,
               let nestedSteps = step0["steps"]?.arrayValue {
                #expect(type0 == "sequence")
                #expect(nestedSteps.count == 1)
            } else {
                Issue.record("Expected nested sequence")
            }
        } else {
            Issue.record("Expected steps array")
        }
    }
}

// MARK: - Custom Action Tests

struct CustomActionTests {
    
    @Test func decodesCustomAction() throws {
        let json = """
        {
            "type": "analytics.track",
            "event": "button_clicked",
            "category": "ui"
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == Document.ActionKind(rawValue: "analytics.track"))
        #expect(action.parameters["event"] == .stringValue("button_clicked"))
        #expect(action.parameters["category"] == .stringValue("ui"))
    }
    
    @Test func decodesCustomActionWithComplexParams() throws {
        let json = """
        {
            "type": "myCustomAction",
            "count": 5,
            "enabled": true,
            "tags": ["a", "b"]
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == Document.ActionKind(rawValue: "myCustomAction"))
        #expect(action.parameters["count"] == .intValue(5))
        #expect(action.parameters["enabled"] == .boolValue(true))
        #expect(action.parameters["tags"] == .arrayValue([
            .stringValue("a"),
            .stringValue("b")
        ]))
    }
    
    @Test func decodesCustomActionWithNoParams() throws {
        let json = """
        {
            "type": "unknownAction"
        }
        """
        let data = json.data(using: .utf8)!
        let action = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(action.type == Document.ActionKind(rawValue: "unknownAction"))
        #expect(action.parameters.isEmpty)
    }
}

// MARK: - Action Dictionary Tests

struct ActionDictionaryTests {
    
    @Test func decodesActionsDictionary() throws {
        let json = """
        {
            "dismiss": { "type": "dismiss" },
            "increment": {
                "type": "setState",
                "path": "count",
                "value": { "$expr": "${count} + 1" }
            },
            "goHome": {
                "type": "navigate",
                "destination": "home"
            }
        }
        """
        let data = json.data(using: .utf8)!
        let actions = try JSONDecoder().decode([String: Document.Action].self, from: data)

        #expect(actions.count == 3)

        if let dismissAction = actions["dismiss"] {
            #expect(dismissAction.type == .dismiss)
        } else {
            Issue.record("Expected dismiss action")
        }

        if let incrementAction = actions["increment"] {
            #expect(incrementAction.type == .setState)
            #expect(incrementAction.parameters["path"] == .stringValue("count"))
        } else {
            Issue.record("Expected setState action")
        }

        if let goHomeAction = actions["goHome"] {
            #expect(goHomeAction.type == .navigate)
            #expect(goHomeAction.parameters["destination"] == .stringValue("home"))
        } else {
            Issue.record("Expected navigate action")
        }
    }
}

// MARK: - Round Trip Tests

struct ActionRoundTripTests {
    
    @Test func roundTripsDismissAction() throws {
        let original = Document.Action(type: .dismiss, parameters: [:])
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(decoded.type == .dismiss)
        #expect(decoded.parameters.isEmpty)
    }
    
    @Test func roundTripsSetStateAction() throws {
        let original = Document.Action(
            type: .setState,
            parameters: [
                "path": .stringValue("count"),
                "value": .intValue(10)
            ]
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(decoded.type == .setState)
        #expect(decoded.parameters["path"] == .stringValue("count"))
        #expect(decoded.parameters["value"] == .intValue(10))
    }
    
    @Test func roundTripsNavigateAction() throws {
        let original = Document.Action(
            type: .navigate,
            parameters: [
                "destination": .stringValue("home"),
                "presentation": .stringValue("push")
            ]
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Document.Action.self, from: data)

        #expect(decoded.type == .navigate)
        #expect(decoded.parameters["destination"] == .stringValue("home"))
        #expect(decoded.parameters["presentation"] == .stringValue("push"))
    }
}
