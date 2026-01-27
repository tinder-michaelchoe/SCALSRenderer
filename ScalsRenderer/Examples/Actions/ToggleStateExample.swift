import Foundation

public let toggleStateJSON = """
{
  "id": "togglestate-example",
  "version": "1.0",
  "state": { "isOn": false },
  "styles": {
    "title": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "status": { "fontSize": 24, "fontWeight": "semibold" },
    "buttonOff": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#8E8E93", "textColor": "#FFFFFF",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 24 }
    },
    "buttonOn": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#34C759", "textColor": "#FFFFFF",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 24 }
    }
  },
  "actions": {
    "toggle": { "type": "toggleState", "path": "isOn" }
  },
  "dataSources": {
    "statusText": { "type": "binding", "template": "${isOn ? 'ON' : 'OFF'}" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 24,
      "alignment": "center",
      "children": [
        { "type": "label", "text": "Toggle State Action", "styleId": "title" },
        { "type": "label", "dataSourceId": "statusText", "styleId": "status" },
        {
          "type": "button",
          "text": "Toggle",
          "styles": { "normal": "buttonOff", "selected": "buttonOn" },
          "isSelectedBinding": "isOn",
          "actions": { "onTap": "toggle" }
        }
      ]
    }]
  }
}
"""
