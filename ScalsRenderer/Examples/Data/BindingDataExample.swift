import Foundation

public let bindingDataJSON = """
{
  "id": "bindingdata-example",
  "version": "1.0",
  "state": { "username": "JohnDoe", "email": "john@example.com" },
  "styles": {
    "title": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "label": { "fontSize": 14, "fontWeight": "medium", "textColor": "#888888" },
    "field": {
      "fontSize": 16, "textColor": "#000000",
      "backgroundColor": "#F2F2F7", "cornerRadius": 8,
      "padding": { "horizontal": 12, "vertical": 12 }
    },
    "preview": { "fontSize": 14, "textColor": "#007AFF" }
  },
  "dataSources": {
    "usernamePreview": { "type": "binding", "template": "Username: ${username}" },
    "emailPreview": { "type": "binding", "template": "Email: ${email}" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 16,
      "alignment": "leading",
      "children": [
        { "type": "label", "text": "Two-Way Binding", "styleId": "title" },
        { "type": "label", "text": "Username", "styleId": "label" },
        { "type": "textfield", "styleId": "field", "bind": "username" },
        { "type": "label", "text": "Email", "styleId": "label" },
        { "type": "textfield", "styleId": "field", "bind": "email" },
        { "type": "label", "dataSourceId": "usernamePreview", "styleId": "preview" },
        { "type": "label", "dataSourceId": "emailPreview", "styleId": "preview" }
      ]
    }]
  }
}
"""
