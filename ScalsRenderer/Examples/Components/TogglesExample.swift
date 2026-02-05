import Foundation

public let togglesJSON = """
{
  "id": "toggles-example",
  "version": "1.0",
  "state": { "notifications": true, "darkMode": false, "autoSave": true },
  "styles": {
    "rowLabel": { "fontSize": 16, "textColor": "#000000" },
    "greenTint": { "tintColor": "#34C759" },
    "purpleTint": { "tintColor": "#AF52DE" },
    "orangeTint": { "tintColor": "#FF9500" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 24,
      "children": [
        {
          "type": "hstack",
          "children": [
            { "type": "label", "text": "Notifications", "styleId": "rowLabel" },
            { "type": "spacer" },
            { "type": "toggle", "bind": "notifications", "styleId": "greenTint" }
          ]
        },
        {
          "type": "hstack",
          "children": [
            { "type": "label", "text": "Dark Mode", "styleId": "rowLabel" },
            { "type": "spacer" },
            { "type": "toggle", "bind": "darkMode", "styleId": "purpleTint" }
          ]
        },
        {
          "type": "hstack",
          "children": [
            { "type": "label", "text": "Auto Save", "styleId": "rowLabel" },
            { "type": "spacer" },
            { "type": "toggle", "bind": "autoSave", "styleId": "orangeTint" }
          ]
        },
        { "type": "spacer" }
      ]
    }]
  }
}
"""
