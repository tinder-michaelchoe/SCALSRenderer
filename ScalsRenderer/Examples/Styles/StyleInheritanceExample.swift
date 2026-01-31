import Foundation

public let styleInheritanceJSON = """
{
  "id": "styleinheritance-example",
  "version": "1.0",
  "styles": {
    "sectionTitle": { "fontSize": 16, "fontWeight": "semibold", "textColor": "#000000", "padding": { "top": 20, "bottom": 8 } },
    "description": { "fontSize": 13, "textColor": "#666666", "padding": { "bottom": 8 } },
    "codeLabel": { "fontSize": 12, "fontFamily": "Menlo", "textColor": "#D32F2F", "backgroundColor": "#F8F8F8", "cornerRadius": 4, "padding": { "horizontal": 6, "vertical": 3 } },

    "baseButton": {
      "fontSize": 16, "fontWeight": "semibold",
      "cornerRadius": 10, "height": 44,
      "padding": { "horizontal": 20 }
    },
    "primaryButton": {
      "inherits": "baseButton",
      "backgroundColor": "#007AFF", "textColor": "#FFFFFF"
    },
    "secondaryButton": {
      "inherits": "baseButton",
      "backgroundColor": "#E5E5EA", "textColor": "#000000"
    },
    "dangerButton": {
      "inherits": "baseButton",
      "backgroundColor": "#FF3B30", "textColor": "#FFFFFF"
    },

    "baseCard": {
      "backgroundColor": "#F2F2F7",
      "cornerRadius": 12,
      "padding": { "horizontal": 16, "vertical": 20 }
    },
    "accentCard": {
      "inherits": "baseCard",
      "backgroundColor": "#E3F2FD"
    },
    "accentCardBold": {
      "inherits": "accentCard",
      "backgroundColor": "#007AFF",
      "padding": { "horizontal": 20, "vertical": 20 }
    },

    "baseText": {
      "fontSize": 16,
      "textColor": "#333333"
    },
    "mediumText": {
      "inherits": "baseText",
      "fontWeight": "medium"
    },
    "largeBoldText": {
      "inherits": "mediumText",
      "fontSize": 20,
      "fontWeight": "bold",
      "textColor": "#000000"
    },

    "roundedButton": {
      "fontSize": 14,
      "fontWeight": "medium",
      "cornerRadius": 20,
      "height": 40,
      "padding": { "horizontal": 16 }
    },
    "blueRoundedButton": {
      "inherits": "roundedButton",
      "backgroundColor": "#007AFF",
      "textColor": "#FFFFFF"
    },
    "largeBlueRoundedButton": {
      "inherits": "blueRoundedButton",
      "fontSize": 16,
      "height": 50,
      "cornerRadius": 25
    },

    "compactButton": {
      "inherits": "baseButton",
      "fontSize": 14,
      "height": 36,
      "padding": { "horizontal": 12 }
    },
    "compactPrimaryButton": {
      "inherits": "compactButton",
      "backgroundColor": "#007AFF",
      "textColor": "#FFFFFF"
    },
    "overriddenCompactButton": {
      "inherits": "compactPrimaryButton",
      "fontSize": 18,
      "height": 50,
      "backgroundColor": "#34C759",
      "cornerRadius": 25
    }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 44 },
    "children": [{
      "type": "sectionLayout",
      "sectionSpacing": 16,
      "sections": [
        {
          "id": "basic",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 12, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "1. Basic Inheritance", "styleId": "sectionTitle" },
          "children": [
            { "type": "label", "text": "All buttons inherit common properties from baseButton", "styleId": "description" },
            { "type": "label", "text": "inherits: baseButton", "styleId": "codeLabel" },
            { "type": "button", "text": "Primary", "styleId": "primaryButton" },
            { "type": "button", "text": "Secondary", "styleId": "secondaryButton" },
            { "type": "button", "text": "Danger", "styleId": "dangerButton" }
          ]
        },
        {
          "id": "multilevel",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 12, "alignment": "center", "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "2. Multi-Level Inheritance (Grandparent → Parent → Child)", "styleId": "sectionTitle" },
          "children": [
            { "type": "label", "text": "Child inherits from parent, parent inherits from grandparent", "styleId": "description" },
            {
              "type": "vstack",
              "spacing": 8,
              "alignment": "leading",
              "styleId": "baseCard",
              "children": [
                { "type": "label", "text": "Level 1: baseCard", "styleId": "codeLabel" },
                { "type": "label", "text": "Gray bg (#F2F2F7), 12px radius, 16px padding", "fontSize": 12, "textColor": "#666666" }
              ]
            },
            {
              "type": "vstack",
              "spacing": 8,
              "alignment": "leading",
              "styleId": "accentCard",
              "children": [
                { "type": "label", "text": "Level 2: accentCard (inherits: baseCard)", "styleId": "codeLabel" },
                { "type": "label", "text": "Light blue bg (#E3F2FD) overrides gray", "fontSize": 12, "textColor": "#1976D2" }
              ]
            },
            {
              "type": "vstack",
              "spacing": 8,
              "alignment": "leading",
              "styleId": "accentCardBold",
              "children": [
                { "type": "label", "text": "Level 3: accentCardBold (inherits: accentCard)", "styleId": "codeLabel" },
                { "type": "label", "text": "Dark blue bg (#007AFF), 20px padding (overridden)", "fontSize": 12, "textColor": "#FFFFFF" }
              ]
            }
          ]
        },
        {
          "id": "textchain",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 12, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "3. Text Style Chain", "styleId": "sectionTitle" },
          "children": [
            { "type": "label", "text": "Each level adds or overrides properties", "styleId": "description" },
            { "type": "label", "text": "Base: 16px, gray", "styleId": "baseText" },
            { "type": "label", "text": "Medium: 16px, gray, medium weight", "styleId": "mediumText" },
            { "type": "label", "text": "Large Bold: 20px, black, bold", "styleId": "largeBoldText" }
          ]
        },
        {
          "id": "buttonchain",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 12, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "4. Button Chain (3 Levels)", "styleId": "sectionTitle" },
          "children": [
            { "type": "label", "text": "roundedButton → blueRoundedButton → largeBlueRoundedButton", "styleId": "description" },
            { "type": "button", "text": "Small Rounded", "styleId": "blueRoundedButton" },
            { "type": "button", "text": "Large Rounded", "styleId": "largeBlueRoundedButton" }
          ]
        },
        {
          "id": "override",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 12, "contentInsets": { "horizontal": 20, "bottom": 36 } },
          "header": { "type": "label", "text": "5. Child Overriding Parent", "styleId": "sectionTitle" },
          "children": [
            { "type": "label", "text": "Child can override any inherited property", "styleId": "description" },
            { "type": "label", "text": "baseButton → compactButton → compactPrimaryButton → overriddenCompactButton", "styleId": "codeLabel" },
            { "type": "button", "text": "Compact Primary (blue, small)", "styleId": "compactPrimaryButton" },
            { "type": "button", "text": "Overridden (green, large, more rounded)", "styleId": "overriddenCompactButton" },
            { "type": "label", "text": "Overrides: fontSize (18), height (50), backgroundColor (green), cornerRadius (25)", "styleId": "description" }
          ]
        }
      ]
    }]
  }
}
"""
