import Foundation

public let showAlertJSON = """
{
  "id": "showalert-example",
  "version": "1.0",
  "styles": {
    "title": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "subtitle": { "fontSize": 14, "textColor": "#666666" },
    "button": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#007AFF", "textColor": "#FFFFFF",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 24 }
    },
    "destructiveButton": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#FF3B30", "textColor": "#FFFFFF",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 24 }
    }
  },
  "actions": {
    "simpleAlert": {
      "type": "showAlert",
      "title": "Hello!",
      "message": "This is a simple alert.",
      "buttons": [{ "label": "OK", "style": "default" }]
    },
    "confirmAlert": {
      "type": "showAlert",
      "title": "Confirm Action",
      "message": "Are you sure you want to proceed?",
      "buttons": [
        { "label": "Cancel", "style": "cancel" },
        { "label": "Confirm", "style": "default" }
      ]
    },
    "destructiveAlert": {
      "type": "showAlert",
      "title": "Delete Item?",
      "message": "This action cannot be undone.",
      "buttons": [
        { "label": "Cancel", "style": "cancel" },
        { "label": "Delete", "style": "destructive" }
      ]
    }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 16,
      "alignment": "center",
      "children": [
        { "type": "label", "text": "Alert Examples", "styleId": "title" },
        { "type": "label", "text": "Tap buttons to show different alerts", "styleId": "subtitle" },
        { "type": "button", "text": "Simple Alert", "styleId": "button", "actions": { "onTap": "simpleAlert" } },
        { "type": "button", "text": "Confirmation Alert", "styleId": "button", "actions": { "onTap": "confirmAlert" } },
        { "type": "button", "text": "Destructive Alert", "styleId": "destructiveButton", "actions": { "onTap": "destructiveAlert" } }
      ]
    }]
  }
}
"""
