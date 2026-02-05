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
      "textColor": "#1C1C1E"
    },
    "closeButton": {
      "fontSize": 17,
      "fontWeight": "medium",
      "textColor": "#007AFF"
    },
    "horizontalCard": {
      "width": 150,
      "height": 100,
      "backgroundColor": "#007AFF",
      "cornerRadius": 16,
      "padding": { "all": 16 }
    },
    "horizontalCardTitle": {
      "fontSize": 18,
      "fontWeight": "bold",
      "textColor": "#FFFFFF"
    },
    "horizontalCardSubtitle": {
      "fontSize": 13,
      "fontWeight": "medium",
      "textColor": "rgba(255, 255, 255, 0.8)"
    },
    "gridCard": {
      "height": 120,
      "backgroundColor": "#34C759",
      "cornerRadius": 16,
      "padding": { "all": 16 }
    },
    "gridCardTitle": {
      "fontSize": 16,
      "fontWeight": "bold",
      "textColor": "#FFFFFF"
    },
    "gridCardIcon": {
      "width": 32,
      "height": 32,
      "tintColor": "#FFFFFF"
    },
    "listItemContainer": {
      "backgroundColor": "#F2F2F7",
      "cornerRadius": 12,
      "padding": { "all": 16 }
    },
    "listItemTitle": {
      "fontSize": 17,
      "fontWeight": "semibold",
      "textColor": "#000000",
      "textAlignment": "leading"
    },
    "listItemSubtitle": {
      "fontSize": 14,
      "fontWeight": "regular",
      "textColor": "#666666",
      "textAlignment": "leading"
    },
    "listItemIcon": {
      "width": 40,
      "height": 40,
      "tintColor": "#007AFF"
    },
    "listItemTextContainer": {
      "minWidth": 240
    },
    "disclosureChevron": {
      "height": 18,
      "tintColor": "#C7C7CC"
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
                "spacing": 8,
                "alignment": "leading",
                "styleId": "horizontalCard",
                "children": [
                  { "type": "image", "image": { "sfsymbol": "star.fill" }, "styleId": "horizontalCardTitle" },
                  { "type": "label", "text": "Featured", "styleId": "horizontalCardTitle" },
                  { "type": "label", "text": "Top picks", "styleId": "horizontalCardSubtitle" }
                ]
              },
              {
                "type": "vstack",
                "spacing": 8,
                "alignment": "leading",
                "styleId": "horizontalCard",
                "children": [
                  { "type": "image", "image": { "sfsymbol": "flame.fill" }, "styleId": "horizontalCardTitle" },
                  { "type": "label", "text": "Trending", "styleId": "horizontalCardTitle" },
                  { "type": "label", "text": "Popular now", "styleId": "horizontalCardSubtitle" }
                ]
              },
              {
                "type": "vstack",
                "spacing": 8,
                "alignment": "leading",
                "styleId": "horizontalCard",
                "children": [
                  { "type": "image", "image": { "sfsymbol": "sparkles" }, "styleId": "horizontalCardTitle" },
                  { "type": "label", "text": "New", "styleId": "horizontalCardTitle" },
                  { "type": "label", "text": "Just added", "styleId": "horizontalCardSubtitle" }
                ]
              },
              {
                "type": "vstack",
                "spacing": 8,
                "alignment": "leading",
                "styleId": "horizontalCard",
                "children": [
                  { "type": "image", "image": { "sfsymbol": "heart.fill" }, "styleId": "horizontalCardTitle" },
                  { "type": "label", "text": "Favorites", "styleId": "horizontalCardTitle" },
                  { "type": "label", "text": "Your likes", "styleId": "horizontalCardSubtitle" }
                ]
              },
              {
                "type": "vstack",
                "spacing": 8,
                "alignment": "leading",
                "styleId": "horizontalCard",
                "children": [
                  { "type": "image", "image": { "sfsymbol": "clock.fill" }, "styleId": "horizontalCardTitle" },
                  { "type": "label", "text": "Recent", "styleId": "horizontalCardTitle" },
                  { "type": "label", "text": "Last viewed", "styleId": "horizontalCardSubtitle" }
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
              {
                "type": "vstack",
                "spacing": 8,
                "alignment": "center",
                "styleId": "gridCard",
                "children": [
                  { "type": "image", "image": { "sfsymbol": "photo.fill" }, "styleId": "gridCardIcon" },
                  { "type": "label", "text": "Photos", "styleId": "gridCardTitle" }
                ]
              },
              {
                "type": "vstack",
                "spacing": 8,
                "alignment": "center",
                "styleId": "gridCard",
                "children": [
                  { "type": "image", "image": { "sfsymbol": "music.note" }, "styleId": "gridCardIcon" },
                  { "type": "label", "text": "Music", "styleId": "gridCardTitle" }
                ]
              },
              {
                "type": "vstack",
                "spacing": 8,
                "alignment": "center",
                "styleId": "gridCard",
                "children": [
                  { "type": "image", "image": { "sfsymbol": "video.fill" }, "styleId": "gridCardIcon" },
                  { "type": "label", "text": "Videos", "styleId": "gridCardTitle" }
                ]
              },
              {
                "type": "vstack",
                "spacing": 8,
                "alignment": "center",
                "styleId": "gridCard",
                "children": [
                  { "type": "image", "image": { "sfsymbol": "doc.fill" }, "styleId": "gridCardIcon" },
                  { "type": "label", "text": "Documents", "styleId": "gridCardTitle" }
                ]
              }
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
                "alignment": "center",
                "styleId": "listItemContainer",
                "children": [
                  { "type": "image", "image": { "sfsymbol": "person.circle.fill" }, "styleId": "listItemIcon" },
                  {
                    "type": "vstack",
                    "spacing": 4,
                    "alignment": "leading",
                    "styleId": "listItemTextContainer",
                    "children": [
                      { "type": "label", "text": "Profile Settings", "styleId": "listItemTitle" },
                      { "type": "label", "text": "Manage your account", "styleId": "listItemSubtitle" }
                    ]
                  },
                  { "type": "spacer" },
                  { "type": "image", "image": { "sfsymbol": "chevron.right" }, "styleId": "disclosureChevron" }
                ]
              },
              {
                "type": "hstack",
                "spacing": 12,
                "alignment": "center",
                "styleId": "listItemContainer",
                "children": [
                  { "type": "image", "image": { "sfsymbol": "bell.circle.fill" }, "styleId": "listItemIcon" },
                  {
                    "type": "vstack",
                    "spacing": 4,
                    "alignment": "leading",
                    "styleId": "listItemTextContainer",
                    "children": [
                      { "type": "label", "text": "Notifications", "styleId": "listItemTitle" },
                      { "type": "label", "text": "Alerts and updates", "styleId": "listItemSubtitle" }
                    ]
                  },
                  { "type": "spacer" },
                  { "type": "image", "image": { "sfsymbol": "chevron.right" }, "styleId": "disclosureChevron" }
                ]
              },
              {
                "type": "hstack",
                "spacing": 12,
                "alignment": "center",
                "styleId": "listItemContainer",
                "children": [
                  { "type": "image", "image": { "sfsymbol": "lock.circle.fill" }, "styleId": "listItemIcon" },
                  {
                    "type": "vstack",
                    "spacing": 4,
                    "alignment": "leading",
                    "styleId": "listItemTextContainer",
                    "children": [
                      { "type": "label", "text": "Privacy & Security", "styleId": "listItemTitle" },
                      { "type": "label", "text": "Control your data", "styleId": "listItemSubtitle" }
                    ]
                  },
                  { "type": "spacer" },
                  { "type": "image", "image": { "sfsymbol": "chevron.right" }, "styleId": "disclosureChevron" }
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
