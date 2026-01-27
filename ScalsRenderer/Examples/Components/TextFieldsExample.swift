import Foundation

public let textFieldsJSON = """
{
  "id": "textfields-example",
  "version": "1.0",
  "state": { "name": "", "email": "", "bio": "" },
  "styles": {
    "label": { "fontSize": 14, "fontWeight": "medium", "textColor": "#333333" },
    "field": {
      "fontSize": 16, "textColor": "#000000",
      "backgroundColor": "#F2F2F7", "cornerRadius": 8,
      "padding": { "horizontal": 12, "vertical": 12 }
    },
    "preview": { "fontSize": 13, "textColor": "#888888" }
  },
  "dataSources": {
    "namePreview": { "type": "binding", "template": "Name: ${name}" },
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
        { "type": "label", "text": "Name", "styleId": "label" },
        { "type": "textfield", "placeholder": "Enter your name", "styleId": "field", "bind": "name" },
        { "type": "label", "text": "Email", "styleId": "label" },
        { "type": "textfield", "placeholder": "Enter your email", "styleId": "field", "bind": "email" },
        { "type": "label", "dataSourceId": "namePreview", "styleId": "preview" },
        { "type": "label", "dataSourceId": "emailPreview", "styleId": "preview" }
      ]
    }]
  }
}
"""
