import Foundation

public let musicPlayerJSON = """
{
  "id": "music-player",
  "version": "1.0",
  "state": {
    "isPlaying": false,
    "currentTime": 127,
    "duration": 245,
    "volume": 0.75,
    "isShuffled": false,
    "repeatMode": "off",
    "isFavorite": false,
    "showQueue": false
  },
  "styles": {
    "albumArt": { "width": 280, "height": 280, "cornerRadius": 20 },
    "albumGradient": {
      "width": 280, "height": 280, "cornerRadius": 20
    },
    "albumIcon": { "width": 80, "height": 80, "tintColor": "#FFFFFF" },
    "songTitle": { "fontSize": 24, "fontWeight": "bold", "textColor": "#000000", "textAlignment": "center" },
    "artistName": { "fontSize": 18, "textColor": "#8E8E93", "textAlignment": "center" },
    "timeLabel": { "fontSize": 12, "fontWeight": "medium", "textColor": "#8E8E93" },
    "progressBar": { "tintColor": "#007AFF", "height": 4 },
    "controlIcon": { "width": 28, "height": 28, "tintColor": "#000000" },
    "controlIconActive": { "width": 28, "height": 28, "tintColor": "#007AFF" },
    "playButton": {
      "width": 72, "height": 72,
      "backgroundColor": "#007AFF", "cornerRadius": 36
    },
    "playIcon": { "width": 32, "height": 32, "tintColor": "#FFFFFF" },
    "skipIcon": { "width": 36, "height": 36, "tintColor": "#000000" },
    "volumeIcon": { "width": 20, "height": 20, "tintColor": "#8E8E93" },
    "volumeSlider": { "tintColor": "#007AFF" },
    "queueButton": {
      "fontSize": 14, "fontWeight": "medium",
      "backgroundColor": "#F2F2F7", "textColor": "#007AFF",
      "cornerRadius": 8, "height": 36, "padding": { "horizontal": 16 }
    },
    "shuffleButton": {
      "width": 44, "height": 44,
      "backgroundColor": "#F2F2F7", "cornerRadius": 22
    },
    "shuffleButtonActive": {
      "width": 44, "height": 44,
      "backgroundColor": "#007AFF", "cornerRadius": 22
    },
    "shuffleIcon": { "width": 20, "height": 20, "tintColor": "#8E8E93" },
    "shuffleIconActive": { "width": 20, "height": 20, "tintColor": "#FFFFFF" },
    "heartIcon": { "width": 24, "height": 24, "tintColor": "#C7C7CC" },
    "heartIconFilled": { "width": 24, "height": 24, "tintColor": "#FF3B30" },
    "queueItem": { "padding": { "vertical": 10 } },
    "queueTitle": { "fontSize": 16, "textColor": "#000000" },
    "queueArtist": { "fontSize": 14, "textColor": "#8E8E93" },
    "queueImage": { "width": 48, "height": 48, "cornerRadius": 8, "backgroundColor": "#F2F2F7" },
    "queueIcon": { "width": 24, "height": 24, "tintColor": "#007AFF" },
    "nowPlayingBadge": {
      "fontSize": 10, "fontWeight": "bold",
      "backgroundColor": "#34C759", "textColor": "#FFFFFF",
      "cornerRadius": 4, "padding": { "horizontal": 6, "vertical": 2 }
    },
    "closeButton": { "width": 28, "height": 28, "tintColor": "#8E8E93" }
  },
  "actions": {
    "close": { "type": "dismiss" },
    "togglePlay": { "type": "toggleState", "path": "isPlaying" },
    "toggleShuffle": { "type": "toggleState", "path": "isShuffled" },
    "toggleFavorite": { "type": "toggleState", "path": "isFavorite" },
    "toggleQueue": { "type": "toggleState", "path": "showQueue" },
    "skipNext": {
      "type": "showAlert",
      "title": "Next Track",
      "message": "Skipping to next song...",
      "buttons": [{ "label": "OK", "style": "default" }]
    },
    "skipPrevious": {
      "type": "showAlert",
      "title": "Previous Track",
      "message": "Going to previous song...",
      "buttons": [{ "label": "OK", "style": "default" }]
    }
  },
  "dataSources": {
    "currentTimeText": { "type": "binding", "template": "2:07" },
    "durationText": { "type": "binding", "template": "4:05" },
    "playButtonIcon": { "type": "binding", "template": "${isPlaying ? 'pause.fill' : 'play.fill'}" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 20 },
    "children": [{
      "type": "vstack",
      "spacing": 24,
      "alignment": "center",
      "padding": { "horizontal": 32 },
      "children": [
        {
          "type": "hstack", "padding": { "bottom": 8 },
          "children": [
            { "type": "spacer" },
            {
              "type": "button",
              "actions": { "onTap": "close" },
              "children": [{ "type": "image", "image": { "sfsymbol": "xmark.circle.fill" }, "styleId": "closeButton" }]
            }
          ]
        },
        {
          "type": "zstack", "styleId": "albumArt",
          "children": [
            {
              "type": "gradient",
              "gradientColors": [
                { "color": "#667eea", "location": 0.0 },
                { "color": "#764ba2", "location": 0.5 },
                { "color": "#f093fb", "location": 1.0 }
              ],
              "gradientStart": "topLeading", "gradientEnd": "bottomTrailing",
              "styleId": "albumGradient"
            },
            { "type": "image", "image": { "sfsymbol": "music.note" }, "styleId": "albumIcon" }
          ]
        },
        {
          "type": "hstack",
          "children": [
            {
              "type": "button",
              "actions": { "onTap": "toggleFavorite" },
              "children": [{
                "type": "image",
                "image": { "sfsymbol": "heart.fill" },
                "styles": { "normal": "heartIcon", "selected": "heartIconFilled" },
                "isSelectedBinding": "isFavorite"
              }]
            },
            { "type": "spacer" },
            {
              "type": "vstack", "spacing": 4, "alignment": "center",
              "children": [
                { "type": "label", "text": "Midnight Dreams", "styleId": "songTitle" },
                { "type": "label", "text": "The Synthwave Collective", "styleId": "artistName" }
              ]
            },
            { "type": "spacer" },
            { "type": "button", "text": "Queue", "styleId": "queueButton", "actions": { "onTap": "toggleQueue" } }
          ]
        },
        {
          "type": "vstack", "spacing": 8,
          "children": [
            { "type": "slider", "bind": "currentTime", "minValue": 0, "maxValue": 245, "styleId": "progressBar" },
            {
              "type": "hstack",
              "children": [
                { "type": "label", "dataSourceId": "currentTimeText", "styleId": "timeLabel" },
                { "type": "spacer" },
                { "type": "label", "dataSourceId": "durationText", "styleId": "timeLabel" }
              ]
            }
          ]
        },
        {
          "type": "hstack", "spacing": 32,
          "children": [
            {
              "type": "button",
              "styles": { "normal": "shuffleButton", "selected": "shuffleButtonActive" },
              "isSelectedBinding": "isShuffled",
              "actions": { "onTap": "toggleShuffle" },
              "children": [{
                "type": "image",
                "image": { "sfsymbol": "shuffle" },
                "styles": { "normal": "shuffleIcon", "selected": "shuffleIconActive" },
                "isSelectedBinding": "isShuffled"
              }]
            },
            {
              "type": "button",
              "actions": { "onTap": "skipPrevious" },
              "children": [{ "type": "image", "image": { "sfsymbol": "backward.fill" }, "styleId": "skipIcon" }]
            },
            {
              "type": "button", "styleId": "playButton",
              "actions": { "onTap": "togglePlay" },
              "children": [{
                "type": "image",
                "image": { "sfsymbol": "play.fill" },
                "styleId": "playIcon"
              }]
            },
            {
              "type": "button",
              "actions": { "onTap": "skipNext" },
              "children": [{ "type": "image", "image": { "sfsymbol": "forward.fill" }, "styleId": "skipIcon" }]
            },
            {
              "type": "button", "styleId": "shuffleButton",
              "children": [{
                "type": "image", "image": { "sfsymbol": "repeat" }, "styleId": "shuffleIcon"
              }]
            }
          ]
        },
        {
          "type": "hstack", "spacing": 12,
          "children": [
            { "type": "image", "image": { "sfsymbol": "speaker.fill" }, "styleId": "volumeIcon" },
            { "type": "slider", "bind": "volume", "minValue": 0, "maxValue": 1, "styleId": "volumeSlider" },
            { "type": "image", "image": { "sfsymbol": "speaker.wave.3.fill" }, "styleId": "volumeIcon" }
          ]
        },
        {
          "type": "sectionLayout",
          "sectionSpacing": 0,
          "sections": [{
            "id": "queue",
            "layout": { "type": "list", "showsDividers": true, "itemSpacing": 0 },
            "header": {
              "type": "hstack", "padding": { "vertical": 12 },
              "children": [
                { "type": "label", "text": "Up Next", "styleId": "songTitle" },
                { "type": "spacer" }
              ]
            },
            "children": [
              {
                "type": "hstack", "spacing": 12, "styleId": "queueItem",
                "children": [
                  {
                    "type": "zstack", "styleId": "queueImage",
                    "children": [{ "type": "image", "image": { "sfsymbol": "music.note" }, "styleId": "queueIcon" }]
                  },
                  {
                    "type": "vstack", "spacing": 2, "alignment": "leading",
                    "children": [
                      {
                        "type": "hstack", "spacing": 8,
                        "children": [
                          { "type": "label", "text": "Neon Lights", "styleId": "queueTitle" },
                          { "type": "label", "text": "NOW", "styleId": "nowPlayingBadge" }
                        ]
                      },
                      { "type": "label", "text": "Electric Pulse", "styleId": "queueArtist" }
                    ]
                  },
                  { "type": "spacer" }
                ]
              },
              {
                "type": "hstack", "spacing": 12, "styleId": "queueItem",
                "children": [
                  {
                    "type": "zstack", "styleId": "queueImage",
                    "children": [{ "type": "image", "image": { "sfsymbol": "music.note" }, "styleId": "queueIcon" }]
                  },
                  {
                    "type": "vstack", "spacing": 2, "alignment": "leading",
                    "children": [
                      { "type": "label", "text": "Digital Sunrise", "styleId": "queueTitle" },
                      { "type": "label", "text": "Retro Wave", "styleId": "queueArtist" }
                    ]
                  },
                  { "type": "spacer" }
                ]
              },
              {
                "type": "hstack", "spacing": 12, "styleId": "queueItem",
                "children": [
                  {
                    "type": "zstack", "styleId": "queueImage",
                    "children": [{ "type": "image", "image": { "sfsymbol": "music.note" }, "styleId": "queueIcon" }]
                  },
                  {
                    "type": "vstack", "spacing": 2, "alignment": "leading",
                    "children": [
                      { "type": "label", "text": "Cosmic Journey", "styleId": "queueTitle" },
                      { "type": "label", "text": "Space Synth", "styleId": "queueArtist" }
                    ]
                  },
                  { "type": "spacer" }
                ]
              }
            ]
          }]
        }
      ]
    }]
  }
}
"""
