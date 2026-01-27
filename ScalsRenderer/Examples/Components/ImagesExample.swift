import Foundation

public let imagesJSON = """
{
  "id": "images-example",
  "version": "1.0",
  "state": {
    "dynamicImageUrl": "https://images.unsplash.com/photo-1745826092440-0d6542010bcc?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "currentImageIndex": 0,
    "imageUrls": [
      "https://images.unsplash.com/photo-1745826092440-0d6542010bcc?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://plus.unsplash.com/premium_photo-1717972598410-6a47fc079a16?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1519638617638-c589a8ba5b76?q=80&w=2662&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ]
  },
  "actions": {
    "cycleImage": {
      "type": "sequence",
      "steps": [
        {
          "type": "setState",
          "path": "currentImageIndex",
          "value": { "$expr": "(currentImageIndex + 1) % 3" }
        },
        {
          "type": "setState",
          "path": "dynamicImageUrl",
          "value": { "$expr": "imageUrls[currentImageIndex]" }
        }
      ]
    }
  },
  "dataSources": {
    "imageCounter": {
      "type": "binding",
      "template": "Image ${(currentImageIndex + 1)}/3 (tap to cycle)"
    }
  },
  "styles": {
    "sectionTitle": {
      "fontSize": 16,
      "fontWeight": "semibold",
      "textColor": "#000000",
      "textAlignment": "center"
    },
    "iconSmall": { "width": 40, "height": 40 },
    "iconRed": { "width": 40, "height": 40, "tintColor": "#FF3B30" },
    "iconBlue": { "width": 40, "height": 40, "tintColor": "#007AFF" },
    "iconGreen": { "width": 40, "height": 40, "tintColor": "#34C759" },
    "assetImage": { "width": 160, "height": 200, "cornerRadius": 12 },
    "urlImage": { "width": 200, "height": 150, "cornerRadius": 12 },
    "dynamicImage": { "width": 240, "height": 180, "cornerRadius": 12 },
    "spinner": { "width": 40, "height": 40 },
    "caption": { "fontSize": 11, "textColor": "#888888", "textAlignment": "center" },
    "changeImageButton": {
      "fontSize": 14,
      "fontWeight": "semibold",
      "backgroundColor": "#007AFF",
      "textColor": "#FFFFFF",
      "height": 40,
      "cornerRadius": 8
    }
  },
  "root": {
    "backgroundColor": "#F2F2F7",
    "edgeInsets": { "top": 52 },
    "children": [{
      "type": "sectionLayout",
      "sectionSpacing": 32,
      "sections": [
        {
          "id": "sf-symbols",
          "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "SF Symbols", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
          "children": [
            {
              "type": "hstack",
              "spacing": 20,
              "alignment": "center",
              "children": [
                {
                  "type": "vstack", "spacing": 4, "alignment": "center",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "star.fill" }, "styleId": "iconSmall" },
                    { "type": "label", "text": "Default", "styleId": "caption" }
                  ]
                },
                {
                  "type": "vstack", "spacing": 4, "alignment": "center",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "heart.fill" }, "styleId": "iconRed" },
                    { "type": "label", "text": "Red", "styleId": "caption" }
                  ]
                },
                {
                  "type": "vstack", "spacing": 4, "alignment": "center",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "bell.fill" }, "styleId": "iconBlue" },
                    { "type": "label", "text": "Blue", "styleId": "caption" }
                  ]
                },
                {
                  "type": "vstack", "spacing": 4, "alignment": "center",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "checkmark.circle.fill" }, "styleId": "iconGreen" },
                    { "type": "label", "text": "Green", "styleId": "caption" }
                  ]
                }
              ]
            }
          ]
        },
        {
          "id": "asset-catalog",
          "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "Asset Catalog", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
          "children": [
            {
              "type": "vstack",
              "spacing": 8,
              "alignment": "center",
              "children": [
                { "type": "image", "image": { "asset": "womanAligator" }, "styleId": "assetImage" },
                { "type": "label", "text": "Local asset image", "styleId": "caption" }
              ]
            }
          ]
        },
        {
          "id": "remote-url",
          "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "Remote URL", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
          "children": [
            {
              "type": "vstack",
              "spacing": 8,
              "alignment": "center",
              "children": [
                { "type": "image", "image": { "url": "https://images.pexels.com/photos/1658967/pexels-photo-1658967.jpeg?w=400" }, "styleId": "urlImage" },
                { "type": "label", "text": "URL-loaded image", "styleId": "caption" }
              ]
            }
          ]
        },
        {
          "id": "dynamic-url",
          "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "Dynamic URL (State Binding)", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
          "children": [
            {
              "type": "vstack",
              "spacing": 12,
              "alignment": "center",
              "children": [
                {
                  "type": "image",
                  "image": {
                    "url": "${dynamicImageUrl}",
                    "loading": { "activityIndicator": true }
                  },
                  "styleId": "dynamicImage"
                },
                {
                  "type": "label",
                  "dataSourceId": "imageCounter",
                  "styleId": "caption"
                },
                {
                  "type": "button",
                  "text": "Next Image (Cycle)",
                  "styleId": "changeImageButton",
                  "fillWidth": true,
                  "actions": { "onTap": "cycleImage" }
                }
              ]
            }
          ]
        },
        {
          "id": "activity-indicator",
          "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "Activity Indicator", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
          "children": [
            {
              "type": "vstack",
              "spacing": 8,
              "alignment": "center",
              "children": [
                { "type": "image", "image": { "activityIndicator": true }, "styleId": "spinner" },
                { "type": "label", "text": "Loading spinner", "styleId": "caption" }
              ]
            }
          ]
        }
      ]
    }]
  }
}
"""
