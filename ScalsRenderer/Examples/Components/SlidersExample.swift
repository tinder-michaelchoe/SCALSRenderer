import Foundation

public let slidersJSON = """
{
  "id": "sliders-example",
  "version": "1.0",
  "state": { "volume": 0.5, "brightness": 0.75, "temperature": 72 },
  "styles": {
    "label": { "fontSize": 16, "textColor": "#000000" },
    "value": { "fontSize": 14, "fontWeight": "medium", "textColor": "#007AFF" },
    "blueTint": { "tintColor": "#007AFF" },
    "orangeTint": { "tintColor": "#FF9500" },
    "redTint": { "tintColor": "#FF3B30" }
  },
  "dataSources": {
    "volumeText": { "type": "binding", "template": "${volume}" },
    "brightnessText": { "type": "binding", "template": "${brightness}" },
    "tempText": { "type": "binding", "template": "${temperature}F" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "leading": 28, "trailing": 28 },
    "children": [{
      "type": "vstack",
      "spacing": 24,
      "children": [
        {
          "type": "vstack", "spacing": 8, "alignment": "leading",
          "children": [
            {
              "type": "hstack",
              "children": [
                { "type": "label", "text": "Volume", "styleId": "label" },
                { "type": "spacer" },
                { "type": "label", "dataSourceId": "volumeText", "styleId": "value" }
              ]
            },
            { "type": "slider", "bind": "volume", "styleId": "blueTint" }
          ]
        },
        {
          "type": "vstack", "spacing": 8, "alignment": "leading",
          "children": [
            {
              "type": "hstack",
              "children": [
                { "type": "label", "text": "Brightness", "styleId": "label" },
                { "type": "spacer" },
                { "type": "label", "dataSourceId": "brightnessText", "styleId": "value" }
              ]
            },
            { "type": "slider", "bind": "brightness", "styleId": "orangeTint" }
          ]
        },
        {
          "type": "vstack", "spacing": 8, "alignment": "leading",
          "children": [
            {
              "type": "hstack",
              "children": [
                { "type": "label", "text": "Temperature", "styleId": "label" },
                { "type": "spacer" },
                { "type": "label", "dataSourceId": "tempText", "styleId": "value" }
              ]
            },
            { "type": "slider", "bind": "temperature", "minValue": 60, "maxValue": 90, "styleId": "redTint" }
          ]
        },
        { "type": "spacer" }
      ]
    }]
  }
}
"""
