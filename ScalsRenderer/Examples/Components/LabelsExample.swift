import Foundation

public let labelsJSON = """
{
  "id": "labels-example",
  "version": "1.0",
  "styles": {
    "title": { "fontSize": 24, "fontWeight": "bold", "textColor": "#000000" },
    "body": { "fontSize": 16, "fontWeight": "regular", "textColor": "#333333" },
    "caption": { "fontSize": 12, "fontWeight": "light", "textColor": "#888888" },
    "centered": { "fontSize": 16, "textAlignment": "center", "textColor": "#007AFF" },
    "multiline": { "fontSize": 14, "textColor": "#333333", "numberOfLines": 3 }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 16,
      "alignment": "leading",
      "children": [
        { "type": "label", "text": "Title Label", "styleId": "title" },
        { "type": "label", "text": "Body text with regular weight and dark gray color.", "styleId": "body" },
        { "type": "label", "text": "Caption - smaller and lighter", "styleId": "caption" },
        { "type": "hstack", "children": [{ "type": "spacer" }, { "type": "label", "text": "Centered Text", "styleId": "centered" }, { "type": "spacer" }] },
        { "type": "label", "text": "This is a multiline label that can wrap to multiple lines when the text is too long to fit on a single line.", "styleId": "multiline" }
      ]
    }]
  }
}
"""
