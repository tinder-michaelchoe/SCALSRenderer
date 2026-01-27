import Foundation

public let sectionListJSON = """
{
  "id": "section-list-example",
  "version": "1.0",
  "styles": {
    "header": { "fontSize": 22, "fontWeight": "bold", "textColor": "#000000" },
    "rowTitle": { "fontSize": 16, "textColor": "#000000" },
    "rowSubtitle": { "fontSize": 14, "textColor": "#888888" },
    "iconBlue": { "width": 24, "height": 24, "tintColor": "#007AFF" },
    "iconOrange": { "width": 24, "height": 24, "tintColor": "#FF9500" },
    "iconGreen": { "width": 24, "height": 24, "tintColor": "#34C759" },
    "iconPurple": { "width": 24, "height": 24, "tintColor": "#AF52DE" },
    "iconRed": { "width": 24, "height": 24, "tintColor": "#FF3B30" },
    "iconTeal": { "width": 24, "height": 24, "tintColor": "#5AC8FA" },
    "iconPink": { "width": 24, "height": 24, "tintColor": "#FF2D55" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36 },
    "children": [{
      "type": "sectionLayout",
      "sectionSpacing": 24,
      "sections": [{
        "id": "list-section",
        "layout": {
          "type": "list",
          "itemSpacing": 0,
          "showsDividers": true,
          "contentInsets": { "horizontal": 28 }
        },
        "header": {
          "type": "label", "text": "Settings", "styleId": "header",
          "padding": { "bottom": 12 }
        },
        "children": [
          {
            "type": "hstack", "padding": { "vertical": 14 },
            "children": [
              { "type": "image", "image": { "sfsymbol": "person.fill" }, "styleId": "iconBlue" },
              {
                "type": "vstack", "spacing": 2, "alignment": "leading", "padding": { "leading": 12 },
                "children": [
                  { "type": "label", "text": "Account", "styleId": "rowTitle" },
                  { "type": "label", "text": "Manage your profile", "styleId": "rowSubtitle" }
                ]
              },
              { "type": "spacer" }
            ]
          },
          {
            "type": "hstack", "padding": { "vertical": 14 },
            "children": [
              { "type": "image", "image": { "sfsymbol": "bell.fill" }, "styleId": "iconOrange" },
              {
                "type": "vstack", "spacing": 2, "alignment": "leading", "padding": { "leading": 12 },
                "children": [
                  { "type": "label", "text": "Notifications", "styleId": "rowTitle" },
                  { "type": "label", "text": "Alerts and sounds", "styleId": "rowSubtitle" }
                ]
              },
              { "type": "spacer" }
            ]
          },
          {
            "type": "hstack", "padding": { "vertical": 14 },
            "children": [
              { "type": "image", "image": { "sfsymbol": "lock.fill" }, "styleId": "iconGreen" },
              {
                "type": "vstack", "spacing": 2, "alignment": "leading", "padding": { "leading": 12 },
                "children": [
                  { "type": "label", "text": "Privacy", "styleId": "rowTitle" },
                  { "type": "label", "text": "Data and permissions", "styleId": "rowSubtitle" }
                ]
              },
              { "type": "spacer" }
            ]
          },
          {
            "type": "hstack", "padding": { "vertical": 14 },
            "children": [
              { "type": "image", "image": { "sfsymbol": "paintbrush.fill" }, "styleId": "iconPurple" },
              {
                "type": "vstack", "spacing": 2, "alignment": "leading", "padding": { "leading": 12 },
                "children": [
                  { "type": "label", "text": "Appearance", "styleId": "rowTitle" },
                  { "type": "label", "text": "Theme and display", "styleId": "rowSubtitle" }
                ]
              },
              { "type": "spacer" }
            ]
          },
          {
            "type": "hstack", "padding": { "vertical": 14 },
            "children": [
              { "type": "image", "image": { "sfsymbol": "icloud.fill" }, "styleId": "iconTeal" },
              {
                "type": "vstack", "spacing": 2, "alignment": "leading", "padding": { "leading": 12 },
                "children": [
                  { "type": "label", "text": "Cloud Sync", "styleId": "rowTitle" },
                  { "type": "label", "text": "Backup and restore", "styleId": "rowSubtitle" }
                ]
              },
              { "type": "spacer" }
            ]
          },
          {
            "type": "hstack", "padding": { "vertical": 14 },
            "children": [
              { "type": "image", "image": { "sfsymbol": "heart.fill" }, "styleId": "iconPink" },
              {
                "type": "vstack", "spacing": 2, "alignment": "leading", "padding": { "leading": 12 },
                "children": [
                  { "type": "label", "text": "Favorites", "styleId": "rowTitle" },
                  { "type": "label", "text": "Saved items", "styleId": "rowSubtitle" }
                ]
              },
              { "type": "spacer" }
            ]
          },
          {
            "type": "hstack", "padding": { "vertical": 14 },
            "children": [
              { "type": "image", "image": { "sfsymbol": "questionmark.circle.fill" }, "styleId": "iconBlue" },
              {
                "type": "vstack", "spacing": 2, "alignment": "leading", "padding": { "leading": 12 },
                "children": [
                  { "type": "label", "text": "Help & Support", "styleId": "rowTitle" },
                  { "type": "label", "text": "FAQs and contact", "styleId": "rowSubtitle" }
                ]
              },
              { "type": "spacer" }
            ]
          },
          {
            "type": "hstack", "padding": { "vertical": 14 },
            "children": [
              { "type": "image", "image": { "sfsymbol": "arrow.right.square.fill" }, "styleId": "iconRed" },
              {
                "type": "vstack", "spacing": 2, "alignment": "leading", "padding": { "leading": 12 },
                "children": [
                  { "type": "label", "text": "Sign Out", "styleId": "rowTitle" },
                  { "type": "label", "text": "Log out of your account", "styleId": "rowSubtitle" }
                ]
              },
              { "type": "spacer" }
            ]
          }
        ]
      },
      {
        "id": "about-section",
        "layout": {
          "type": "list",
          "itemSpacing": 0,
          "showsDividers": true,
          "contentInsets": { "horizontal": 28 }
        },
        "header": {
          "type": "label", "text": "About", "styleId": "header",
          "padding": { "bottom": 12 }
        },
        "children": [
          {
            "type": "hstack", "padding": { "vertical": 14 },
            "children": [
              { "type": "image", "image": { "sfsymbol": "info.circle.fill" }, "styleId": "iconBlue" },
              {
                "type": "vstack", "spacing": 2, "alignment": "leading", "padding": { "leading": 12 },
                "children": [
                  { "type": "label", "text": "Version", "styleId": "rowTitle" },
                  { "type": "label", "text": "1.0.0 (Build 42)", "styleId": "rowSubtitle" }
                ]
              },
              { "type": "spacer" }
            ]
          },
          {
            "type": "hstack", "padding": { "vertical": 14 },
            "children": [
              { "type": "image", "image": { "sfsymbol": "doc.text.fill" }, "styleId": "iconGreen" },
              {
                "type": "vstack", "spacing": 2, "alignment": "leading", "padding": { "leading": 12 },
                "children": [
                  { "type": "label", "text": "Terms of Service", "styleId": "rowTitle" },
                  { "type": "label", "text": "Legal agreements", "styleId": "rowSubtitle" }
                ]
              },
              { "type": "spacer" }
            ]
          },
          {
            "type": "hstack", "padding": { "vertical": 14 },
            "children": [
              { "type": "image", "image": { "sfsymbol": "hand.raised.fill" }, "styleId": "iconOrange" },
              {
                "type": "vstack", "spacing": 2, "alignment": "leading", "padding": { "leading": 12 },
                "children": [
                  { "type": "label", "text": "Privacy Policy", "styleId": "rowTitle" },
                  { "type": "label", "text": "How we handle your data", "styleId": "rowSubtitle" }
                ]
              },
              { "type": "spacer" }
            ]
          },
          {
            "type": "hstack", "padding": { "vertical": 14 },
            "children": [
              { "type": "image", "image": { "sfsymbol": "star.fill" }, "styleId": "iconPurple" },
              {
                "type": "vstack", "spacing": 2, "alignment": "leading", "padding": { "leading": 12 },
                "children": [
                  { "type": "label", "text": "Rate the App", "styleId": "rowTitle" },
                  { "type": "label", "text": "Leave a review", "styleId": "rowSubtitle" }
                ]
              },
              { "type": "spacer" }
            ]
          }
        ]
      }]
    }]
  }
}
"""
