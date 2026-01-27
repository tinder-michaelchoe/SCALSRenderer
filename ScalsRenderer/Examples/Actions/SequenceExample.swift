import Foundation

public let sequenceJSON = """
{
  "id": "sequence-example",
  "version": "1.0",
  "state": { "step": 0 },
  "styles": {
    "title": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "stepLabel": { "fontSize": 48, "fontWeight": "bold", "textColor": "#007AFF" },
    "button": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#007AFF", "textColor": "#FFFFFF",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 24 }
    }
  },
  "actions": {
    "multiStep": {
      "type": "sequence",
      "steps": [
        { "type": "setState", "path": "step", "value": { "$expr": "${step} + 1" } },
        {
          "type": "showAlert",
          "title": "Step Complete",
          "message": { "type": "binding", "template": "You are now on step ${step}" },
          "buttons": [{ "label": "OK", "style": "default" }]
        }
      ]
    }
  },
  "dataSources": {
    "stepText": { "type": "binding", "template": "Step ${step}" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 24,
      "alignment": "center",
      "children": [
        { "type": "label", "text": "Sequence Actions", "styleId": "title" },
        { "type": "label", "dataSourceId": "stepText", "styleId": "stepLabel" },
        { "type": "button", "text": "Next Step", "styleId": "button", "actions": { "onTap": "multiStep" } }
      ]
    }]
  }
}
"""
