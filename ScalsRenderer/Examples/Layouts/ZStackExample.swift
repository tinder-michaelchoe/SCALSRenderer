import Foundation

public let zstackJSON = """
{
  "id": "zstack-example",
  "version": "1.0",
  "styles": {
    "title": { "fontSize": 16, "fontWeight": "semibold", "textColor": "#000000" },
    "bgGradient": { "width": 200, "height": 120, "cornerRadius": 16 },
    "overlayText": { "fontSize": 20, "fontWeight": "bold", "textColor": "#FFFFFF" },
    "badge": {
      "fontSize": 12, "fontWeight": "bold", "textColor": "#FFFFFF",
      "backgroundColor": "#FF3B30", "cornerRadius": 10,
      "padding": { "horizontal": 8, "vertical": 4 }
    }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 24,
      "alignment": "center",
      "children": [
        { "type": "label", "text": "Layered content with ZStack", "styleId": "title" },
        {
          "type": "zstack",
          "children": [
            {
              "type": "gradient",
              "gradientColors": [
                { "color": "#667eea", "location": 0.0 },
                { "color": "#764ba2", "location": 1.0 }
              ],
              "gradientStart": "topLeading", "gradientEnd": "bottomTrailing",
              "styleId": "bgGradient"
            },
            { "type": "label", "text": "Overlay Text", "styleId": "overlayText" }
          ]
        },
        {
          "type": "zstack",
          "alignment": "topTrailing",
          "children": [
            {
              "type": "gradient",
              "gradientColors": [
                { "color": "#11998e", "location": 0.0 },
                { "color": "#38ef7d", "location": 1.0 }
              ],
              "styleId": "bgGradient"
            },
            { "type": "label", "text": "NEW", "styleId": "badge" }
          ]
        }
      ]
    }]
  }
}
"""
