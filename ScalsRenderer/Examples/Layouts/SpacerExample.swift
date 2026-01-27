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
      "textColor": "#FFFFFF",
      "textAlignment": "center"
    }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36 },
    "children": [{
      "type": "vstack",
      "spacing": 16,
      "padding": { "horizontal": 24, "vertical": 40 },
      "children": [
        {
          "type": "label",
          "text": "Spacer Examples",
          "styleId": "title"
        },
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
          "text": "Fixed width: 150",
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
            { "type": "spacer", "width": 150 },
            {
              "type": "vstack",
              "styleId": "box",
              "children": [
                { "type": "label", "text": "Right", "styleId": "boxLabel" }
              ]
            }
          ]
        }
      ]
    }]
  }
}
"""
