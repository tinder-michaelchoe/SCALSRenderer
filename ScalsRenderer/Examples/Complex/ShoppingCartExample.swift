import Foundation

public let shoppingCartJSON = """
{
  "id": "shopping-cart",
  "version": "1.0",
  "state": {
    "cartItems": [
      { "name": "Wireless Headphones", "price": 199.99, "quantity": 1, "image": "headphones" },
      { "name": "Smart Watch", "price": 299.99, "quantity": 1, "image": "applewatch" },
      { "name": "Phone Case", "price": 29.99, "quantity": 2, "image": "iphone" }
    ],
    "promoCode": "",
    "promoApplied": false
  },
  "styles": {
    "screenTitle": { "fontSize": 28, "fontWeight": "bold", "textColor": "#000000" },
    "itemCount": { "fontSize": 14, "textColor": "#8E8E93" },
    "sectionHeader": { "fontSize": 16, "fontWeight": "semibold", "textColor": "#000000" },
    "productImage": { "width": 80, "height": 80, "backgroundColor": "#F2F2F7", "cornerRadius": 12 },
    "productIcon": { "width": 40, "height": 40, "tintColor": "#007AFF" },
    "productName": { "fontSize": 16, "fontWeight": "medium", "textColor": "#000000" },
    "productPrice": { "fontSize": 14, "fontWeight": "semibold", "textColor": "#007AFF" },
    "quantityLabel": { "fontSize": 14, "textColor": "#8E8E93" },
    "quantityValue": { "fontSize": 16, "fontWeight": "semibold", "textColor": "#000000" },
    "quantityButton": {
      "fontSize": 18, "fontWeight": "bold",
      "backgroundColor": "#F2F2F7", "textColor": "#007AFF",
      "cornerRadius": 8, "width": 32, "height": 32
    },
    "removeButton": { "fontSize": 14, "textColor": "#FF3B30" },
    "promoField": {
      "fontSize": 16, "textColor": "#000000",
      "backgroundColor": "#F2F2F7", "cornerRadius": 10,
      "padding": { "horizontal": 14, "vertical": 12 }
    },
    "applyButton": {
      "fontSize": 14, "fontWeight": "semibold",
      "backgroundColor": "#34C759", "textColor": "#FFFFFF",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 16 }
    },
    "summaryRow": { "fontSize": 16, "textColor": "#000000" },
    "summaryLabel": { "fontSize": 16, "textColor": "#8E8E93" },
    "totalLabel": { "fontSize": 18, "fontWeight": "bold", "textColor": "#000000" },
    "totalValue": { "fontSize": 24, "fontWeight": "bold", "textColor": "#007AFF" },
    "checkoutButton": {
      "fontSize": 18, "fontWeight": "semibold",
      "backgroundColor": "#007AFF", "textColor": "#FFFFFF",
      "cornerRadius": 14, "height": 56
    },
    "emptyCartIcon": { "width": 80, "height": 80, "tintColor": "#C7C7CC" },
    "emptyCartText": { "fontSize": 18, "fontWeight": "medium", "textColor": "#8E8E93" },
    "continueButton": {
      "fontSize": 16, "fontWeight": "medium",
      "backgroundColor": "#E5E5EA", "textColor": "#007AFF",
      "cornerRadius": 10, "height": 44, "padding": { "horizontal": 20 }
    },
    "divider": { "height": 1, "backgroundColor": "#E5E5EA" },
    "cardBackground": {
      "backgroundColor": "#FFFFFF", "cornerRadius": 16,
      "padding": { "all": 16 }
    },
    "summaryCard": {
      "backgroundColor": "#F8F8F8", "cornerRadius": 16,
      "padding": { "all": 20 }
    },
    "closeButton": { "width": 28, "height": 28, "tintColor": "#8E8E93" }
  },
  "actions": {
    "close": { "type": "dismiss" },
    "applyPromo": {
      "type": "sequence",
      "steps": [
        { "type": "setState", "path": "promoApplied", "value": true },
        {
          "type": "showAlert",
          "title": "Promo Applied!",
          "message": "You saved 10% on your order",
          "buttons": [{ "label": "Awesome!", "style": "default" }]
        }
      ]
    },
    "checkout": {
      "type": "showAlert",
      "title": "Proceed to Checkout?",
      "message": "You will be redirected to payment",
      "buttons": [
        { "label": "Cancel", "style": "cancel" },
        { "label": "Continue", "style": "default" }
      ]
    },
    "removeItem": {
      "type": "showAlert",
      "title": "Remove Item?",
      "message": "Are you sure you want to remove this item?",
      "buttons": [
        { "label": "Cancel", "style": "cancel" },
        { "label": "Remove", "style": "destructive" }
      ]
    }
  },
  "dataSources": {
    "itemCountText": { "type": "binding", "template": "${cartItems.count} items in cart" },
    "subtotal": { "type": "static", "value": "$559.96" },
    "shipping": { "type": "static", "value": "FREE" },
    "tax": { "type": "static", "value": "$44.80" },
    "total": { "type": "static", "value": "$604.76" }
  },
  "root": {
    "backgroundColor": "#F2F2F7",
    "edgeInsets": { "top": 20 },
    "children": [{
      "type": "sectionLayout",
      "sectionSpacing": 16,
      "sections": [
        {
          "id": "header",
          "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20 } },
          "children": [
            {
              "type": "hstack",
              "children": [
                {
                  "type": "vstack", "alignment": "leading", "spacing": 4,
                  "children": [
                    { "type": "label", "text": "Shopping Cart", "styleId": "screenTitle" },
                    { "type": "label", "dataSourceId": "itemCountText", "styleId": "itemCount" }
                  ]
                },
                { "type": "spacer" },
                {
                  "type": "button",
                  "actions": { "onTap": "close" },
                  "children": [{ "type": "image", "image": { "sfsymbol": "xmark.circle.fill" }, "styleId": "closeButton" }]
                }
              ]
            }
          ]
        },
        {
          "id": "items",
          "layout": { "type": "list", "showsDividers": false, "itemSpacing": 12, "contentInsets": { "horizontal": 20 } },
          "children": [
            {
              "type": "hstack", "spacing": 16, "styleId": "cardBackground",
              "children": [
                {
                  "type": "zstack", "styleId": "productImage",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "headphones" }, "styleId": "productIcon" }
                  ]
                },
                {
                  "type": "vstack", "spacing": 6, "alignment": "leading",
                  "children": [
                    { "type": "label", "text": "Wireless Headphones", "styleId": "productName" },
                    { "type": "label", "text": "$199.99", "styleId": "productPrice" },
                    {
                      "type": "hstack", "spacing": 12,
                      "children": [
                        { "type": "button", "text": "-", "styleId": "quantityButton" },
                        { "type": "label", "text": "1", "styleId": "quantityValue" },
                        { "type": "button", "text": "+", "styleId": "quantityButton" }
                      ]
                    }
                  ]
                },
                { "type": "spacer" },
                { "type": "button", "text": "Remove", "styleId": "removeButton", "actions": { "onTap": "removeItem" } }
              ]
            },
            {
              "type": "hstack", "spacing": 16, "styleId": "cardBackground",
              "children": [
                {
                  "type": "zstack", "styleId": "productImage",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "applewatch" }, "styleId": "productIcon" }
                  ]
                },
                {
                  "type": "vstack", "spacing": 6, "alignment": "leading",
                  "children": [
                    { "type": "label", "text": "Smart Watch", "styleId": "productName" },
                    { "type": "label", "text": "$299.99", "styleId": "productPrice" },
                    {
                      "type": "hstack", "spacing": 12,
                      "children": [
                        { "type": "button", "text": "-", "styleId": "quantityButton" },
                        { "type": "label", "text": "1", "styleId": "quantityValue" },
                        { "type": "button", "text": "+", "styleId": "quantityButton" }
                      ]
                    }
                  ]
                },
                { "type": "spacer" },
                { "type": "button", "text": "Remove", "styleId": "removeButton", "actions": { "onTap": "removeItem" } }
              ]
            },
            {
              "type": "hstack", "spacing": 16, "styleId": "cardBackground",
              "children": [
                {
                  "type": "zstack", "styleId": "productImage",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "iphone" }, "styleId": "productIcon" }
                  ]
                },
                {
                  "type": "vstack", "spacing": 6, "alignment": "leading",
                  "children": [
                    { "type": "label", "text": "Phone Case", "styleId": "productName" },
                    { "type": "label", "text": "$29.99", "styleId": "productPrice" },
                    {
                      "type": "hstack", "spacing": 12,
                      "children": [
                        { "type": "button", "text": "-", "styleId": "quantityButton" },
                        { "type": "label", "text": "2", "styleId": "quantityValue" },
                        { "type": "button", "text": "+", "styleId": "quantityButton" }
                      ]
                    }
                  ]
                },
                { "type": "spacer" },
                { "type": "button", "text": "Remove", "styleId": "removeButton", "actions": { "onTap": "removeItem" } }
              ]
            }
          ]
        },
        {
          "id": "promo",
          "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20 } },
          "children": [
            {
              "type": "vstack", "spacing": 12, "styleId": "cardBackground",
              "children": [
                { "type": "label", "text": "Promo Code", "styleId": "sectionHeader" },
                {
                  "type": "hstack", "spacing": 12,
                  "children": [
                    { "type": "textfield", "placeholder": "Enter code", "styleId": "promoField", "bind": "promoCode" },
                    { "type": "button", "text": "Apply", "styleId": "applyButton", "actions": { "onTap": "applyPromo" } }
                  ]
                }
              ]
            }
          ]
        },
        {
          "id": "summary",
          "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20, "bottom": 20 } },
          "children": [
            {
              "type": "vstack", "spacing": 16, "styleId": "summaryCard",
              "children": [
                { "type": "label", "text": "Order Summary", "styleId": "sectionHeader" },
                {
                  "type": "hstack",
                  "children": [
                    { "type": "label", "text": "Subtotal", "styleId": "summaryLabel" },
                    { "type": "spacer" },
                    { "type": "label", "dataSourceId": "subtotal", "styleId": "summaryRow" }
                  ]
                },
                {
                  "type": "hstack",
                  "children": [
                    { "type": "label", "text": "Shipping", "styleId": "summaryLabel" },
                    { "type": "spacer" },
                    { "type": "label", "dataSourceId": "shipping", "styleId": "summaryRow" }
                  ]
                },
                {
                  "type": "hstack",
                  "children": [
                    { "type": "label", "text": "Tax", "styleId": "summaryLabel" },
                    { "type": "spacer" },
                    { "type": "label", "dataSourceId": "tax", "styleId": "summaryRow" }
                  ]
                },
                { "type": "gradient", "gradientColors": [{"color": "#E5E5EA", "location": 0}], "styleId": "divider" },
                {
                  "type": "hstack",
                  "children": [
                    { "type": "label", "text": "Total", "styleId": "totalLabel" },
                    { "type": "spacer" },
                    { "type": "label", "dataSourceId": "total", "styleId": "totalValue" }
                  ]
                },
                { "type": "button", "text": "Proceed to Checkout", "styleId": "checkoutButton", "fillWidth": true, "actions": { "onTap": "checkout" } }
              ]
            }
          ]
        }
      ]
    }]
  }
}
"""
