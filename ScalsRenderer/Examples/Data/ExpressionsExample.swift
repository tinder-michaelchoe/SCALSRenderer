import Foundation

public let expressionsJSON = """
{
  "id": "interpolation-example",
  "version": "1.0",
  "state": {
    "firstName": "John",
    "lastName": "Doe",
    "score": 85,
    "level": 3,
    "currentIndex": 0,
    "items": ["🍎 Apple", "🍌 Banana", "🍒 Cherry", "🍇 Grapes"],
    "isLoggedIn": true
  },
  "actions": {
    "nextItem": {
      "type": "setState",
      "path": "currentIndex",
      "value": { "$expr": "(currentIndex + 1) % 4" }
    },
    "prevItem": {
      "type": "setState",
      "path": "currentIndex",
      "value": { "$expr": "(currentIndex + 3) % 4" }
    },
    "increaseScore": {
      "type": "setState",
      "path": "score",
      "value": { "$expr": "score + 10" }
    },
    "decreaseScore": {
      "type": "setState",
      "path": "score",
      "value": { "$expr": "score - 10" }
    },
    "incrementScore": {
      "type": "setState",
      "path": "score",
      "value": { "$expr": "score + 1" }
    },
    "decrementScore": {
      "type": "setState",
      "path": "score",
      "value": { "$expr": "score - 1" }
    },
    "levelUp": {
      "type": "setState",
      "path": "level",
      "value": { "$expr": "level + 1" }
    },
    "toggleLogin": {
      "type": "toggleState",
      "path": "isLoggedIn"
    }
  },
  "styles": {
    "title": { "fontSize": 20, "fontWeight": "bold", "textColor": "#000000" },
    "sectionTitle": { "fontSize": 16, "fontWeight": "semibold", "textColor": "#000000", "padding": { "top": 12, "bottom": 8 } },
    "label": { "fontSize": 14, "textColor": "#666666", "padding": { "bottom": 4 } },
    "value": { "fontSize": 16, "fontWeight": "medium", "textColor": "#007AFF" },
    "result": {
      "fontSize": 15, "textColor": "#007AFF",
      "backgroundColor": "#E3F2FD", "cornerRadius": 8,
      "padding": { "horizontal": 12, "vertical": 10 }
    },
    "highlight": {
      "fontSize": 18, "fontWeight": "semibold", "textColor": "#1B5E20",
      "backgroundColor": "#C8E6C9", "cornerRadius": 10,
      "padding": { "all": 16 }, "textAlignment": "center"
    },
    "code": {
      "fontSize": 13, "fontFamily": "Menlo",
      "textColor": "#D32F2F",
      "backgroundColor": "#F2F2F7", "cornerRadius": 6,
      "padding": { "horizontal": 8, "vertical": 4 }
    },
    "button": {
      "fontSize": 14, "fontWeight": "medium",
      "backgroundColor": "#007AFF", "textColor": "#FFFFFF",
      "height": 38, "cornerRadius": 8
    },
    "smallButton": {
      "fontSize": 13, "fontWeight": "medium",
      "backgroundColor": "#34C759", "textColor": "#FFFFFF",
      "height": 34, "cornerRadius": 8
    },
    "toggleButton": {
      "fontSize": 14, "fontWeight": "medium",
      "backgroundColor": "#007AFF", "textColor": "#FFFFFF",
      "height": 38, "cornerRadius": 8,
      "padding": { "horizontal": 24 }
    }
  },
  "dataSources": {
    "greeting": { "type": "binding", "template": "Hello, ${firstName} ${lastName}!" },
    "scoreDisplay": { "type": "binding", "template": "Score: ${score}" },
    "nextLevel": { "type": "binding", "template": "Next Level: ${(level + 1)}" },
    "scoreMultiLevel": { "type": "binding", "template": "Total: ${((score + 10) * level)}" },
    "levelProgress": { "type": "binding", "template": "Level ${level} (${(score % 100)}%)" },
    "currentItem": { "type": "binding", "template": "${items[currentIndex]}" },
    "itemPosition": { "type": "binding", "template": "Item ${(currentIndex + 1)} of ${items.count}" },
    "firstItem": { "type": "binding", "template": "First: ${items.first}" },
    "lastItem": { "type": "binding", "template": "Last: ${items.last}" },
    "arraySize": { "type": "binding", "template": "Array has ${items.count} items" },
    "loginStatus": { "type": "binding", "template": "${isLoggedIn ? '✓ Logged In' : '✗ Logged Out'}" },
    "scoreCalc": { "type": "binding", "template": "Double: ${(score * 2)}, Half: ${(score / 2)}, Mod 10: ${(score % 10)}" }
  },
  "root": {
    "backgroundColor": "#F2F2F7",
    "children": [{
      "type": "sectionLayout",
      "sectionSpacing": 20,
      "sections": [
        {
          "id": "header",
          "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20 } },
          "children": [
            { "type": "label", "text": "Expressions", "styleId": "title", "padding": { "top": 36, "bottom": 8 } },
            { "type": "label", "text": "Arithmetic, templates, arrays, ternary & cycling", "styleId": "label" }
          ]
        },
        {
          "id": "basic",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 8, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "1. Basic Template Interpolation", "styleId": "sectionTitle" },
          "children": [
            { "type": "label", "text": "Combine firstName and lastName", "styleId": "code" },
            { "type": "label", "dataSourceId": "greeting", "styleId": "result" }
          ]
        },
        {
          "id": "arithmetic",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 10, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "2. Arithmetic in Templates", "styleId": "sectionTitle" },
          "children": [
            { "type": "label", "dataSourceId": "scoreDisplay", "styleId": "highlight" },
            {
              "type": "hstack", "spacing": 8,
              "children": [
                { "type": "button", "text": "-1", "styleId": "button", "fillWidth": true, "actions": { "onTap": "decrementScore" } },
                { "type": "button", "text": "+1", "styleId": "button", "fillWidth": true, "actions": { "onTap": "incrementScore" } },
                { "type": "button", "text": "-10", "styleId": "button", "fillWidth": true, "actions": { "onTap": "decreaseScore" } },
                { "type": "button", "text": "+10", "styleId": "button", "fillWidth": true, "actions": { "onTap": "increaseScore" } }
              ]
            },
            { "type": "label", "text": "Addition: level + 1", "styleId": "code" },
            { "type": "label", "dataSourceId": "nextLevel", "styleId": "value" },
            { "type": "label", "text": "Multiple operations: * 2, / 2, % 10", "styleId": "code" },
            { "type": "label", "dataSourceId": "scoreCalc", "styleId": "value" }
          ]
        },
        {
          "id": "complex",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 10, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "3. Complex Expressions with Parentheses", "styleId": "sectionTitle" },
          "children": [
            { "type": "label", "text": "Modulo: (score % 100)", "styleId": "code" },
            { "type": "label", "dataSourceId": "levelProgress", "styleId": "value" },
            { "type": "label", "text": "Nested: ((score + 10) * level)", "styleId": "code" },
            { "type": "label", "dataSourceId": "scoreMultiLevel", "styleId": "value" }
          ]
        },
        {
          "id": "arrays",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 10, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "4. Dynamic Array Indexing", "styleId": "sectionTitle" },
          "children": [
            { "type": "label", "text": "Access: items[currentIndex]", "styleId": "code" },
            { "type": "label", "dataSourceId": "currentItem", "styleId": "highlight" },
            { "type": "label", "dataSourceId": "itemPosition", "styleId": "value" },
            {
              "type": "hstack", "spacing": 8,
              "children": [
                { "type": "button", "text": "← Previous", "styleId": "smallButton", "fillWidth": true, "actions": { "onTap": "prevItem" } },
                { "type": "button", "text": "Next →", "styleId": "smallButton", "fillWidth": true, "actions": { "onTap": "nextItem" } }
              ]
            },
            { "type": "label", "text": "Cycle uses: (currentIndex + 1) % 4", "styleId": "label" }
          ]
        },
        {
          "id": "properties",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 8, "contentInsets": { "horizontal": 20 } },
          "header": { "type": "label", "text": "5. Array Properties", "styleId": "sectionTitle" },
          "children": [
            { "type": "label", "text": "Properties: .count, .first, .last", "styleId": "code" },
            { "type": "label", "dataSourceId": "arraySize", "styleId": "value" },
            { "type": "label", "dataSourceId": "firstItem", "styleId": "value" },
            { "type": "label", "dataSourceId": "lastItem", "styleId": "value" }
          ]
        },
        {
          "id": "ternary",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 8, "contentInsets": { "horizontal": 20, "bottom": 36 } },
          "header": { "type": "label", "text": "6. Ternary Expressions", "styleId": "sectionTitle" },
          "children": [
            { "type": "label", "text": "Boolean: isLoggedIn ? 'Logged In' : 'Logged Out'", "styleId": "code" },
            { "type": "label", "dataSourceId": "loginStatus", "styleId": "result" },
            { "type": "button", "text": "Toggle Login", "styleId": "toggleButton", "actions": { "onTap": "toggleLogin" } }
          ]
        }
      ]
    }]
  }
}
"""
