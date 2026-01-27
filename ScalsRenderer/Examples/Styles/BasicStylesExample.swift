import Foundation

public let basicStylesJSON = """
{
  "id": "basicstyles-example",
  "version": "1.0",
  "styles": {
    "title": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "large": { "fontSize": 24, "fontWeight": "bold", "textColor": "#000000" },
    "medium": { "fontSize": 16, "fontWeight": "regular", "textColor": "#333333" },
    "small": { "fontSize": 12, "fontWeight": "light", "textColor": "#888888" },
    "colored": { "fontSize": 16, "textColor": "#007AFF" },
    "background": {
      "fontSize": 16, "textColor": "#FFFFFF",
      "backgroundColor": "#FF3B30", "cornerRadius": 8,
      "padding": { "horizontal": 16, "vertical": 8 }
    },
    "rounded": {
      "fontSize": 16, "textColor": "#000000",
      "backgroundColor": "#F2F2F7", "cornerRadius": 20,
      "padding": { "horizontal": 20, "vertical": 10 }
    }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 16,
      "alignment": "leading",
      "children": [
        { "type": "label", "text": "Basic Style Properties", "styleId": "title" },
        { "type": "label", "text": "Large Bold Text", "styleId": "large" },
        { "type": "label", "text": "Medium Regular Text", "styleId": "medium" },
        { "type": "label", "text": "Small Light Text", "styleId": "small" },
        { "type": "label", "text": "Colored Text", "styleId": "colored" },
        { "type": "label", "text": "Background + Corner Radius", "styleId": "background" },
        { "type": "label", "text": "Pill Shape", "styleId": "rounded" }
      ]
    }]
  }
}
"""
