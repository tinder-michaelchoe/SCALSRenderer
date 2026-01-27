import Foundation

public let dismissJSON = """
{
  "id": "dismiss-example",
  "version": "1.0",
  "styles": {
    "title": { "fontSize": 24, "fontWeight": "bold", "textColor": "#000000" },
    "subtitle": { "fontSize": 16, "textColor": "#666666" },
    "button": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#007AFF", "textColor": "#FFFFFF",
      "cornerRadius": 10, "height": 50, "padding": { "horizontal": 32 }
    },
    "successIcon": { "width": 80, "height": 80, "tintColor": "#34C759" }
  },
  "actions": {
    "close": { "type": "dismiss" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 24,
      "alignment": "center",
      "children": [
        { "type": "spacer" },
        { "type": "image", "image": { "sfsymbol": "checkmark.circle.fill" }, "styleId": "successIcon" },
        { "type": "label", "text": "Success!", "styleId": "title" },
        { "type": "label", "text": "Tap the button to dismiss this view", "styleId": "subtitle" },
        { "type": "spacer" },
        { "type": "button", "text": "Done", "styleId": "button", "fillWidth": true, "actions": { "onTap": "close" } }
      ]
    }]
  }
}
"""
