import Foundation

public let alignmentJSON = """
{
  "id": "alignment-example",
  "version": "1.0",
  "styles": {
    "sectionTitle": { "fontSize": 14, "fontWeight": "semibold", "textColor": "#000000", "padding": { "bottom": 8 } },
    "alignmentLabel": { "fontSize": 11, "fontWeight": "medium", "textColor": "#666666" },
    "box": { "width": 60, "height": 60, "backgroundColor": "#007AFF", "cornerRadius": 8 },
    "boxSmall": { "width": 40, "height": 40, "backgroundColor": "#34C759", "cornerRadius": 6 },
    "boxWide": { "width": 120, "height": 40, "backgroundColor": "#FF9500", "cornerRadius": 8 },
    "boxTall": { "width": 40, "height": 80, "backgroundColor": "#FF2D55", "cornerRadius": 8 },
    "containerBg": { "backgroundColor": "#F2F2F7", "cornerRadius": 12, "padding": { "all": 16 }, "minHeight": 120 }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36 },
    "children": [{
      "type": "sectionLayout",
      "sectionSpacing": 24,
      "sections": [{
        "id": "alignment-examples",
        "layout": {
          "type": "list",
          "showsDividers": false,
          "itemSpacing": 24,
          "contentInsets": { "horizontal": 28, "bottom": 36 }
        },
        "header": {
          "type": "label",
          "text": "Container Alignment Examples",
          "styleId": "sectionTitle"
        },
        "children": [
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "VStack - Leading Alignment", "styleId": "alignmentLabel" },
              {
                "type": "vstack",
                "spacing": 8,
                "alignment": "leading",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "boxWide" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#FF9500", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "VStack - Center Alignment", "styleId": "alignmentLabel" },
              {
                "type": "vstack",
                "spacing": 8,
                "alignment": "center",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "boxWide" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#FF9500", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "VStack - Trailing Alignment", "styleId": "alignmentLabel" },
              {
                "type": "vstack",
                "spacing": 8,
                "alignment": "trailing",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "boxWide" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#FF9500", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "HStack - Top Alignment", "styleId": "alignmentLabel" },
              {
                "type": "hstack",
                "spacing": 8,
                "alignment": "top",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "boxTall" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#FF9500", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "HStack - Center Alignment", "styleId": "alignmentLabel" },
              {
                "type": "hstack",
                "spacing": 8,
                "alignment": "center",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "boxTall" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#FF9500", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "HStack - Bottom Alignment", "styleId": "alignmentLabel" },
              {
                "type": "hstack",
                "spacing": 8,
                "alignment": "bottom",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "boxTall" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#FF9500", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "ZStack - Top Leading", "styleId": "alignmentLabel" },
              {
                "type": "zstack",
                "alignment": "topLeading",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "ZStack - Top", "styleId": "alignmentLabel" },
              {
                "type": "zstack",
                "alignment": "top",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "ZStack - Top Trailing", "styleId": "alignmentLabel" },
              {
                "type": "zstack",
                "alignment": "topTrailing",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "ZStack - Leading", "styleId": "alignmentLabel" },
              {
                "type": "zstack",
                "alignment": "leading",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "ZStack - Center", "styleId": "alignmentLabel" },
              {
                "type": "zstack",
                "alignment": "center",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "ZStack - Trailing", "styleId": "alignmentLabel" },
              {
                "type": "zstack",
                "alignment": "trailing",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "ZStack - Bottom Leading", "styleId": "alignmentLabel" },
              {
                "type": "zstack",
                "alignment": "bottomLeading",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "ZStack - Bottom", "styleId": "alignmentLabel" },
              {
                "type": "zstack",
                "alignment": "bottom",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 8,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "ZStack - Bottom Trailing", "styleId": "alignmentLabel" },
              {
                "type": "zstack",
                "alignment": "bottomTrailing",
                "styleId": "containerBg",
                "children": [
                  { "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" },
                  { "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "boxSmall" }
                ]
              }
            ]
          }
        ]
      }]
    }]
  }
}
"""
