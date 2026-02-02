import Foundation

public let shadowsJSON = """
{
  "id": "shadows-example",
  "version": "1.0",
  "styles": {
    "title": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "card": {
      "backgroundColor": "#FFFFFF",
      "cornerRadius": 12,
      "width": { "fractional": 0.8 },
      "padding": { "horizontal": 16, "vertical": 24 }
    },
    "subtle": {
      "inherits": "card",
      "shadow": {
        "color": "rgba(0, 0, 0, 0.08)",
        "radius": 4,
        "x": 0,
        "y": 2
      }
    },
    "elevated": {
      "inherits": "card",
      "shadow": {
        "color": "rgba(0, 0, 0, 0.12)",
        "radius": 8,
        "x": 0,
        "y": 4
      }
    },
    "dramatic": {
      "inherits": "card",
      "shadow": {
        "color": "rgba(0, 0, 0, 0.2)",
        "radius": 16,
        "x": 0,
        "y": 8
      }
    },
    "offset": {
      "inherits": "card",
      "shadow": {
        "color": "rgba(0, 0, 0, 0.15)",
        "radius": 8,
        "x": 4,
        "y": 4
      }
    },
    "negative-offset": {
      "inherits": "card",
      "shadow": {
        "color": "rgba(0, 0, 0, 0.15)",
        "radius": 8,
        "x": -4,
        "y": -4
      }
    },
    "colored-shadow": {
      "inherits": "card",
      "backgroundColor": "#007AFF",
      "shadow": {
        "color": "rgba(0, 122, 255, 0.5)",
        "radius": 12,
        "x": 0,
        "y": 6
      }
    },
    "no-shadow": {
      "inherits": "elevated",
      "shadow": {}
    }
  },
  "root": {
    "backgroundColor": "#F5F5F5",
    "children": [{
      "type": "sectionLayout",
      "sections": [
        {
          "layout": {
            "type": "list",
            "itemSpacing": 20,
            "contentInsets": { "horizontal": 48, "vertical": 20 }
          },
          "header": {
            "type": "label",
            "text": "Shadow Examples",
            "styleId": "title",
            "padding": { "horizontal": 28, "top": 36, "bottom": 16 }
          },
          "children": [
            {
              "type": "vstack",
              "styleId": "subtle",
              "children": [
                { "type": "label", "text": "Subtle Shadow", "style": { "fontWeight": "semibold" } },
                { "type": "label", "text": "Light shadow for subtle depth", "style": { "fontSize": 12, "textColor": "#666666" } }
              ]
            },
            {
              "type": "vstack",
              "styleId": "elevated",
              "children": [
                { "type": "label", "text": "Elevated Shadow", "style": { "fontWeight": "semibold" } },
                { "type": "label", "text": "Medium shadow for raised elements", "style": { "fontSize": 12, "textColor": "#666666" } }
              ]
            },
            {
              "type": "vstack",
              "styleId": "dramatic",
              "children": [
                { "type": "label", "text": "Dramatic Shadow", "style": { "fontWeight": "semibold" } },
                { "type": "label", "text": "Deep shadow for prominent cards", "style": { "fontSize": 12, "textColor": "#666666" } }
              ]
            },
            {
              "type": "vstack",
              "styleId": "offset",
              "children": [
                { "type": "label", "text": "Offset Shadow", "style": { "fontWeight": "semibold" } },
                { "type": "label", "text": "Shadow with horizontal and vertical offset", "style": { "fontSize": 12, "textColor": "#666666" } }
              ]
            },
            {
              "type": "vstack",
              "styleId": "negative-offset",
              "children": [
                { "type": "label", "text": "Negative Offset Shadow", "style": { "fontWeight": "semibold" } },
                { "type": "label", "text": "Shadow offset to top-left", "style": { "fontSize": 12, "textColor": "#666666" } }
              ]
            },
            {
              "type": "vstack",
              "styleId": "colored-shadow",
              "children": [
                { "type": "label", "text": "Colored Shadow", "style": { "fontWeight": "semibold", "textColor": "#FFFFFF" } },
                { "type": "label", "text": "Blue shadow matching the card color", "style": { "fontSize": 12, "textColor": "rgba(255, 255, 255, 0.8)" } }
              ]
            },
            {
              "type": "vstack",
              "styleId": "no-shadow",
              "children": [
                { "type": "label", "text": "No Shadow", "style": { "fontWeight": "semibold" } },
                { "type": "label", "text": "Inherits from elevated but removes shadow", "style": { "fontSize": 12, "textColor": "#666666" } }
              ]
            }
          ]
        }
      ]
    }]
  }
}
"""
