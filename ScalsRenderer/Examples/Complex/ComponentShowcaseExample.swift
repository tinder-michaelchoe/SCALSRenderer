import Foundation

public let componentShowcaseJSON = """
{
  "id": "component-showcase",
  "version": "1.0",
  "state": {
    "textFieldValue": "",
    "buttonTapCount": 0,
    "isToggled": false,
    "toggle1": false,
    "toggle2": true,
    "toggle3": false,
    "slider1": 0.5,
    "slider2": 0.75,
    "slider3": 25
  },
  "styles": {
    "screenTitle": { "fontSize": 28, "fontWeight": "bold", "textColor": "#000000", "textAlignment": "leading" },
    "sectionTitle": { "fontSize": 18, "fontWeight": "semibold", "textColor": "#000000" },
    "bodyText": { "fontSize": 15, "fontWeight": "regular", "textColor": "#333333" },
    "captionText": { "fontSize": 13, "fontWeight": "regular", "textColor": "#888888" },
    "primaryButton": { "fontSize": 16, "fontWeight": "semibold", "backgroundColor": "#007AFF", "textColor": "#FFFFFF", "cornerRadius": 10, "height": 44, "padding": { "horizontal": 20 } },
    "secondaryButton": { "fontSize": 16, "fontWeight": "medium", "backgroundColor": "#E5E5EA", "textColor": "#000000", "cornerRadius": 10, "height": 44, "padding": { "horizontal": 20 } },
    "toggleButton": { "fontSize": 14, "fontWeight": "medium", "backgroundColor": "#E5E5EA", "textColor": "#000000", "cornerRadius": 8, "height": 36, "padding": { "horizontal": 16 } },
    "toggleButtonSelected": { "fontSize": 14, "fontWeight": "semibold", "backgroundColor": "#34C759", "textColor": "#FFFFFF", "cornerRadius": 8, "height": 36, "padding": { "horizontal": 16 } },
    "textFieldStyle": { "fontSize": 16, "fontWeight": "regular", "textColor": "#000000", "backgroundColor": "#F2F2F7", "cornerRadius": 8, "padding": { "horizontal": 12, "vertical": 12 } },
    "iconStyle": { "width": 48, "height": 48 },
    "redIconStyle": { "inherits": "iconStyle", "tintColor": "#FF3B30" },
    "orangeIconStyle": { "inherits": "iconStyle", "tintColor": "#FF9500" },
    "blueIconStyle": { "inherits": "iconStyle", "tintColor": "#007AFF" },
    "urlImageStyle": { "cornerRadius": 12 },
    "spinnerStyle": { "width": 40, "height": 40 },
    "loadingButton": { "fontSize": 16, "fontWeight": "medium", "backgroundColor": "#E5E5EA", "textColor": "#666666", "cornerRadius": 10, "height": 44, "padding": { "horizontal": 20 } },
    "greenToggleStyle": { "tintColor": "#34C759" },
    "purpleToggleStyle": { "tintColor": "#AF52DE" },
    "orangeSliderStyle": { "tintColor": "#FF9500" },
    "redSliderStyle": { "tintColor": "#FF3B30" },
    "gradientStyle": { "width": 320, "height": 80, "cornerRadius": 12 },
    "gradientLabel": { "fontSize": 16, "fontWeight": "semibold", "textColor": "#FFFFFF" },
    "closeButton": { "fontSize": 15, "fontWeight": "regular", "textColor": "#007AFF" }
  },
  "actions": {
    "incrementCount": { "type": "setState", "path": "buttonTapCount", "value": { "$expr": "${buttonTapCount} + 1" } },
    "close": { "type": "dismiss" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 16 },
    "children": [{
      "type": "sectionLayout",
      "sectionSpacing": 52,
      "sections": [
        {
          "id": "header",
          "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20 } },
          "children": [
            { "type": "hstack", "children": [{ "type": "spacer" }, { "type": "button", "text": "Close", "styleId": "closeButton", "actions": { "onTap": "close" } }] },
            { "type": "label", "text": "Component Showcase", "styleId": "screenTitle" },
            { "type": "label", "text": "This example demonstrates all available component types in ScalsRenderer.", "styleId": "bodyText" }
          ]
        },
        {
          "id": "labels",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 8, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "Labels", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
          "children": [
            { "type": "label", "text": "This is body text with regular weight.", "styleId": "bodyText" },
            { "type": "label", "text": "This is caption text, smaller and lighter.", "styleId": "captionText" }
          ]
        },
        {
          "id": "buttons",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 12, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "Buttons", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
          "children": [
            { "type": "hstack", "spacing": 12, "children": [
              { "type": "button", "text": "Primary", "styleId": "primaryButton", "actions": { "onTap": "incrementCount" } },
              { "type": "button", "text": "Secondary", "styleId": "secondaryButton", "actions": { "onTap": "incrementCount" } }
            ]},
            { "type": "hstack", "spacing": 8, "children": [
              { "type": "label", "text": "Tap count:", "styleId": "captionText" },
              { "type": "label", "dataSourceId": "tapCountText", "styleId": "captionText" }
            ]}
          ]
        },
        {
          "id": "textfield",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 8, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "Text Field", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
          "children": [
            { "type": "textfield", "placeholder": "Enter some text...", "styleId": "textFieldStyle", "bind": "textFieldValue" },
            { "type": "hstack", "spacing": 8, "children": [
              { "type": "label", "text": "You typed:", "styleId": "captionText" },
              { "type": "label", "dataSourceId": "textFieldDisplay", "styleId": "captionText" }
            ]}
          ]
        },
        {
          "id": "toggles",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 16, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "Toggles", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
          "children": [
            { "type": "hstack", "spacing": 12, "children": [{ "type": "label", "text": "Default toggle:", "styleId": "bodyText" }, { "type": "toggle", "bind": "toggle1" }] },
            { "type": "hstack", "spacing": 12, "children": [{ "type": "label", "text": "Green toggle:", "styleId": "bodyText" }, { "type": "toggle", "bind": "toggle2", "styleId": "greenToggleStyle" }] },
            { "type": "hstack", "spacing": 12, "children": [{ "type": "label", "text": "Purple toggle:", "styleId": "bodyText" }, { "type": "toggle", "bind": "toggle3", "styleId": "purpleToggleStyle" }] }
          ]
        },
        {
          "id": "sliders",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 16, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "Sliders", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
          "children": [
            { "type": "vstack", "spacing": 8, "alignment": "leading", "children": [{ "type": "label", "text": "Default slider (0-1):", "styleId": "bodyText" }, { "type": "slider", "bind": "slider1" }] },
            { "type": "vstack", "spacing": 8, "alignment": "leading", "children": [{ "type": "label", "text": "Orange slider (0-1):", "styleId": "bodyText" }, { "type": "slider", "bind": "slider2", "styleId": "orangeSliderStyle" }] },
            { "type": "vstack", "spacing": 8, "alignment": "leading", "children": [{ "type": "label", "text": "Red slider (0-100):", "styleId": "bodyText" }, { "type": "slider", "bind": "slider3", "minValue": 0, "maxValue": 100, "styleId": "redSliderStyle" }] }
          ]
        },
        {
          "id": "images",
          "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "Images", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
          "children": [
            { "type": "hstack", "spacing": 16, "children": [
              { "type": "vstack", "spacing": 4, "children": [{ "type": "image", "image": { "sfsymbol": "star.fill" }, "styleId": "iconStyle" }, { "type": "label", "text": "Default", "styleId": "captionText" }] },
              { "type": "vstack", "spacing": 4, "children": [{ "type": "image", "image": { "sfsymbol": "heart.fill" }, "styleId": "redIconStyle" }, { "type": "label", "text": "Red", "styleId": "captionText" }] },
              { "type": "vstack", "spacing": 4, "children": [{ "type": "image", "image": { "sfsymbol": "bolt.fill" }, "styleId": "orangeIconStyle" }, { "type": "label", "text": "Orange", "styleId": "captionText" }] },
              { "type": "vstack", "spacing": 4, "children": [{ "type": "image", "image": { "sfsymbol": "globe" }, "styleId": "blueIconStyle" }, { "type": "label", "text": "Blue", "styleId": "captionText" }] }
            ]}
          ]
        },
        {
          "id": "gradient",
          "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20, "bottom": 40 } },
          "header": { "type": "label", "text": "Gradient", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
          "children": [
            { "type": "zstack", "children": [
              { "type": "gradient", "gradientColors": [{ "color": "#FF6B6B", "location": 0.0 }, { "color": "#4ECDC4", "location": 0.5 }, { "color": "#45B7D1", "location": 1.0 }], "gradientStart": "leading", "gradientEnd": "trailing", "styleId": "gradientStyle" },
              { "type": "label", "text": "Gradient Overlay", "styleId": "gradientLabel" }
            ]}
          ]
        }
      ]
    }]
  },
  "dataSources": {
    "tapCountText": { "type": "binding", "template": "${buttonTapCount}" },
    "textFieldDisplay": { "type": "binding", "template": "${textFieldValue}" }
  }
}
"""
