//
//  PhotoTouchUpExample.swift
//  ScalsRenderer
//
//  JSON definition and example view for the Photo Touch Up bottom sheet.
//
//  Example view demonstrating the Photo Touch Up bottom sheet with custom components.
//
//  This example demonstrates:
//  - Using the CustomComponent protocol to inject custom views
//  - PhotoComparisonComponent: Before/after image reveal animation
//  - CloseButtonComponent: Circular close button
//  - Standard SCALS JSON for layout, styles, and actions
//
//  Required Assets:
//  - "touchUpBefore": The blurry/before version of the photo
//  - "touchUpAfter": The sharp/after version of the photo
//
//  Usage:
//  ```swift
//  // Present as a sheet
//  .sheet(isPresented: $showPhotoTouchUp) {
//      PhotoTouchUpExampleView()
//          .presentationDetents([.medium])
//  }
//  ```
//

import Foundation
import SwiftUI
import SCALS
import ScalsModules

// MARK: - JSON Definition

public enum PhotoTouchUpJSON {

    public static let bottomSheet = """
    {
      "id": "photoTouchUp",
      "root": {
        "backgroundColor": "#FFFFFF",
        "children": [
          {
            "type": "vstack",
            "spacing": 0,
            "padding": { "horizontal": 0, "top": 0, "bottom": 0 },
            "children": [
              {
                "type": "hstack",
                "padding": { "horizontal": 16, "top": 16, "bottom": 0 },
                "children": [
                  {
                    "type": "closeButton",
                    "actions": { "onTap": "dismiss" }
                  },
                  { "type": "spacer" }
                ]
              },
              {
                "type": "vstack",
                "spacing": 24,
                "padding": { "horizontal": 24, "top": 0, "bottom": 32 },
                "alignment": "center",
                "children": [
                  {
                    "type": "photoComparison",
                    "styleId": "photoComparison",
                    "data": {
                      "beforeImage": { "type": "static", "value": "touchUpBefore" },
                      "afterImage": { "type": "static", "value": "touchUpAfter" }
                    }
                  },
                  {
                    "type": "vstack",
                    "spacing": 8,
                    "alignment": "center",
                    "children": [
                      {
                        "type": "label",
                        "text": "Your photo is now",
                        "styleId": "titleStyle"
                      },
                      {
                        "type": "label",
                        "text": "touched up",
                        "styleId": "titleStyle"
                      }
                    ]
                  },
                  {
                    "type": "vstack",
                    "spacing": 4,
                    "alignment": "center",
                    "children": [
                      {
                        "type": "label",
                        "text": "We improved clarity on one of your photos to help it look its best. You're always in control—review, adjust, or turn it off at anytime.",
                        "styleId": "bodyStyle"
                      },
                      {
                        "type": "button",
                        "text": "Learn more about touch ups",
                        "styleId": "linkButton",
                        "actions": { "onTap": "learnMore" }
                      }
                    ]
                  },
                  {
                    "type": "button",
                    "text": "Review",
                    "styleId": "primaryButton",
                    "fillWidth": true,
                    "actions": { "onTap": "review" }
                  }
                ]
              }
            ]
          }
        ]
      },
      "styles": {
        "photoComparison": {
          "width": 200,
          "height": 267
        },
        "titleStyle": {
          "fontSize": 28,
          "fontWeight": "bold",
          "textColor": "#1A1A1A",
          "textAlignment": "center"
        },
        "bodyStyle": {
          "fontSize": 14,
          "fontWeight": "regular",
          "textColor": "#666666",
          "textAlignment": "center"
        },
        "linkButton": {
          "fontSize": 14,
          "fontWeight": "regular",
          "textColor": "#1A1A1A"
        },
        "primaryButton": {
          "fontSize": 16,
          "fontWeight": "semibold",
          "textColor": "#FFFFFF",
          "backgroundColor": "#1A1A1A",
          "cornerRadius": 28,
          "height": 56
        }
      },
      "actions": {
        "dismiss": { "type": "dismiss" },
        "learnMore": {
          "type": "showAlert",
          "title": "Learn More",
          "message": "The user pressed Learn More",
          "buttons": [
            { "text": "OK", "role": "cancel" }
          ]
        },
        "review": {
          "type": "openURL",
          "url": "http://www.yahoo.com"
        }
      }
    }
    """
}

// MARK: - Example View

public struct PhotoTouchUpExampleView: View {
    public init() {}

    public var body: some View {
        if let rendererView = ScalsRendererView(
            jsonString: PhotoTouchUpJSON.bottomSheet,
            customComponents: [
                PhotoComparisonComponent.self,
                CloseButtonComponent.self
            ]
        ) {
            rendererView
        } else {
            Text("Failed to load view")
                .foregroundColor(.red)
        }
    }
}

// MARK: - Bottom Sheet Presentation Helper

public struct PhotoTouchUpBottomSheet: View {
    @Binding var isPresented: Bool

    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }

    public var body: some View {
        Color.clear
            .sheet(isPresented: $isPresented) {
                PhotoTouchUpExampleView()
                    .presentationDetents([.height(660)])
                    .presentationDragIndicator(.hidden)
            }
    }
}

// MARK: - Preview

#Preview {
    PhotoTouchUpExampleView()
}
