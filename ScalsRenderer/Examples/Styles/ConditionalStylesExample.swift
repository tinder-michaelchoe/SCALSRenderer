import Foundation

public let conditionalStylesJSON = """
{
  "id": "conditionalstyles-example",
  "version": "1.0",
  "state": { "isActive": false },
  "styles": {
    "title": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "normalCard": {
      "backgroundColor": "#F2F2F7", "cornerRadius": 12,
      "padding": { "all": 20 }
    },
    "activeCard": {
      "backgroundColor": "#007AFF", "cornerRadius": 12,
      "padding": { "all": 20 }
    },
    "normalText": { "fontSize": 16, "textColor": "#333333" },
    "activeText": { "fontSize": 16, "fontWeight": "semibold", "textColor": "#FFFFFF" },
    "toggleButton": {
      "fontSize": 16, "fontWeight": "medium",
      "backgroundColor": "#E5E5EA", "textColor": "#000000",
      "cornerRadius": 8, "height": 40, "padding": { "horizontal": 16 }
    },
    "toggleButtonSelected": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#34C759", "textColor": "#FFFFFF",
      "cornerRadius": 8, "height": 40, "padding": { "horizontal": 16 }
    }
  },
  "actions": {
    "toggle": { "type": "toggleState", "path": "isActive" }
  },
  "dataSources": {
    "statusText": { "type": "binding", "template": "${isActive ? 'Card is ACTIVE' : 'Card is inactive'}" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 20,
      "alignment": "center",
      "children": [
        { "type": "label", "text": "Conditional Styles", "styleId": "title" },
        {
          "type": "button",
          "text": "Toggle State",
          "styles": { "normal": "toggleButton", "selected": "toggleButtonSelected" },
          "isSelectedBinding": "isActive",
          "actions": { "onTap": "toggle" }
        },
        { "type": "label", "dataSourceId": "statusText", "styleId": "normalText" }
      ]
    }]
  }
}
"""
