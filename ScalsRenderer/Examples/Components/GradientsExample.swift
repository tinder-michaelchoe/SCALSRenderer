import Foundation

public let gradientsJSON = """
{
  "id": "gradients-example",
  "version": "1.0",
  "styles": {
    "gradientBox": { "width": 280, "height": 80, "cornerRadius": 12 },
    "gradientLabel": { "fontSize": 14, "fontWeight": "semibold", "textColor": "#FFFFFF" },
    "caption": { "fontSize": 12, "textColor": "#888888" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 20,
      "alignment": "center",
      "children": [
        {
          "type": "zstack",
          "children": [
            {
              "type": "gradient",
              "gradientColors": [
                { "color": "#FF6B6B", "location": 0.0 },
                { "color": "#4ECDC4", "location": 1.0 }
              ],
              "gradientStart": "leading", "gradientEnd": "trailing",
              "styleId": "gradientBox"
            },
            { "type": "label", "text": "Horizontal Gradient", "styleId": "gradientLabel" }
          ]
        },
        {
          "type": "zstack",
          "children": [
            {
              "type": "gradient",
              "gradientColors": [
                { "color": "#667eea", "location": 0.0 },
                { "color": "#764ba2", "location": 1.0 }
              ],
              "gradientStart": "top", "gradientEnd": "bottom",
              "styleId": "gradientBox"
            },
            { "type": "label", "text": "Vertical Gradient", "styleId": "gradientLabel" }
          ]
        },
        {
          "type": "zstack",
          "children": [
            {
              "type": "gradient",
              "gradientColors": [
                { "color": "#f093fb", "location": 0.0 },
                { "color": "#f5576c", "location": 0.5 },
                { "color": "#4facfe", "location": 1.0 }
              ],
              "gradientStart": "topLeading", "gradientEnd": "bottomTrailing",
              "styleId": "gradientBox"
            },
            { "type": "label", "text": "Multi-stop Diagonal", "styleId": "gradientLabel" }
          ]
        }
      ]
    }]
  }
}
"""
