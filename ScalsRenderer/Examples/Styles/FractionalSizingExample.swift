import Foundation

public let fractionalSizingJSON = """
{
  "id": "fractional-sizing-example",
  "version": "1.0",
  "styles": {
    "title": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "subtitle": { "fontSize": 14, "textColor": "#666666" },
    "fullWidth": {
      "width": {"fractional": 1.0},
      "backgroundColor": "#007AFF",
      "cornerRadius": 8,
      "padding": {"vertical": 16}
    },
    "halfWidth": {
      "width": {"fractional": 0.5},
      "backgroundColor": "#34C759",
      "cornerRadius": 8,
      "padding": {"vertical": 16}
    },
    "thirdWidth": {
      "width": {"fractional": 0.33},
      "backgroundColor": "#FF9500",
      "cornerRadius": 8,
      "padding": {"vertical": 16}
    },
    "responsive": {
      "width": {"fractional": 0.8},
      "minWidth": {"absolute": 200},
      "maxWidth": {"absolute": 600},
      "backgroundColor": "#AF52DE",
      "cornerRadius": 8,
      "padding": {"vertical": 16}
    },
    "mixed": {
      "width": {"fractional": 0.9},
      "height": {"absolute": 100},
      "backgroundColor": "#FF2D55",
      "cornerRadius": 8
    },
    "labelWhite": {
      "textColor": "#FFFFFF",
      "fontWeight": "semibold"
    },
    "labelSmall": {
      "textColor": "#FFFFFF",
      "fontSize": 12
    }
  },
  "root": {
    "backgroundColor": "#F5F5F5",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28, "bottom": 36 },
    "children": [{
      "type": "vstack",
      "spacing": 24,
      "alignment": "leading",
      "children": [
        { "type": "label", "text": "Fractional Sizing", "styleId": "title" },
        { "type": "label", "text": "Widths relative to container", "styleId": "subtitle" },

        {
          "type": "vstack",
          "spacing": 12,
          "children": [
            {
              "type": "vstack",
              "styleId": "fullWidth",
              "children": [
                { "type": "label", "text": "100% Width", "styleId": "labelWhite" }
              ]
            },
            {
              "type": "vstack",
              "styleId": "halfWidth",
              "children": [
                { "type": "label", "text": "50% Width", "styleId": "labelWhite" }
              ]
            },
            {
              "type": "hstack",
              "spacing": 8,
              "children": [
                {
                  "type": "vstack",
                  "styleId": "thirdWidth",
                  "children": [
                    { "type": "label", "text": "33%", "styleId": "labelWhite" }
                  ]
                },
                {
                  "type": "vstack",
                  "styleId": "thirdWidth",
                  "children": [
                    { "type": "label", "text": "33%", "styleId": "labelWhite" }
                  ]
                },
                {
                  "type": "vstack",
                  "styleId": "thirdWidth",
                  "children": [
                    { "type": "label", "text": "33%", "styleId": "labelWhite" }
                  ]
                }
              ]
            },
            {
              "type": "vstack",
              "styleId": "responsive",
              "spacing": 4,
              "children": [
                { "type": "label", "text": "Responsive: 80% with min/max", "styleId": "labelWhite" },
                { "type": "label", "text": "Min 200pt, Max 600pt", "styleId": "labelSmall" }
              ]
            },
            {
              "type": "vstack",
              "styleId": "mixed",
              "children": [
                { "type": "label", "text": "Mixed: 90% width, 100pt height", "styleId": "labelWhite" }
              ]
            }
          ]
        }
      ]
    }]
  }
}
"""
