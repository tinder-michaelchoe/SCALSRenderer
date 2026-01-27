import Foundation

public let vstackHstackJSON = """
{
  "id": "stacks-example",
  "version": "1.0",
  "styles": {
    "title": { "fontSize": 16, "fontWeight": "semibold", "textColor": "#000000" },
    "box": { "width": 60, "height": 60, "backgroundColor": "#007AFF", "cornerRadius": 8 },
    "boxGreen": { "width": 60, "height": 60, "backgroundColor": "#34C759", "cornerRadius": 8 },
    "boxOrange": { "width": 60, "height": 60, "backgroundColor": "#FF9500", "cornerRadius": 8 },
    "boxLabel": { "fontSize": 12, "fontWeight": "medium", "textColor": "#FFFFFF" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 24,
      "alignment": "leading",
      "children": [
        { "type": "label", "text": "HStack (horizontal)", "styleId": "title" },
        {
          "type": "hstack", "spacing": 12,
          "children": [
            { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" }, { "type": "label", "text": "1", "styleId": "boxLabel" }] },
            { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "boxGreen" }, { "type": "label", "text": "2", "styleId": "boxLabel" }] },
            { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#FF9500", "location": 0}], "styleId": "boxOrange" }, { "type": "label", "text": "3", "styleId": "boxLabel" }] }
          ]
        },
        { "type": "label", "text": "VStack (vertical)", "styleId": "title" },
        {
          "type": "vstack", "spacing": 8,
          "children": [
            { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" }, { "type": "label", "text": "A", "styleId": "boxLabel" }] },
            { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "boxGreen" }, { "type": "label", "text": "B", "styleId": "boxLabel" }] }
          ]
        }
      ]
    }]
  }
}
"""
