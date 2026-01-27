import Foundation

public let setStateJSON = """
{
  "id": "setstate-example",
  "version": "1.0",
  "state": { "count": 0, "message": "Hello" },
  "styles": {
    "title": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "value": { "fontSize": 48, "fontWeight": "bold", "textColor": "#007AFF" },
    "button": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#007AFF", "textColor": "#FFFFFF",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 20 }
    }
  },
  "actions": {
    "increment": { "type": "setState", "path": "count", "value": { "$expr": "${count} + 1" } },
    "decrement": { "type": "setState", "path": "count", "value": { "$expr": "${count} - 1" } },
    "reset": { "type": "setState", "path": "count", "value": 0 }
  },
  "dataSources": {
    "countDisplay": { "type": "binding", "template": "${count}" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 24,
      "alignment": "center",
      "children": [
        { "type": "label", "text": "Counter with setState", "styleId": "title" },
        { "type": "label", "dataSourceId": "countDisplay", "styleId": "value" },
        {
          "type": "hstack", "spacing": 12,
          "children": [
            { "type": "button", "text": "-", "styleId": "button", "actions": { "onTap": "decrement" } },
            { "type": "button", "text": "Reset", "styleId": "button", "actions": { "onTap": "reset" } },
            { "type": "button", "text": "+", "styleId": "button", "actions": { "onTap": "increment" } }
          ]
        }
      ]
    }]
  }
}
"""
