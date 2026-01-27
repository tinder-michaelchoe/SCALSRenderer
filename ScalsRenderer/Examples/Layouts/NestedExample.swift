import Foundation

public let nestedJSON = """
{
  "id": "nested-example",
  "version": "1.0",
  "styles": {
    "title": { "fontSize": 16, "fontWeight": "semibold", "textColor": "#000000" },
    "subtitle": { "fontSize": 13, "fontWeight": "regular", "textColor": "#888888" },
    "box": { "width": 60, "height": 60, "cornerRadius": 8 },
    "boxSmall": { "width": 40, "height": 40, "cornerRadius": 6 },
    "boxWide": { "width": 132, "height": 60, "cornerRadius": 8 },
    "boxTall": { "width": 60, "height": 132, "cornerRadius": 8 },
    "boxLabel": { "fontSize": 12, "fontWeight": "medium", "textColor": "#FFFFFF" },
    "boxLabelSmall": { "fontSize": 10, "fontWeight": "medium", "textColor": "#FFFFFF" },
    "overlayCard": { "width": 150, "height": 100, "cornerRadius": 12 },
    "overlayLabel": { "fontSize": 14, "fontWeight": "semibold", "textColor": "#FFFFFF" },
    "badge": { "fontSize": 10, "fontWeight": "bold", "textColor": "#FFFFFF", "backgroundColor": "#FF3B30", "cornerRadius": 8, "padding": { "horizontal": 6, "vertical": 3 } }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36 },
    "children": [{
      "type": "sectionLayout",
      "sectionSpacing": 32,
      "sections": [{
        "id": "nested-content",
        "layout": {
          "type": "list",
          "showsDividers": false,
          "itemSpacing": 24,
          "contentInsets": { "horizontal": 28, "bottom": 36 }
        },
        "header": {
          "type": "label", "text": "Nested Layout Examples", "styleId": "title",
          "padding": { "bottom": 8 }
        },
        "children": [
          {
            "type": "vstack",
            "spacing": 12,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "1. VStack with nested HStack", "styleId": "subtitle" },
              {
                "type": "vstack",
                "spacing": 12,
                "children": [
                  { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" }, { "type": "label", "text": "1", "styleId": "boxLabel" }] },
                  {
                    "type": "hstack",
                    "spacing": 12,
                    "children": [
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#34C759", "location": 0}], "styleId": "box" }, { "type": "label", "text": "2A", "styleId": "boxLabel" }] },
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#FF9500", "location": 0}], "styleId": "box" }, { "type": "label", "text": "2B", "styleId": "boxLabel" }] }
                    ]
                  }
                ]
              }
            ]
          },

          {
            "type": "vstack",
            "spacing": 12,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "2. HStack with nested VStacks", "styleId": "subtitle" },
              {
                "type": "hstack",
                "spacing": 12,
                "children": [
                  {
                    "type": "vstack",
                    "spacing": 8,
                    "children": [
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#AF52DE", "location": 0}], "styleId": "box" }, { "type": "label", "text": "A1", "styleId": "boxLabel" }] },
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#5856D6", "location": 0}], "styleId": "box" }, { "type": "label", "text": "A2", "styleId": "boxLabel" }] }
                    ]
                  },
                  {
                    "type": "vstack",
                    "spacing": 8,
                    "children": [
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#FF2D55", "location": 0}], "styleId": "box" }, { "type": "label", "text": "B1", "styleId": "boxLabel" }] },
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#FF6B6B", "location": 0}], "styleId": "box" }, { "type": "label", "text": "B2", "styleId": "boxLabel" }] }
                    ]
                  },
                  {
                    "type": "vstack",
                    "spacing": 8,
                    "children": [
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#00C7BE", "location": 0}], "styleId": "box" }, { "type": "label", "text": "C1", "styleId": "boxLabel" }] },
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#30B0C7", "location": 0}], "styleId": "box" }, { "type": "label", "text": "C2", "styleId": "boxLabel" }] }
                    ]
                  }
                ]
              }
            ]
          },

          {
            "type": "vstack",
            "spacing": 12,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "3. ZStack with nested HStack & VStack", "styleId": "subtitle" },
              {
                "type": "zstack",
                "alignment": "topTrailing",
                "children": [
                  {
                    "type": "gradient",
                    "gradientColors": [
                      { "color": "#667eea", "location": 0.0 },
                      { "color": "#764ba2", "location": 1.0 }
                    ],
                    "gradientStart": "topLeading", "gradientEnd": "bottomTrailing",
                    "styleId": "overlayCard"
                  },
                  {
                    "type": "vstack",
                    "spacing": 4,
                    "padding": { "all": 12 },
                    "children": [
                      { "type": "label", "text": "Card Title", "styleId": "overlayLabel" },
                      {
                        "type": "hstack",
                        "spacing": 8,
                        "children": [
                          { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#FFFFFF33", "location": 0}], "styleId": "boxSmall" }, { "type": "label", "text": "1", "styleId": "boxLabelSmall" }] },
                          { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#FFFFFF33", "location": 0}], "styleId": "boxSmall" }, { "type": "label", "text": "2", "styleId": "boxLabelSmall" }] },
                          { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#FFFFFF33", "location": 0}], "styleId": "boxSmall" }, { "type": "label", "text": "3", "styleId": "boxLabelSmall" }] }
                        ]
                      }
                    ]
                  },
                  { "type": "label", "text": "NEW", "styleId": "badge" }
                ]
              }
            ]
          },

          {
            "type": "vstack",
            "spacing": 12,
            "alignment": "leading",
            "children": [
              { "type": "label", "text": "4. Complex grid using nested stacks", "styleId": "subtitle" },
              {
                "type": "vstack",
                "spacing": 8,
                "children": [
                  {
                    "type": "hstack",
                    "spacing": 8,
                    "children": [
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#FF9500", "location": 0}, {"color": "#FF5E3A", "location": 1}], "gradientStart": "top", "gradientEnd": "bottom", "styleId": "boxWide" }, { "type": "label", "text": "Wide", "styleId": "boxLabel" }] },
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#4CD964", "location": 0}], "styleId": "box" }, { "type": "label", "text": "Sq", "styleId": "boxLabel" }] }
                    ]
                  },
                  {
                    "type": "hstack",
                    "spacing": 8,
                    "children": [
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#007AFF", "location": 0}], "styleId": "box" }, { "type": "label", "text": "A", "styleId": "boxLabel" }] },
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#5856D6", "location": 0}], "styleId": "box" }, { "type": "label", "text": "B", "styleId": "boxLabel" }] },
                      { "type": "zstack", "children": [{ "type": "gradient", "gradientColors": [{"color": "#FF2D55", "location": 0}], "styleId": "box" }, { "type": "label", "text": "C", "styleId": "boxLabel" }] }
                    ]
                  }
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
