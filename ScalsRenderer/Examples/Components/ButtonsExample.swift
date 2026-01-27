import Foundation

public let buttonsJSON = """
{
  "id": "buttons-example",
  "version": "1.0",
  "state": { "tapCount": 0 },
  "styles": {
    "sectionTitle": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000", "padding": { "top": 8, "bottom": 8 } },
    "primary": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#007AFF", "textColor": "#FFFFFF",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 20 }
    },
    "secondary": {
      "fontSize": 16, "fontWeight": "medium",
      "backgroundColor": "#E5E5EA", "textColor": "#000000",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 20 }
    },
    "destructive": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#FF3B30", "textColor": "#FFFFFF",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 20 }
    },
    "pill": {
      "fontSize": 14, "fontWeight": "medium",
      "backgroundColor": "#F2F2F7", "textColor": "#000000",
      "cornerRadius": 20, "height": 36, "padding": { "horizontal": 16 }
    },
    "pillSelected": {
      "fontSize": 14, "fontWeight": "semibold",
      "backgroundColor": "#34C759", "textColor": "#FFFFFF",
      "cornerRadius": 20, "height": 36, "padding": { "horizontal": 16 }
    },
    "countLabel": { "fontSize": 14, "textColor": "#666666" }
  },
  "actions": {
    "increment": { "type": "setState", "path": "tapCount", "value": { "$expr": "${tapCount} + 1" } }
  },
  "dataSources": {
    "countText": { "type": "binding", "template": "Tapped ${tapCount} times" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "children": [{
      "type": "sectionLayout",
      "sectionSpacing": 20,
      "sections": [{
        "layout": {
          "type": "list",
          "showsDividers": false,
          "itemSpacing": 20,
          "contentInsets": { "top": 36, "horizontal": 28, "bottom": 20 }
        },
        "children": [
        { "type": "label", "text": "Text Only", "styleId": "sectionTitle" },
        { "type": "button", "text": "Primary Button", "styleId": "primary", "fillWidth": true, "actions": { "onTap": "increment" } },
        { "type": "button", "text": "Secondary Button", "styleId": "secondary", "fillWidth": true, "actions": { "onTap": "increment" } },
        { "type": "button", "text": "Destructive", "styleId": "destructive", "fillWidth": true, "actions": { "onTap": "increment" } },

        { "type": "label", "text": "Image + Text (Leading)", "styleId": "sectionTitle" },
        {
          "type": "vstack", "spacing": 8,
          "children": [
            { "type": "button", "text": "Add Item", "image": { "sfsymbol": "plus" }, "imagePlacement": "leading", "styleId": "primary", "fillWidth": true, "actions": { "onTap": "increment" } },
            { "type": "button", "text": "Edit", "image": { "sfsymbol": "pencil" }, "imagePlacement": "leading", "styleId": "secondary", "fillWidth": true, "actions": { "onTap": "increment" } }
          ]
        },

        { "type": "label", "text": "Image + Text (Trailing)", "styleId": "sectionTitle" },
        {
          "type": "vstack", "spacing": 8,
          "children": [
            { "type": "button", "text": "Settings", "image": { "sfsymbol": "gear" }, "imagePlacement": "trailing", "styleId": "secondary", "fillWidth": true, "actions": { "onTap": "increment" } },
            { "type": "button", "text": "Next", "image": { "sfsymbol": "chevron.right" }, "imagePlacement": "trailing", "styleId": "primary", "fillWidth": true, "actions": { "onTap": "increment" } }
          ]
        },

        { "type": "label", "dataSourceId": "countText", "styleId": "countLabel" }
      ]}]
    }]
  }
}
"""
