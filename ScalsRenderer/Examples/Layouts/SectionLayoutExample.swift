import Foundation

public let sectionLayoutJSON = """
{
  "id": "section-layout-demo",
  "version": "1.0",

  "actions": {
    "dismissView": {
      "type": "dismiss"
    }
  },

  "styles": {
    "screenTitle": {
      "fontSize": 34,
      "fontWeight": "bold",
      "textColor": "#000000"
    },
    "sectionHeader": {
      "fontSize": 22,
      "fontWeight": "bold",
      "textColor": "#000000"
    },
    "closeButton": {
      "fontSize": 17,
      "fontWeight": "medium",
      "textColor": "#007AFF"
    },
    "cardTitle": {
      "fontSize": 16,
      "fontWeight": "semibold",
      "textColor": "#000000"
    },
    "cardSubtitle": {
      "fontSize": 14,
      "fontWeight": "regular",
      "textColor": "#666666"
    },
    "horizontalCard": {
      "width": 150,
      "height": 100,
      "backgroundColor": "#E8E8ED",
      "cornerRadius": 12
    },
    "gridCard": {
      "height": 120,
      "backgroundColor": "#E8E8ED",
      "cornerRadius": 12
    },
    "listItem": {
      "height": 60
    }
  },

  "root": {
    "backgroundColor": "#FFFFFF",
    "colorScheme": "system",
    "children": [
      {
        "type": "hstack",
        "padding": { "horizontal": 16, "top": 16 },
        "children": [
          { "type": "spacer" },
          {
            "type": "button",
            "text": "Close",
            "styleId": "closeButton",
            "actions": { "onTap": "dismissView" }
          }
        ]
      },
      {
        "type": "hstack",
        "padding": { "horizontal": 16, "bottom": 8 },
        "children": [
          { "type": "label", "text": "Section Layouts", "styleId": "screenTitle" }
        ]
      },
      {
        "type": "sectionLayout",
        "id": "main-sections",
        "sectionSpacing": 24,
        "sections": [
          {
            "id": "horizontal-section",
            "layout": {
              "type": "horizontal",
              "itemSpacing": 12,
              "contentInsets": { "leading": 16, "trailing": 16 },
              "showsIndicators": false
            },
            "header": {
              "type": "vstack",
              "alignment": "leading",
              "padding": { "horizontal": 16, "top": 8, "bottom": 8 },
              "children": [
                { "type": "label", "text": "Horizontal Scroll", "styleId": "sectionHeader" }
              ]
            },
            "children": [
              {
                "type": "vstack",
                "spacing": 4,
                "children": [
                  { "type": "label", "text": "Item 1", "styleId": "cardTitle" },
                  { "type": "label", "text": "Description", "styleId": "cardSubtitle" }
                ]
              },
              {
                "type": "vstack",
                "spacing": 4,
                "children": [
                  { "type": "label", "text": "Item 2", "styleId": "cardTitle" },
                  { "type": "label", "text": "Description", "styleId": "cardSubtitle" }
                ]
              },
              {
                "type": "vstack",
                "spacing": 4,
                "children": [
                  { "type": "label", "text": "Item 3", "styleId": "cardTitle" },
                  { "type": "label", "text": "Description", "styleId": "cardSubtitle" }
                ]
              },
              {
                "type": "vstack",
                "spacing": 4,
                "children": [
                  { "type": "label", "text": "Item 4", "styleId": "cardTitle" },
                  { "type": "label", "text": "Description", "styleId": "cardSubtitle" }
                ]
              },
              {
                "type": "vstack",
                "spacing": 4,
                "children": [
                  { "type": "label", "text": "Item 5", "styleId": "cardTitle" },
                  { "type": "label", "text": "Description", "styleId": "cardSubtitle" }
                ]
              }
            ]
          },
          {
            "id": "grid-section",
            "layout": {
              "type": "grid",
              "columns": 2,
              "itemSpacing": 12,
              "lineSpacing": 12,
              "contentInsets": { "horizontal": 16 }
            },
            "header": {
              "type": "vstack",
              "alignment": "leading",
              "padding": { "horizontal": 16, "bottom": 8 },
              "children": [
                { "type": "label", "text": "Grid Layout", "styleId": "sectionHeader" }
              ]
            },
            "children": [
              { "type": "label", "text": "Grid Item 1", "styleId": "cardTitle" },
              { "type": "label", "text": "Grid Item 2", "styleId": "cardTitle" },
              { "type": "label", "text": "Grid Item 3", "styleId": "cardTitle" },
              { "type": "label", "text": "Grid Item 4", "styleId": "cardTitle" }
            ]
          },
          {
            "id": "list-section",
            "layout": {
              "type": "list",
              "itemSpacing": 0,
              "showsDividers": true,
              "contentInsets": { "horizontal": 16 }
            },
            "header": {
              "type": "vstack",
              "alignment": "leading",
              "padding": { "horizontal": 16, "bottom": 8 },
              "children": [
                { "type": "label", "text": "List Layout", "styleId": "sectionHeader" }
              ]
            },
            "children": [
              {
                "type": "hstack",
                "spacing": 12,
                "padding": { "vertical": 12 },
                "children": [
                  { "type": "label", "text": "List Item 1", "styleId": "cardTitle" },
                  { "type": "spacer" }
                ]
              },
              {
                "type": "hstack",
                "spacing": 12,
                "padding": { "vertical": 12 },
                "children": [
                  { "type": "label", "text": "List Item 2", "styleId": "cardTitle" },
                  { "type": "spacer" }
                ]
              },
              {
                "type": "hstack",
                "spacing": 12,
                "padding": { "vertical": 12 },
                "children": [
                  { "type": "label", "text": "List Item 3", "styleId": "cardTitle" },
                  { "type": "spacer" }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
}
"""
