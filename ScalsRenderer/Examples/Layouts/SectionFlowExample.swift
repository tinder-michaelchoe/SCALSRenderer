import Foundation

public let sectionFlowJSON = """
{
  "id": "section-flow-example",
  "version": "1.0",
  "state": { "selected": [] },
  "styles": {
    "header": { "fontSize": 22, "fontWeight": "bold", "textColor": "#000000" },
    "tag": {
      "fontSize": 14, "fontWeight": "medium",
      "backgroundColor": "#F2F2F7", "textColor": "#333333",
      "cornerRadius": 16, "height": 32, "padding": { "horizontal": 14 }
    },
    "tagSelected": {
      "fontSize": 14, "fontWeight": "semibold",
      "backgroundColor": "#007AFF", "textColor": "#FFFFFF",
      "cornerRadius": 16, "height": 32, "padding": { "horizontal": 14 }
    }
  },
  "root": {
    "backgroundColor": "#FFFFFF",
    "edgeInsets": { "top": 36 },
    "children": [{
      "type": "sectionLayout",
      "sections": [{
        "id": "flow-section",
        "layout": {
          "type": "flow",
          "itemSpacing": 8,
          "lineSpacing": 10,
          "contentInsets": { "horizontal": 28 }
        },
        "header": {
          "type": "label", "text": "Select Tags", "styleId": "header",
          "padding": { "bottom": 12 }
        },
        "children": [
          { "type": "button", "text": "Swift", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('Swift')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "Swift" } } },
          { "type": "button", "text": "iOS", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('iOS')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "iOS" } } },
          { "type": "button", "text": "SwiftUI", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('SwiftUI')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "SwiftUI" } } },
          { "type": "button", "text": "UIKit", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('UIKit')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "UIKit" } } },
          { "type": "button", "text": "Combine", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('Combine')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "Combine" } } },
          { "type": "button", "text": "Async/Await", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('Async/Await')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "Async/Await" } } },
          { "type": "button", "text": "Core Data", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('Core Data')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "Core Data" } } },
          { "type": "button", "text": "CloudKit", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('CloudKit')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "CloudKit" } } },
          { "type": "button", "text": "Networking", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('Networking')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "Networking" } } },
          { "type": "button", "text": "Testing", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('Testing')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "Testing" } } },
          { "type": "button", "text": "Animations", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('Animations')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "Animations" } } },
          { "type": "button", "text": "ARKit", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('ARKit')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "ARKit" } } },
          { "type": "button", "text": "Metal", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('Metal')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "Metal" } } },
          { "type": "button", "text": "MapKit", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('MapKit')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "MapKit" } } },
          { "type": "button", "text": "WidgetKit", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('WidgetKit')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "WidgetKit" } } },
          { "type": "button", "text": "App Clips", "styles": { "normal": "tag", "selected": "tagSelected" }, "isSelectedBinding": "${selected.contains('App Clips')}", "actions": { "onTap": { "type": "toggleInArray", "path": "selected", "value": "App Clips" } } }
        ]
      }]
    }]
  }
}
"""
