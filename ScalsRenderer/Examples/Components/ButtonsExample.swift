import Foundation

public let buttonsJSON = """
{
  "id": "buttons-example",
  "version": "1.0",
  "state": { "tapCount": 0 },
  "styles": {
    "sectionTitle": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000", "padding": { "top": 8, "bottom": 8 } },
    "primary": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#007AFF", "textColor": "#FFFFFF",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 20 }
    },
    "secondary": {
      "fontSize": 16, "fontWeight": "medium",
      "backgroundColor": "#E5E5EA", "textColor": "#000000",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 20 }
    },
    "destructive": {
      "fontSize": 16, "fontWeight": "semibold",
      "backgroundColor": "#FF3B30", "textColor": "#FFFFFF",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 20 }
    },
    "pill": {
      "fontSize": 14, "fontWeight": "medium",
      "backgroundColor": "#F2F2F7", "textColor": "#000000",
      "cornerRadius": 20, "height": 36, "padding": { "horizontal": 16 }
    },
    "pillSelected": {
      "fontSize": 14, "fontWeight": "semibold",
      "backgroundColor": "#34C759", "textColor": "#FFFFFF",
      "cornerRadius": 20, "height": 36, "padding": { "horizontal": 16 }
    },
    "countLabel": { "fontSize": 14, "textColor": "#666666" },
    "iconButton": {
      "fontSize": 16, "fontWeight": "medium",
      "backgroundColor": "#F2F2F7", "textColor": "#000000",
      "cornerRadius": 10, "width": 44, "height": 44
    },
    "iconButtonPrimary": {
      "fontSize": 16, "fontWeight": "medium",
      "backgroundColor": "#007AFF", "textColor": "#FFFFFF",
      "cornerRadius": 10, "width": 44, "height": 44
    },
    "verticalButton": {
      "fontSize": 14, "fontWeight": "medium",
      "backgroundColor": "#F2F2F7", "textColor": "#000000",
      "cornerRadius": 12, "padding": { "vertical": 12, "horizontal": 16 }
    },
    "compactButton": {
      "fontSize": 13, "fontWeight": "medium",
      "backgroundColor": "#E5E5EA", "textColor": "#000000",
      "cornerRadius": 8, "height": 32, "padding": { "horizontal": 12 }
    }
  },
  "actions": {
    "increment": { "type": "setState", "path": "tapCount", "value": { "$expr": "${tapCount} + 1" } }
  },
  "dataSources": {
    "countText": { "type": "binding", "template": "Tapped ${tapCount} times" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "children": [{
      "type": "sectionLayout",
      "sectionSpacing": 20,
      "sections": [{
        "layout": {
          "type": "list",
          "showsDividers": false,
          "itemSpacing": 20,
          "contentInsets": { "top": 36, "horizontal": 28, "bottom": 20 }
        },
        "children": [
        { "type": "label", "text": "Text Only", "styleId": "sectionTitle" },
        { "type": "button", "text": "Primary Button", "styleId": "primary", "fillWidth": true, "actions": { "onTap": "increment" } },
        { "type": "button", "text": "Secondary Button", "styleId": "secondary", "fillWidth": true, "actions": { "onTap": "increment" } },
        { "type": "button", "text": "Destructive", "styleId": "destructive", "fillWidth": true, "actions": { "onTap": "increment" } },

        { "type": "label", "text": "Image Only", "styleId": "sectionTitle" },
        {
          "type": "hstack", "spacing": 12,
          "children": [
            { "type": "button", "image": { "sfsymbol": "plus" }, "styleId": "iconButtonPrimary", "actions": { "onTap": "increment" } },
            { "type": "button", "image": { "sfsymbol": "heart" }, "styleId": "iconButton", "actions": { "onTap": "increment" } },
            { "type": "button", "image": { "sfsymbol": "star" }, "styleId": "iconButton", "actions": { "onTap": "increment" } },
            { "type": "button", "image": { "sfsymbol": "trash" }, "styleId": "iconButton", "actions": { "onTap": "increment" } },
            { "type": "button", "image": { "sfsymbol": "square.and.arrow.up" }, "styleId": "iconButton", "actions": { "onTap": "increment" } }
          ]
        },

        { "type": "label", "text": "Image Leading", "styleId": "sectionTitle" },
        {
          "type": "vstack", "spacing": 8,
          "children": [
            { "type": "button", "text": "Add Item", "image": { "sfsymbol": "plus.circle.fill" }, "imagePlacement": "leading", "styleId": "primary", "fillWidth": true, "actions": { "onTap": "increment" } },
            { "type": "button", "text": "Edit Document", "image": { "sfsymbol": "pencil.circle" }, "imagePlacement": "leading", "styleId": "secondary", "fillWidth": true, "actions": { "onTap": "increment" } },
            { "type": "button", "text": "Download", "image": { "sfsymbol": "arrow.down.circle" }, "imagePlacement": "leading", "styleId": "secondary", "fillWidth": true, "actions": { "onTap": "increment" } }
          ]
        },

        { "type": "label", "text": "Image Trailing", "styleId": "sectionTitle" },
        {
          "type": "vstack", "spacing": 8,
          "children": [
            { "type": "button", "text": "Open Settings", "image": { "sfsymbol": "gear" }, "imagePlacement": "trailing", "styleId": "secondary", "fillWidth": true, "actions": { "onTap": "increment" } },
            { "type": "button", "text": "Continue", "image": { "sfsymbol": "chevron.right" }, "imagePlacement": "trailing", "styleId": "primary", "fillWidth": true, "actions": { "onTap": "increment" } },
            { "type": "button", "text": "External Link", "image": { "sfsymbol": "arrow.up.right" }, "imagePlacement": "trailing", "styleId": "secondary", "fillWidth": true, "actions": { "onTap": "increment" } }
          ]
        },

        { "type": "label", "text": "Image Top", "styleId": "sectionTitle" },
        {
          "type": "hstack", "spacing": 12,
          "children": [
            { "type": "button", "text": "Home", "image": { "sfsymbol": "house.fill" }, "imagePlacement": "top", "styleId": "verticalButton", "actions": { "onTap": "increment" } },
            { "type": "button", "text": "Search", "image": { "sfsymbol": "magnifyingglass" }, "imagePlacement": "top", "styleId": "verticalButton", "actions": { "onTap": "increment" } },
            { "type": "button", "text": "Profile", "image": { "sfsymbol": "person.fill" }, "imagePlacement": "top", "styleId": "verticalButton", "actions": { "onTap": "increment" } }
          ]
        },

        { "type": "label", "text": "Image Bottom", "styleId": "sectionTitle" },
        {
          "type": "hstack", "spacing": 12,
          "children": [
            { "type": "button", "text": "Upload", "image": { "sfsymbol": "arrow.up.doc" }, "imagePlacement": "bottom", "styleId": "verticalButton", "actions": { "onTap": "increment" } },
            { "type": "button", "text": "Share", "image": { "sfsymbol": "square.and.arrow.up" }, "imagePlacement": "bottom", "styleId": "verticalButton", "actions": { "onTap": "increment" } },
            { "type": "button", "text": "Archive", "image": { "sfsymbol": "archivebox" }, "imagePlacement": "bottom", "styleId": "verticalButton", "actions": { "onTap": "increment" } }
          ]
        },

        { "type": "label", "text": "Compact with Images", "styleId": "sectionTitle" },
        {
          "type": "hstack", "spacing": 8,
          "children": [
            { "type": "button", "text": "Like", "image": { "sfsymbol": "hand.thumbsup" }, "imagePlacement": "leading", "styleId": "compactButton", "actions": { "onTap": "increment" } },
            { "type": "button", "text": "Save", "image": { "sfsymbol": "bookmark" }, "imagePlacement": "leading", "styleId": "compactButton", "actions": { "onTap": "increment" } },
            { "type": "button", "text": "More", "image": { "sfsymbol": "ellipsis" }, "imagePlacement": "trailing", "styleId": "compactButton", "actions": { "onTap": "increment" } }
          ]
        },

        { "type": "label", "text": "Mixed Styles", "styleId": "sectionTitle" },
        {
          "type": "vstack", "spacing": 8,
          "children": [
            { "type": "button", "text": "Delete All", "image": { "sfsymbol": "trash.fill" }, "imagePlacement": "leading", "styleId": "destructive", "fillWidth": true, "actions": { "onTap": "increment" } },
            { "type": "button", "text": "Refresh", "image": { "sfsymbol": "arrow.clockwise" }, "imagePlacement": "trailing", "styleId": "pill", "actions": { "onTap": "increment" } },
            { "type": "button", "text": "Selected", "image": { "sfsymbol": "checkmark" }, "imagePlacement": "leading", "styleId": "pillSelected", "actions": { "onTap": "increment" } }
          ]
        },

        { "type": "label", "dataSourceId": "countText", "styleId": "countLabel" }
      ]}]
    }]
  }
}
"""
