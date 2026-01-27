import Foundation

public let sectionHorizontalJSON = """
{
  "id": "section-horizontal-example",
  "version": "1.0",
  "state": { "currentPage": 0 },
  "styles": {
    "header": { "fontSize": 22, "fontWeight": "bold", "textColor": "#000000", "padding": { "horizontal": 20 } },
    "card": { "width": 140, "height": 180, "backgroundColor": "#F2F2F7", "cornerRadius": 12 },
    "cardImage": { "width": 140, "height": 100, "cornerRadius": 12 },
    "cardTitle": { "fontSize": 14, "fontWeight": "semibold", "textColor": "#000000" },
    "cardSubtitle": { "fontSize": 12, "textColor": "#888888" },
    "pageCard": {
      "minHeight": 400
    },
    "cardBgGreen": {
      "backgroundColor": "#A5D6A7",
      "cornerRadius": 20,
      "padding": { "all": 40 }
    },
    "cardBgBlue": {
      "backgroundColor": "#90CAF9",
      "cornerRadius": 20,
      "padding": { "all": 40 }
    },
    "cardBgPurple": {
      "backgroundColor": "#CE93D8",
      "cornerRadius": 20,
      "padding": { "all": 40 }
    },
    "pageEmoji": { "fontSize": 64, "textAlignment": "center" },
    "pageTitle": {
      "fontSize": 28,
      "fontWeight": "bold",
      "textColor": "#1C1C1E",
      "textAlignment": "center"
    },
    "pageBody": {
      "fontSize": 16,
      "textColor": "#3C3C43",
      "textAlignment": "center",
      "padding": { "top": 8 }
    }
  },
  "root": {
    "backgroundColor": "#F2F2F7",
    "scrollable": true,
    "edgeInsets": { "top": 52 },
    "children": [{
      "type": "sectionLayout",
      "sectionSpacing": 32,
      "sections": [
        {
          "id": "horizontal-section",
          "layout": {
            "type": "horizontal",
            "itemSpacing": 12,
            "contentInsets": { "leading": 20, "trailing": 20 },
            "showsIndicators": false
          },
          "header": {
            "type": "label", "text": "Featured", "styleId": "header",
            "padding": { "bottom": 12 }
          },
          "children": [
            { "type": "vstack", "spacing": 8, "alignment": "leading", "styleId": "card", "children": [{ "type": "gradient", "gradientColors": [{"color": "#FF6B6B", "location": 0}, {"color": "#4ECDC4", "location": 1}], "styleId": "cardImage" }, { "type": "label", "text": "Card One", "styleId": "cardTitle", "padding": { "horizontal": 8 } }, { "type": "label", "text": "Description", "styleId": "cardSubtitle", "padding": { "horizontal": 8 } }] },
            { "type": "vstack", "spacing": 8, "alignment": "leading", "styleId": "card", "children": [{ "type": "gradient", "gradientColors": [{"color": "#667eea", "location": 0}, {"color": "#764ba2", "location": 1}], "styleId": "cardImage" }, { "type": "label", "text": "Card Two", "styleId": "cardTitle", "padding": { "horizontal": 8 } }, { "type": "label", "text": "Description", "styleId": "cardSubtitle", "padding": { "horizontal": 8 } }] },
            { "type": "vstack", "spacing": 8, "alignment": "leading", "styleId": "card", "children": [{ "type": "gradient", "gradientColors": [{"color": "#f093fb", "location": 0}, {"color": "#f5576c", "location": 1}], "styleId": "cardImage" }, { "type": "label", "text": "Card Three", "styleId": "cardTitle", "padding": { "horizontal": 8 } }, { "type": "label", "text": "Description", "styleId": "cardSubtitle", "padding": { "horizontal": 8 } }] },
            { "type": "vstack", "spacing": 8, "alignment": "leading", "styleId": "card", "children": [{ "type": "gradient", "gradientColors": [{"color": "#11998e", "location": 0}, {"color": "#38ef7d", "location": 1}], "styleId": "cardImage" }, { "type": "label", "text": "Card Four", "styleId": "cardTitle", "padding": { "horizontal": 8 } }, { "type": "label", "text": "Description", "styleId": "cardSubtitle", "padding": { "horizontal": 8 } }] }
          ]
        },
        {
          "id": "card-paging-section",
          "layout": {
            "type": "horizontal",
            "isPagingEnabled": true,
            "cardWidth": 0.85,
            "cardSpacing": 16,
            "currentPageBinding": "currentPage"
          },
          "header": {
            "type": "label", "text": "Card Paging", "styleId": "header",
            "padding": { "bottom": 12 }
          },
          "children": [
            {
              "type": "zstack",
              "styleId": "pageCard",
              "children": [
                {
                  "type": "gradient",
                  "gradientColors": [
                    { "color": "#A5D6A7", "location": 0.0 },
                    { "color": "#A5D6A7", "location": 1.0 }
                  ],
                  "cornerRadius": 20
                },
                {
                  "type": "vstack",
                  "padding": { "all": 40 },
                  "spacing": 16,
                  "alignment": "center",
                  "children": [
                    { "type": "label", "text": "Welcome", "styleId": "pageTitle" },
                    { "type": "label", "text": "Track your plants and keep them healthy", "styleId": "pageBody" }
                  ]
                }
              ]
            },
            {
              "type": "zstack",
              "styleId": "pageCard",
              "children": [
                {
                  "type": "gradient",
                  "gradientColors": [
                    { "color": "#90CAF9", "location": 0.0 },
                    { "color": "#90CAF9", "location": 1.0 }
                  ],
                  "cornerRadius": 20
                },
                {
                  "type": "vstack",
                  "padding": { "all": 40 },
                  "spacing": 16,
                  "alignment": "center",
                  "children": [
                    { "type": "label", "text": "Watering", "styleId": "pageTitle" },
                    { "type": "label", "text": "Get reminders when your plants need water", "styleId": "pageBody" }
                  ]
                }
              ]
            },
            {
              "type": "zstack",
              "styleId": "pageCard",
              "children": [
                {
                  "type": "gradient",
                  "gradientColors": [
                    { "color": "#CE93D8", "location": 0.0 },
                    { "color": "#CE93D8", "location": 1.0 }
                  ],
                  "cornerRadius": 20
                },
                {
                  "type": "vstack",
                  "padding": { "all": 40 },
                  "spacing": 16,
                  "alignment": "center",
                  "children": [
                    { "type": "label", "text": "Statistics", "styleId": "pageTitle" },
                    { "type": "label", "text": "See your plant care history and trends", "styleId": "pageBody" }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "type": "pageIndicator",
      "currentPage": "currentPage",
      "pageCount": 3,
      "dotSize": 8,
      "dotSpacing": 8,
      "padding": { "vertical": 20, "horizontal": 20 }
    }]
  }
}
"""
