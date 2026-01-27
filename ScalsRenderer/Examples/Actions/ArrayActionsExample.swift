import Foundation

public let arrayActionsJSON = """
{
  "id": "arrayactions-example",
  "version": "1.0",
  "state": { "items": ["Apple", "Banana"], "newItem": "" },
  "styles": {
    "title": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "count": { "fontSize": 14, "textColor": "#666666" },
    "field": {
      "fontSize": 16, "textColor": "#000000",
      "backgroundColor": "#F2F2F7", "cornerRadius": 8,
      "padding": { "horizontal": 12, "vertical": 12 }
    },
    "addButton": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#34C759", "textColor": "#FFFFFF",
      "cornerRadius": 8, "height": 44, "padding": { "horizontal": 16 }
    },
    "removeButton": {
      "fontSize": 14, "fontWeight": "medium",
      "backgroundColor": "#FF3B30", "textColor": "#FFFFFF",
      "cornerRadius": 6, "padding": { "horizontal": 10, "vertical": 6 }
    },
    "itemLabel": { "fontSize": 16, "textColor": "#000000" }
  },
  "actions": {
    "addItem": {
      "type": "sequence",
      "steps": [
        { "type": "appendToArray", "path": "items", "value": { "$expr": "${newItem}" } },
        { "type": "setState", "path": "newItem", "value": "" }
      ]
    }
  },
  "dataSources": {
    "countText": { "type": "binding", "template": "${items.count} items" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 16,
      "alignment": "leading",
      "children": [
        { "type": "label", "text": "Array Actions", "styleId": "title" },
        { "type": "label", "dataSourceId": "countText", "styleId": "count" },
        {
          "type": "hstack", "spacing": 8,
          "children": [
            { "type": "textfield", "placeholder": "New item", "styleId": "field", "bind": "newItem" },
            { "type": "button", "text": "Add", "styleId": "addButton", "actions": { "onTap": "addItem" } }
          ]
        },
        { "type": "label", "text": "Add items above and watch the count update!", "styleId": "count" }
      ]
    }]
  }
}
"""
