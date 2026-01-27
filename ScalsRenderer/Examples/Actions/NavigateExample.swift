import Foundation

public let navigateJSON = """
{
  "id": "navigate-example",
  "version": "1.0",
  "styles": {
    "title": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "subtitle": { "fontSize": 14, "textColor": "#666666" },
    "row": { "padding": { "vertical": 16 } },
    "rowTitle": { "fontSize": 16, "textColor": "#000000" },
    "rowIcon": { "width": 24, "height": 24, "tintColor": "#007AFF" },
    "chevron": { "width": 16, "height": 16, "tintColor": "#C7C7CC" }
  },
  "actions": {
    "goToProfile": { "type": "navigate", "destination": "profile" },
    "goToSettings": { "type": "navigate", "destination": "settings" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 16,
      "alignment": "leading",
      "children": [
        { "type": "label", "text": "Navigation Actions", "styleId": "title" },
        { "type": "label", "text": "Navigate action pushes a new destination", "styleId": "subtitle" },
        {
          "type": "button", "styleId": "row",
          "actions": { "onTap": "goToProfile" },
          "children": [{
            "type": "hstack",
            "children": [
              { "type": "image", "image": { "sfsymbol": "person.circle" }, "styleId": "rowIcon" },
              { "type": "label", "text": "Go to Profile", "styleId": "rowTitle", "padding": { "leading": 12 } },
              { "type": "spacer" },
              { "type": "image", "image": { "sfsymbol": "chevron.right" }, "styleId": "chevron" }
            ]
          }]
        },
        {
          "type": "button", "styleId": "row",
          "actions": { "onTap": "goToSettings" },
          "children": [{
            "type": "hstack",
            "children": [
              { "type": "image", "image": { "sfsymbol": "gear" }, "styleId": "rowIcon" },
              { "type": "label", "text": "Go to Settings", "styleId": "rowTitle", "padding": { "leading": 12 } },
              { "type": "spacer" },
              { "type": "image", "image": { "sfsymbol": "chevron.right" }, "styleId": "chevron" }
            ]
          }]
        }
      ]
    }]
  }
}
"""
