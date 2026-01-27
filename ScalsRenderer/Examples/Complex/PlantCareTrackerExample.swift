import Foundation

public let plantCareTrackerJSON = """
{
  "id": "plant-care-tracker",
  "version": "1.0",
  "styles": {
    "headerTitle": {
      "fontSize": 28,
      "fontWeight": "bold",
      "textColor": "#1C1C1E"
    },
    "headerSubtitle": {
      "fontSize": 14,
      "textColor": "#8E8E93"
    },
    "sectionHeader": {
      "fontSize": 20,
      "fontWeight": "semibold",
      "textColor": "#1C1C1E"
    },
    "activityCard": {
      "backgroundColor": "#F2F2F7",
      "cornerRadius": 12,
      "padding": { "all": 12 },
      "width": 100
    },
    "statCard": {
      "backgroundColor": "#F2F2F7",
      "cornerRadius": 12,
      "padding": { "all": 16 }
    },
    "statCircleGreen": {
      "width": 60,
      "height": 60,
      "backgroundColor": "#4CAF50"
    },
    "statCircleOrange": {
      "width": 60,
      "height": 60,
      "backgroundColor": "#FF9800"
    },
    "statCircleRed": {
      "width": 60,
      "height": 60,
      "backgroundColor": "#F44336"
    },
    "statCircleBlue": {
      "width": 60,
      "height": 60,
      "backgroundColor": "#007AFF"
    },
    "baseCard": {
      "cornerRadius": 16,
      "padding": { "all": 16 },
      "backgroundColor": "#F2F2F7"
    },
    "healthyCard": {
      "baseStyle": "baseCard",
      "backgroundColor": "#E8F5E9",
      "borderColor": "#4CAF50",
      "borderWidth": 2
    },
    "warningCard": {
      "baseStyle": "baseCard",
      "backgroundColor": "#FFF3E0",
      "borderColor": "#FF9800",
      "borderWidth": 2
    },
    "criticalCard": {
      "baseStyle": "baseCard",
      "backgroundColor": "#FFEBEE",
      "borderColor": "#F44336",
      "borderWidth": 2
    },
    "plantName": {
      "fontSize": 18,
      "fontWeight": "semibold",
      "textColor": "#1C1C1E"
    },
    "waterStatus": {
      "fontSize": 14,
      "textColor": "#3C3C43"
    },
    "sunlightInfo": {
      "fontSize": 13,
      "textColor": "#8E8E93"
    },
    "healthyStatus": {
      "width": 12,
      "height": 12,
      "backgroundColor": "#4CAF50"
    },
    "warningStatus": {
      "width": 12,
      "height": 12,
      "backgroundColor": "#FF9800"
    },
    "criticalStatus": {
      "width": 12,
      "height": 12,
      "backgroundColor": "#F44336"
    },
    "healthyStatusSquare": {
      "width": 12,
      "height": 12,
      "backgroundColor": "#4CAF50",
      "cornerRadius": 3
    },
    "warningStatusSquare": {
      "width": 12,
      "height": 12,
      "backgroundColor": "#FF9800",
      "cornerRadius": 3
    },
    "waterBar85": {
      "width": 170,
      "height": 8,
      "backgroundColor": "#4CAF50"
    },
    "waterBar65": {
      "width": 130,
      "height": 8,
      "backgroundColor": "#4CAF50"
    },
    "waterBar30": {
      "width": 60,
      "height": 8,
      "backgroundColor": "#FF9800"
    },
    "waterBar20": {
      "width": 40,
      "height": 8,
      "backgroundColor": "#F44336"
    },
    "waterBar10": {
      "width": 20,
      "height": 8,
      "backgroundColor": "#F44336"
    },
    "waterButton": {
      "backgroundColor": "#007AFF",
      "textColor": "#FFFFFF",
      "cornerRadius": 8,
      "padding": { "horizontal": 16, "vertical": 8 }
    }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 50 },
    "children": [
      {
        "type": "vstack",
        "spacing": 4,
        "alignment": "leading",
        "padding": { "horizontal": 20, "bottom": 20 },
        "children": [
          { "type": "label", "text": "🌱 My Plant Garden", "styleId": "headerTitle" },
          { "type": "label", "text": "5 plants • 2 need water", "styleId": "headerSubtitle" }
        ]
      },
      {
        "type": "sectionLayout",
        "sectionSpacing": 24,
        "sections": [
        {
          "layout": {
            "type": "horizontal",
            "itemSpacing": 12,
            "contentInsets": { "horizontal": 20 }
          },
          "header": {
            "type": "label",
            "text": "Recent Activity",
            "styleId": "sectionHeader",
            "padding": { "horizontal": 20, "bottom": 12 }
          },
          "children": [
            {
              "type": "vstack",
              "styleId": "activityCard",
              "spacing": 6,
              "children": [
                { "type": "label", "text": "🌱", "fontSize": 24 },
                { "type": "label", "text": "Planted", "fontSize": 12, "fontWeight": "medium" },
                { "type": "label", "text": "Monstera", "fontSize": 10, "textColor": "#8E8E93" }
              ]
            },
            {
              "type": "vstack",
              "styleId": "activityCard",
              "spacing": 6,
              "children": [
                { "type": "label", "text": "💧", "fontSize": 24 },
                { "type": "label", "text": "Watered", "fontSize": 12, "fontWeight": "medium" },
                { "type": "label", "text": "Pothos", "fontSize": 10, "textColor": "#8E8E93" }
              ]
            },
            {
              "type": "vstack",
              "styleId": "activityCard",
              "spacing": 6,
              "children": [
                { "type": "label", "text": "☀️", "fontSize": 24 },
                { "type": "label", "text": "Moved", "fontSize": 12, "fontWeight": "medium" },
                { "type": "label", "text": "Snake Plant", "fontSize": 10, "textColor": "#8E8E93" }
              ]
            },
            {
              "type": "vstack",
              "styleId": "activityCard",
              "spacing": 6,
              "children": [
                { "type": "label", "text": "✂️", "fontSize": 24 },
                { "type": "label", "text": "Pruned", "fontSize": 12, "fontWeight": "medium" },
                { "type": "label", "text": "Peace Lily", "fontSize": 10, "textColor": "#8E8E93" }
              ]
            }
          ]
        },
        {
          "layout": {
            "type": "grid",
            "columns": 2,
            "itemSpacing": 16,
            "contentInsets": { "horizontal": 20 }
          },
          "header": {
            "type": "label",
            "text": "Garden Stats",
            "styleId": "sectionHeader",
            "padding": { "horizontal": 20, "bottom": 12 }
          },
          "children": [
            {
              "type": "vstack",
              "styleId": "statCard",
              "spacing": 8,
              "children": [
                { "type": "shape", "shapeType": "circle", "styleId": "statCircleGreen" },
                { "type": "label", "text": "Healthy", "fontSize": 14, "fontWeight": "semibold" },
                { "type": "label", "text": "40%", "fontSize": 20, "fontWeight": "bold", "textColor": "#4CAF50" }
              ]
            },
            {
              "type": "vstack",
              "styleId": "statCard",
              "spacing": 8,
              "children": [
                { "type": "shape", "shapeType": "circle", "styleId": "statCircleOrange" },
                { "type": "label", "text": "Warning", "fontSize": 14, "fontWeight": "semibold" },
                { "type": "label", "text": "40%", "fontSize": 20, "fontWeight": "bold", "textColor": "#FF9800" }
              ]
            },
            {
              "type": "vstack",
              "styleId": "statCard",
              "spacing": 8,
              "children": [
                { "type": "shape", "shapeType": "circle", "styleId": "statCircleRed" },
                { "type": "label", "text": "Critical", "fontSize": 14, "fontWeight": "semibold" },
                { "type": "label", "text": "20%", "fontSize": 20, "fontWeight": "bold", "textColor": "#F44336" }
              ]
            },
            {
              "type": "vstack",
              "styleId": "statCard",
              "spacing": 8,
              "children": [
                { "type": "shape", "shapeType": "circle", "styleId": "statCircleBlue" },
                { "type": "label", "text": "Total", "fontSize": 14, "fontWeight": "semibold" },
                { "type": "label", "text": "5", "fontSize": 20, "fontWeight": "bold", "textColor": "#007AFF" }
              ]
            }
          ]
        },
        {
          "layout": {
            "type": "list",
            "showsDividers": false,
            "itemSpacing": 16,
            "contentInsets": { "horizontal": 20, "bottom": 24 }
          },
          "header": {
            "type": "label",
            "text": "My Plants",
            "styleId": "sectionHeader",
            "padding": { "horizontal": 20, "bottom": 12 }
          },
          "children": [
            {
              "type": "vstack",
              "styleId": "healthyCard",
              "spacing": 12,
              "children": [
                {
                  "type": "hstack",
                  "spacing": 8,
                  "children": [
                    { "type": "shape", "shapeType": "circle", "styleId": "healthyStatus" },
                    { "type": "label", "text": "Monstera Deliciosa", "styleId": "plantName" },
                    { "type": "spacer" }
                  ]
                },
                {
                  "type": "vstack",
                  "spacing": 8,
                  "alignment": "leading",
                  "children": [
                    { "type": "label", "text": "Water in 3 days", "styleId": "waterStatus" },
                    {
                      "type": "hstack",
                      "spacing": 8,
                      "children": [
                        { "type": "label", "text": "💧", "fontSize": 14 },
                        { "type": "shape", "shapeType": "capsule", "styleId": "waterBar85" },
                        { "type": "label", "text": "85%", "fontSize": 12, "textColor": "#8E8E93" }
                      ]
                    },
                    {
                      "type": "hstack",
                      "spacing": 4,
                      "children": [
                        { "type": "label", "text": "☀️", "fontSize": 13 },
                        { "type": "label", "text": "Bright indirect", "styleId": "sunlightInfo" }
                      ]
                    },
                    { "type": "label", "text": "Last watered: 3 days ago", "fontSize": 12, "textColor": "#8E8E93" }
                  ]
                }
              ]
            },
            {
              "type": "vstack",
              "styleId": "warningCard",
              "spacing": 12,
              "children": [
                {
                  "type": "hstack",
                  "spacing": 8,
                  "children": [
                    { "type": "shape", "shapeType": "roundedRectangle", "cornerRadius": 3, "styleId": "warningStatusSquare" },
                    { "type": "label", "text": "Pothos", "styleId": "plantName" },
                    { "type": "spacer" }
                  ]
                },
                {
                  "type": "vstack",
                  "spacing": 8,
                  "alignment": "leading",
                  "children": [
                    { "type": "label", "text": "Water today!", "styleId": "waterStatus" },
                    {
                      "type": "hstack",
                      "spacing": 8,
                      "children": [
                        { "type": "label", "text": "💧", "fontSize": 14 },
                        { "type": "shape", "shapeType": "capsule", "styleId": "waterBar30" },
                        { "type": "label", "text": "30%", "fontSize": 12, "textColor": "#8E8E93" }
                      ]
                    },
                    {
                      "type": "hstack",
                      "spacing": 4,
                      "children": [
                        { "type": "label", "text": "☀️", "fontSize": 13 },
                        { "type": "label", "text": "Low to bright indirect", "styleId": "sunlightInfo" }
                      ]
                    },
                    { "type": "label", "text": "Last watered: 7 days ago", "fontSize": 12, "textColor": "#8E8E93" }
                  ]
                }
              ]
            },
            {
              "type": "vstack",
              "styleId": "criticalCard",
              "spacing": 12,
              "children": [
                {
                  "type": "hstack",
                  "spacing": 8,
                  "children": [
                    { "type": "shape", "shapeType": "circle", "styleId": "criticalStatus" },
                    { "type": "label", "text": "Snake Plant", "styleId": "plantName" },
                    { "type": "spacer" }
                  ]
                },
                {
                  "type": "vstack",
                  "spacing": 8,
                  "alignment": "leading",
                  "children": [
                    { "type": "label", "text": "Needs water urgently!", "styleId": "waterStatus" },
                    {
                      "type": "hstack",
                      "spacing": 8,
                      "children": [
                        { "type": "label", "text": "💧", "fontSize": 14 },
                        { "type": "shape", "shapeType": "capsule", "styleId": "waterBar10" },
                        { "type": "label", "text": "10%", "fontSize": 12, "textColor": "#8E8E93" }
                      ]
                    },
                    {
                      "type": "hstack",
                      "spacing": 4,
                      "children": [
                        { "type": "label", "text": "☀️", "fontSize": 13 },
                        { "type": "label", "text": "Low light", "styleId": "sunlightInfo" }
                      ]
                    },
                    { "type": "label", "text": "Last watered: 12 days ago", "fontSize": 12, "textColor": "#8E8E93" }
                  ]
                }
              ]
            },
            {
              "type": "vstack",
              "styleId": "healthyCard",
              "spacing": 12,
              "children": [
                {
                  "type": "hstack",
                  "spacing": 8,
                  "children": [
                    { "type": "shape", "shapeType": "roundedRectangle", "cornerRadius": 3, "styleId": "healthyStatusSquare" },
                    { "type": "label", "text": "Fiddle Leaf Fig", "styleId": "plantName" },
                    { "type": "spacer" }
                  ]
                },
                {
                  "type": "vstack",
                  "spacing": 8,
                  "alignment": "leading",
                  "children": [
                    { "type": "label", "text": "Water in 2 days", "styleId": "waterStatus" },
                    {
                      "type": "hstack",
                      "spacing": 8,
                      "children": [
                        { "type": "label", "text": "💧", "fontSize": 14 },
                        { "type": "shape", "shapeType": "capsule", "styleId": "waterBar65" },
                        { "type": "label", "text": "65%", "fontSize": 12, "textColor": "#8E8E93" }
                      ]
                    },
                    {
                      "type": "hstack",
                      "spacing": 4,
                      "children": [
                        { "type": "label", "text": "☀️", "fontSize": 13 },
                        { "type": "label", "text": "Bright indirect", "styleId": "sunlightInfo" }
                      ]
                    },
                    { "type": "label", "text": "Last watered: 5 days ago", "fontSize": 12, "textColor": "#8E8E93" }
                  ]
                }
              ]
            },
            {
              "type": "vstack",
              "styleId": "warningCard",
              "spacing": 12,
              "children": [
                {
                  "type": "hstack",
                  "spacing": 8,
                  "children": [
                    { "type": "shape", "shapeType": "roundedRectangle", "cornerRadius": 3, "styleId": "warningStatusSquare" },
                    { "type": "label", "text": "Peace Lily", "styleId": "plantName" },
                    { "type": "spacer" }
                  ]
                },
                {
                  "type": "vstack",
                  "spacing": 8,
                  "alignment": "leading",
                  "children": [
                    { "type": "label", "text": "Water in 1 day", "styleId": "waterStatus" },
                    {
                      "type": "hstack",
                      "spacing": 8,
                      "children": [
                        { "type": "label", "text": "💧", "fontSize": 14 },
                        { "type": "shape", "shapeType": "capsule", "styleId": "waterBar20" },
                        { "type": "label", "text": "20%", "fontSize": 12, "textColor": "#8E8E93" }
                      ]
                    },
                    {
                      "type": "hstack",
                      "spacing": 4,
                      "children": [
                        { "type": "label", "text": "☀️", "fontSize": 13 },
                        { "type": "label", "text": "Low to medium", "styleId": "sunlightInfo" }
                      ]
                    },
                    { "type": "label", "text": "Last watered: 6 days ago", "fontSize": 12, "textColor": "#8E8E93" }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }]
  }
}
"""

// MARK: Card Paging
