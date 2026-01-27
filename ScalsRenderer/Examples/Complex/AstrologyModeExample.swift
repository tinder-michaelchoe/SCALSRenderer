import Foundation

public let astrologyModeJSON = """
{
  "id": "astrology-mode-screen",
  "version": "1.0",
  "root": {
    "backgroundColor": "#2D0025",
    "edgeInsets": {
      "leading": 0,
      "trailing": 0,
      "top": 0,
      "bottom": 0
    },
    "children": [
      {
        "type": "zstack",
        "children": [
          {
            "type": "vstack",
            "spacing": 0,
            "children": [
              {
                "type": "image",
                "image": {
                  "asset": "astrology"
                },
                "styleId": "heroImage"
              },
              {
                "type": "gradient",
                "gradientColors": [
                  {
                    "color": "#240B84",
                    "location": 0.0
                  },
                  {
                    "color": "#200867",
                    "location": 0.5
                  },
                  {
                    "color": "#2D0025",
                    "location": 1.0
                  }
                ],
                "gradientStart": "top",
                "gradientEnd": "bottom",
                "styleId": "gradientFill"
              }
            ]
          },
          {
            "type": "vstack",
            "spacing": 20,
            "padding": {
              "horizontal": 24,
              "vertical": 20
            },
            "children": [
              {
                "type": "hstack",
                "children": [
                  {
                    "type": "button",
                    "image": {
                      "sfsymbol": "xmark"
                    },
                    "styleId": "closeButton",
                    "actions": {
                      "onTap": {
                        "type": "dismiss"
                      }
                    }
                  },
                  {
                    "type": "spacer"
                  }
                ]
              },
              {
                "type": "spacer"
              },
              {
                "type": "label",
                "text": "Try Astrology Mode",
                "styleId": "title"
              },
              {
                "type": "label",
                "text": "Astrology Mode gives you quick, fun insights into how you and potential matches vibe astrologically.",
                "styleId": "subtitle"
              },
              {
                "type": "spacer"
              },
              {
                "type": "button",
                "text": "Continue",
                "styleId": "continueButton",
                "fillWidth": true
              },
              {
                "type": "button",
                "text": "Maybe later",
                "styleId": "maybeLaterButton",
                "actions": {
                  "onTap": {
                    "type": "dismiss"
                  }
                }
              }
            ]
          }
        ]
      }
    ]
  },
  "styles": {
    "heroImage": {
      "height": 280
    },
    "gradientFill": {
      "minHeight": 400
    },
    "closeButton": {
      "tintColor": "#FFFFFF",
      "backgroundColor": "rgba(0, 0, 0, 0.2)",
      "cornerRadius": 22,
      "width": 44,
      "height": 44
    },
    "title": {
      "fontSize": 32,
      "fontWeight": "bold",
      "textColor": "#FFFFFF",
      "textAlignment": "center"
    },
    "subtitle": {
      "fontSize": 17,
      "textColor": "rgba(255, 255, 255, 0.85)",
      "textAlignment": "center"
    },
    "continueButton": {
      "backgroundColor": "#FFFFFF",
      "cornerRadius": 28,
      "padding": {
        "vertical": 16,
        "horizontal": 32
      },
      "textColor": "#240B84",
      "fontSize": 17,
      "fontWeight": "semibold",
      "textAlignment": "center",
      "minWidth": 200
    },
    "maybeLaterButton": {
      "fontSize": 17,
      "textColor": "#FFFFFF",
      "textAlignment": "center"
    }
  }
}
"""
