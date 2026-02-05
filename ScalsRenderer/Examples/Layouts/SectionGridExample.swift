import Foundation

public let sectionGridJSON = """
{
  "id": "section-grid-example",
  "version": "1.0",
  "styles": {
    "header": { "fontSize": 22, "fontWeight": "bold", "textColor": "#000000" },
    "gridItem": { "height": 100, "backgroundColor": "#F2F2F7", "cornerRadius": 12, "padding": { "all": 16 } },
    "itemIcon": { "width": 32, "height": 32, "tintColor": "#007AFF" },
    "itemLabel": { "fontSize": 12, "fontWeight": "medium", "textColor": "#333333" }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36, "bottom": 22 },
    "children": [{
      "type": "sectionLayout",
      "sections": [{
        "id": "grid-section",
        "layout": {
          "type": "grid",
          "columns": 3,
          "itemSpacing": 12,
          "lineSpacing": 12,
          "contentInsets": { "horizontal": 28 }
        },
        "header": {
          "type": "label", "text": "Categories", "styleId": "header",
          "padding": { "bottom": 12 }
        },
        "children": [
          { "type": "vstack", "spacing": 8, "styleId": "gridItem", "children": [{ "type": "image", "image": { "sfsymbol": "photo.fill" }, "styleId": "itemIcon" }, { "type": "label", "text": "Photos", "styleId": "itemLabel" }] },
          { "type": "vstack", "spacing": 8, "styleId": "gridItem", "children": [{ "type": "image", "image": { "sfsymbol": "video.fill" }, "styleId": "itemIcon" }, { "type": "label", "text": "Videos", "styleId": "itemLabel" }] },
          { "type": "vstack", "spacing": 8, "styleId": "gridItem", "children": [{ "type": "image", "image": { "sfsymbol": "doc.fill" }, "styleId": "itemIcon" }, { "type": "label", "text": "Files", "styleId": "itemLabel" }] },
          { "type": "vstack", "spacing": 8, "styleId": "gridItem", "children": [{ "type": "image", "image": { "sfsymbol": "music.note" }, "styleId": "itemIcon" }, { "type": "label", "text": "Music", "styleId": "itemLabel" }] },
          { "type": "vstack", "spacing": 8, "styleId": "gridItem", "children": [{ "type": "image", "image": { "sfsymbol": "book.fill" }, "styleId": "itemIcon" }, { "type": "label", "text": "Books", "styleId": "itemLabel" }] },
          { "type": "vstack", "spacing": 8, "styleId": "gridItem", "children": [{ "type": "image", "image": { "sfsymbol": "gamecontroller.fill" }, "styleId": "itemIcon" }, { "type": "label", "text": "Games", "styleId": "itemLabel" }] }
        ]
      }]
    }]
  }
}
"""
