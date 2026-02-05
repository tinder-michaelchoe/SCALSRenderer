import Foundation

public let spacerExampleJSON = """
{
  "id": "spacer-example",
  "version": "1.0",
  "styles": {
    "title": {
      "fontSize": 24,
      "fontWeight": "bold",
      "textColor": "#000000"
    },
    "caption": {
      "fontSize": 14,
      "fontWeight": "regular",
      "textColor": "#666666"
    },
    "box": {
      "backgroundColor": "#007AFF",
      "cornerRadius": 8,
      "padding": { "all": 12 }
    },
    "boxLabel": {
      "fontSize": 14,
      "fontWeight": "semibold",
      "padding": { "all": 12 },
      "textColor": "#FFFFFF",
      "textAlignment": "center"
    },
    "alignmentContainer": {
      "backgroundColor": "#F2F2F7",
      "cornerRadius": 12,
      "padding": { "all": 16 },
      "minHeight": 120
    },
    "verticalAlignmentContainer": {
      "backgroundColor": "#F2F2F7",
      "cornerRadius": 12,
      "padding": { "all": 16 },
      "minHeight": 200
    },
    "alignmentBox": {
      "backgroundColor": "#34C759",
      "cornerRadius": 8,
      "padding": { "vertical": 8, "horizontal": 12 }
    },
    "alignmentLabel": {
      "fontSize": 12,
      "fontWeight": "semibold",
      "textColor": "#FFFFFF",
      "textAlignment": "center"
    },
    "sectionHeader": {
      "fontSize": 18,
      "fontWeight": "bold",
      "textColor": "#000000",
      "padding": { "top": 16, "bottom": 8 }
    }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36 },
    "children": [{
      "type": "sectionLayout",
      "sectionSpacing": 0,
      "sections": [{
        "layout": {
          "type": "list",
          "showsDividers": false,
          "itemSpacing": 16,
          "contentInsets": { "horizontal": 24, "top": 20, "bottom": 40 }
        },
        "header": {
          "type": "label",
          "text": "Spacer Examples",
          "styleId": "title"
        },
        "children": [
        {
          "type": "label",
          "text": "Default Spacer (flexible)",
          "styleId": "caption"
        },
        {
          "type": "hstack",
          "spacing": 8,
          "children": [
            {
              "type": "vstack",
              "styleId": "box",
              "children": [
                { "type": "label", "text": "Left", "styleId": "boxLabel" }
              ]
            },
            { "type": "spacer" },
            {
              "type": "vstack",
              "styleId": "box",
              "children": [
                { "type": "label", "text": "Right", "styleId": "boxLabel" }
              ]
            }
          ]
        },
        {
          "type": "label",
          "text": "With minLength: 100",
          "styleId": "caption"
        },
        {
          "type": "hstack",
          "spacing": 8,
          "children": [
            {
              "type": "vstack",
              "styleId": "box",
              "children": [
                { "type": "label", "text": "Left", "styleId": "boxLabel" }
              ]
            },
            { "type": "spacer", "minLength": 100 },
            {
              "type": "vstack",
              "styleId": "box",
              "children": [
                { "type": "label", "text": "Right", "styleId": "boxLabel" }
              ]
            }
          ]
        },
        {
          "type": "label",
          "text": "Fixed height: 50",
          "styleId": "caption"
        },
        { "type": "spacer", "height": 50 },
        {
          "type": "vstack",
          "styleId": "box",
          "children": [
            { "type": "label", "text": "After fixed spacer", "styleId": "boxLabel" }
          ]
        },
        {
          "type": "label",
          "text": "Fixed width: 100",
          "styleId": "caption"
        },
        {
          "type": "hstack",
          "spacing": 8,
          "children": [
            {
              "type": "vstack",
              "styleId": "box",
              "children": [
                { "type": "label", "text": "Left", "styleId": "boxLabel" }
              ]
            },
            { "type": "spacer", "width": 100 },
            {
              "type": "vstack",
              "styleId": "box",
              "children": [
                { "type": "label", "text": "Right", "styleId": "boxLabel" }
              ]
            }
          ]
        },
        {
          "type": "label",
          "text": "Fixed vertical spacing: 60",
          "styleId": "caption"
        },
        {
          "type": "vstack",
          "spacing": 0,
          "children": [
            {
              "type": "vstack",
              "styleId": "box",
              "children": [
                { "type": "label", "text": "Top", "styleId": "boxLabel" }
              ]
            },
            { "type": "spacer", "height": 60 },
            {
              "type": "vstack",
              "styleId": "box",
              "children": [
                { "type": "label", "text": "Bottom", "styleId": "boxLabel" }
              ]
            }
          ]
        },
        {
          "type": "label",
          "text": "Horizontal Alignment with Spacers",
          "styleId": "sectionHeader"
        },
        {
          "type": "label",
          "text": "Left Alignment (trailing spacer)",
          "styleId": "caption"
        },
        {
          "type": "hstack",
          "spacing": 0,
          "styleId": "alignmentContainer",
          "children": [
            {
              "type": "vstack",
              "styleId": "alignmentBox",
              "children": [
                { "type": "label", "text": "Left", "styleId": "alignmentLabel" }
              ]
            },
            { "type": "spacer" }
          ]
        },
        {
          "type": "label",
          "text": "Center Alignment (spacers on both sides)",
          "styleId": "caption"
        },
        {
          "type": "hstack",
          "spacing": 0,
          "styleId": "alignmentContainer",
          "children": [
            { "type": "spacer" },
            {
              "type": "vstack",
              "styleId": "alignmentBox",
              "children": [
                { "type": "label", "text": "Center", "styleId": "alignmentLabel" }
              ]
            },
            { "type": "spacer" }
          ]
        },
        {
          "type": "label",
          "text": "Right Alignment (leading spacer)",
          "styleId": "caption"
        },
        {
          "type": "hstack",
          "spacing": 0,
          "styleId": "alignmentContainer",
          "children": [
            { "type": "spacer" },
            {
              "type": "vstack",
              "styleId": "alignmentBox",
              "children": [
                { "type": "label", "text": "Right", "styleId": "alignmentLabel" }
              ]
            }
          ]
        },
        {
          "type": "label",
          "text": "Vertical Alignment with Spacers",
          "styleId": "sectionHeader"
        },
        {
          "type": "label",
          "text": "Top Alignment (bottom spacer)",
          "styleId": "caption"
        },
        {
          "type": "vstack",
          "spacing": 0,
          "styleId": "verticalAlignmentContainer",
          "children": [
            {
              "type": "vstack",
              "styleId": "alignmentBox",
              "children": [
                { "type": "label", "text": "Top", "styleId": "alignmentLabel" }
              ]
            },
            { "type": "spacer" }
          ]
        },
        {
          "type": "label",
          "text": "Center Alignment (spacers on top and bottom)",
          "styleId": "caption"
        },
        {
          "type": "vstack",
          "spacing": 0,
          "styleId": "verticalAlignmentContainer",
          "children": [
            { "type": "spacer" },
            {
              "type": "vstack",
              "styleId": "alignmentBox",
              "children": [
                { "type": "label", "text": "Center", "styleId": "alignmentLabel" }
              ]
            },
            { "type": "spacer" }
          ]
        },
        {
          "type": "label",
          "text": "Bottom Alignment (top spacer)",
          "styleId": "caption"
        },
        {
          "type": "vstack",
          "spacing": 0,
          "styleId": "verticalAlignmentContainer",
          "children": [
            { "type": "spacer" },
            {
              "type": "vstack",
              "styleId": "alignmentBox",
              "children": [
                { "type": "label", "text": "Bottom", "styleId": "alignmentLabel" }
              ]
            }
          ]
        },
        {
          "type": "label",
          "text": "Complex Layout (multiple spacers)",
          "styleId": "sectionHeader"
        },
        {
          "type": "label",
          "text": "Distributed spacing",
          "styleId": "caption"
        },
        {
          "type": "hstack",
          "spacing": 0,
          "styleId": "alignmentContainer",
          "children": [
            {
              "type": "vstack",
              "styleId": "alignmentBox",
              "children": [
                { "type": "label", "text": "1", "styleId": "alignmentLabel" }
              ]
            },
            { "type": "spacer" },
            {
              "type": "vstack",
              "styleId": "alignmentBox",
              "children": [
                { "type": "label", "text": "2", "styleId": "alignmentLabel" }
              ]
            },
            { "type": "spacer" },
            {
              "type": "vstack",
              "styleId": "alignmentBox",
              "children": [
                { "type": "label", "text": "3", "styleId": "alignmentLabel" }
              ]
            }
          ]
        }
      ]}]
    }]
  }
}
"""
