import Foundation

public let staticDataJSON = """
{
  "id": "staticdata-example",
  "version": "1.0",
  "styles": {
    "title": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "label": { "fontSize": 14, "fontWeight": "medium", "textColor": "#888888" },
    "value": { "fontSize": 16, "textColor": "#000000" }
  },
  "dataSources": {
    "appName": { "type": "static", "value": "SCALS Renderer" },
    "version": { "type": "static", "value": "1.0.0" },
    "author": { "type": "static", "value": "Your Name" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 20,
      "alignment": "leading",
      "children": [
        { "type": "label", "text": "Static Data Sources", "styleId": "title" },
        {
          "type": "vstack", "spacing": 4, "alignment": "leading",
          "children": [
            { "type": "label", "text": "App Name", "styleId": "label" },
            { "type": "label", "dataSourceId": "appName", "styleId": "value" }
          ]
        },
        {
          "type": "vstack", "spacing": 4, "alignment": "leading",
          "children": [
            { "type": "label", "text": "Version", "styleId": "label" },
            { "type": "label", "dataSourceId": "version", "styleId": "value" }
          ]
        },
        {
          "type": "vstack", "spacing": 4, "alignment": "leading",
          "children": [
            { "type": "label", "text": "Author", "styleId": "label" },
            { "type": "label", "dataSourceId": "author", "styleId": "value" }
          ]
        }
      ]
    }]
  }
}
"""
