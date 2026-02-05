import Foundation

public let shapesJSON = """
{
  "id": "shapes-example",
  "version": "1.0",
  "styles": {
    "showcaseTitle": { "fontSize": 28, "fontWeight": "bold", "textColor": "#000000", "padding": { "bottom": 4 } },
    "sectionTitle": { "fontSize": 16, "fontWeight": "semibold", "textColor": "#000000", "padding": { "bottom": 12 } },
    "shapeLabel": { "fontSize": 12, "textColor": "#666666" },
    "filledRed": { "width": 60, "height": 60, "backgroundColor": "#FF6B6B" },
    "filledBlue": { "width": 60, "height": 60, "backgroundColor": "#4ECDC4" },
    "filledGreen": { "width": 60, "height": 60, "backgroundColor": "#95E1D3" },
    "filledOrange": { "width": 80, "height": 40, "backgroundColor": "#FFA07A" },
    "filledPurple": { "width": 70, "height": 50, "backgroundColor": "#DDA0DD" },
    "strokedRed": { "width": 60, "height": 60, "borderColor": "#FF6B6B", "borderWidth": 3 },
    "strokedBlue": { "width": 60, "height": 60, "borderColor": "#4ECDC4", "borderWidth": 3 },
    "strokedGreen": { "width": 60, "height": 60, "borderColor": "#95E1D3", "borderWidth": 3 },
    "strokedOrange": { "width": 80, "height": 40, "borderColor": "#FFA07A", "borderWidth": 3 },
    "strokedPurple": { "width": 70, "height": 50, "borderColor": "#DDA0DD", "borderWidth": 3 },
    "cardBackground": { "backgroundColor": "#F2F2F7", "cornerRadius": 16, "padding": { "all": 20 } },
    "cardTitle": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "cardBody": { "fontSize": 14, "textColor": "#666666" },
    "layer1": { "width": 120, "height": 120, "backgroundColor": "#C8C8FF80" },
    "layer2": { "width": 80, "height": 80, "backgroundColor": "#FFC8C8B3" },
    "overlayText": { "fontSize": 16, "fontWeight": "bold", "textColor": "#FFFFFF" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 56 },
    "children": [{
      "type": "sectionLayout",
      "sections": [{
        "layout": {
          "type": "list",
          "showsDividers": false,
          "itemSpacing": 20,
          "contentInsets": { "horizontal": 20, "top": 12, "bottom": 36 }
        },
        "header": { "type": "label", "text": "Shapes Showcase", "styleId": "showcaseTitle" },
        "children": [
          { "type": "label", "text": "Filled Shapes", "fontSize": 14, "fontWeight": "medium", "textColor": "#333333" },
        {
          "type": "hstack",
          "spacing": 12,
          "children": [
            {
              "type": "vstack",
              "spacing": 4,
              "children": [
                { "type": "shape", "shapeType": "rectangle", "styleId": "filledRed" },
                { "type": "label", "text": "Rectangle", "styleId": "shapeLabel" }
              ]
            },
            {
              "type": "vstack",
              "spacing": 4,
              "children": [
                { "type": "shape", "shapeType": "circle", "styleId": "filledBlue" },
                { "type": "label", "text": "Circle", "styleId": "shapeLabel" }
              ]
            },
            {
              "type": "vstack",
              "spacing": 4,
              "children": [
                { "type": "shape", "shapeType": "roundedRectangle", "cornerRadius": 12, "styleId": "filledGreen" },
                { "type": "label", "text": "Rounded", "styleId": "shapeLabel" }
              ]
            }
          ]
        },
        {
          "type": "hstack",
          "spacing": 12,
          "children": [
            {
              "type": "vstack",
              "spacing": 4,
              "children": [
                { "type": "shape", "shapeType": "capsule", "styleId": "filledOrange" },
                { "type": "label", "text": "Capsule", "styleId": "shapeLabel" }
              ]
            },
            {
              "type": "vstack",
              "spacing": 4,
              "children": [
                { "type": "shape", "shapeType": "ellipse", "styleId": "filledPurple" },
                { "type": "label", "text": "Ellipse", "styleId": "shapeLabel" }
              ]
            }
          ]
        },

        { "type": "divider", "padding": { "vertical": 8 } },

        { "type": "label", "text": "Stroked Shapes", "fontSize": 14, "fontWeight": "medium", "textColor": "#333333" },
        {
          "type": "hstack",
          "spacing": 12,
          "children": [
            {
              "type": "vstack",
              "spacing": 4,
              "children": [
                { "type": "shape", "shapeType": "rectangle", "styleId": "strokedRed" },
                { "type": "label", "text": "Rectangle", "styleId": "shapeLabel" }
              ]
            },
            {
              "type": "vstack",
              "spacing": 4,
              "children": [
                { "type": "shape", "shapeType": "circle", "styleId": "strokedBlue" },
                { "type": "label", "text": "Circle", "styleId": "shapeLabel" }
              ]
            },
            {
              "type": "vstack",
              "spacing": 4,
              "children": [
                { "type": "shape", "shapeType": "roundedRectangle", "cornerRadius": 12, "styleId": "strokedGreen" },
                { "type": "label", "text": "Rounded", "styleId": "shapeLabel" }
              ]
            }
          ]
        },

        { "type": "divider", "padding": { "vertical": 8 } },

        { "type": "label", "text": "Container Backgrounds", "fontSize": 14, "fontWeight": "medium", "textColor": "#333333" },
        {
          "type": "vstack",
          "styleId": "cardBackground",
          "padding": { "all": 16 },
          "spacing": 8,
          "children": [
            { "type": "label", "text": "Card with Background", "styleId": "cardTitle" },
            { "type": "label", "text": "VStack now supports backgroundColor, cornerRadius, and borders!", "styleId": "cardBody" }
          ]
        },

        { "type": "divider", "padding": { "vertical": 8 } },

        { "type": "label", "text": "Layered Design", "fontSize": 14, "fontWeight": "medium", "textColor": "#333333" },
        {
          "type": "zstack",
          "children": [
            { "type": "shape", "shapeType": "roundedRectangle", "cornerRadius": 20, "styleId": "layer1" },
            { "type": "shape", "shapeType": "circle", "styleId": "layer2" },
            { "type": "label", "text": "Layered", "styleId": "overlayText" }
          ]
        }
        ]
      }]
    }]
  }
}
"""
