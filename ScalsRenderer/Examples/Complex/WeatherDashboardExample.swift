import Foundation

public let weatherDashboardJSON = """
{
  "id": "weather-dashboard",
  "version": "1.0",
  "state": {
    "location": "Loading...",
    "currentDate": "Loading...",
    "temperature": 72,
    "feelsLike": 68,
    "humidity": 65,
    "windSpeed": 12,
    "uvIndex": 6,
    "visibility": 10,
    "condition": "Partly Cloudy",
    "conditionIcon": "cloud.sun.fill",
    "isLoading": true,
    "selectedDay": 0,
    "hour0Temp": "--°",
    "hour0Label": "Now",
    "hour1Temp": "--°",
    "hour1Label": "--",
    "hour2Temp": "--°",
    "hour2Label": "--",
    "hour3Temp": "--°",
    "hour3Label": "--",
    "hour4Temp": "--°",
    "hour4Label": "--",
    "hour5Temp": "--°",
    "hour5Label": "--",
    "day0High": "--°",
    "day0Low": " / --°",
    "day0Label": "Today",
    "day1High": "--°",
    "day1Low": " / --°",
    "day1Label": "--",
    "day2High": "--°",
    "day2Low": " / --°",
    "day2Label": "--",
    "day3High": "--°",
    "day3Low": " / --°",
    "day3Label": "--",
    "day4High": "--°",
    "day4Low": " / --°",
    "day4Label": "--"
  },
  "styles": {
    "screenBg": {
      "backgroundColor": "#1E3A5F"
    },
    "locationText": { "fontSize": 28, "fontWeight": "bold", "textColor": "#FFFFFF" },
    "dateText": { "fontSize": 14, "textColor": "#D0D0D0" },
    "tempLarge": { "fontSize": 96, "fontWeight": "thin", "textColor": "#FFFFFF" },
    "tempUnit": { "fontSize": 32, "fontWeight": "light", "textColor": "#D0D0D0" },
    "conditionText": { "fontSize": 20, "fontWeight": "medium", "textColor": "#FFFFFF" },
    "feelsLikeText": { "fontSize": 14, "textColor": "#D0D0D0" },
    "weatherIcon": { "width": 64, "height": 64, "tintColor": "#FFD700" },
    "statCard": {
      "backgroundColor": "rgba(255,255,255,0.15)", "cornerRadius": 16,
      "padding": { "all": 16 }
    },
    "statIcon": { "width": 24, "height": 24, "tintColor": "#FFFFFF" },
    "statValue": { "fontSize": 20, "fontWeight": "semibold", "textColor": "#FFFFFF" },
    "statLabel": { "fontSize": 12, "textColor": "#D0D0D0" },
    "hourCard": {
      "backgroundColor": "rgba(255,255,255,0.1)", "cornerRadius": 20,
      "padding": { "horizontal": 16, "vertical": 20 }, "width": 70
    },
    "hourCardSelected": {
      "backgroundColor": "rgba(255,255,255,0.3)", "cornerRadius": 20,
      "padding": { "horizontal": 16, "vertical": 20 }, "width": 70
    },
    "hourText": { "fontSize": 14, "fontWeight": "medium", "textColor": "#D0D0D0" },
    "hourTemp": { "fontSize": 18, "fontWeight": "semibold", "textColor": "#FFFFFF" },
    "hourIcon": { "width": 28, "height": 28, "tintColor": "#FFD700" },
    "dayRow": { "padding": { "vertical": 12 } },
    "dayName": { "fontSize": 16, "fontWeight": "medium", "textColor": "#FFFFFF", "width": 80 },
    "dayIcon": { "width": 28, "height": 28, "tintColor": "#FFD700" },
    "dayTempHigh": { "fontSize": 16, "fontWeight": "semibold", "textColor": "#FFFFFF" },
    "dayTempLow": { "fontSize": 16, "textColor": "#B0B0B0" },
    "sectionTitle": { "fontSize": 16, "fontWeight": "semibold", "textColor": "#D0D0D0" },
    "sunTimeCard": {
      "backgroundColor": "rgba(255,255,255,0.1)", "cornerRadius": 16,
      "padding": { "all": 16 }
    },
    "sunIcon": { "width": 32, "height": 32, "tintColor": "#FFD700" },
    "sunTime": { "fontSize": 24, "fontWeight": "semibold", "textColor": "#FFFFFF" },
    "sunLabel": { "fontSize": 12, "textColor": "#D0D0D0" },
    "closeButton": { "width": 28, "height": 28, "tintColor": "#D0D0D0" }
  },
  "actions": {
    "close": { "type": "dismiss" },
    "fetchWeather": { "type": "fetchWeather" },
    "selectToday": { "type": "setState", "path": "selectedDay", "value": 0 },
    "selectTomorrow": { "type": "setState", "path": "selectedDay", "value": 1 },
    "refreshWeather": { "type": "fetchWeather" }
  },
  "dataSources": {
    "locationDisplay": { "type": "binding", "path": "location" },
    "dateDisplay": { "type": "binding", "path": "currentDate" },
    "tempDisplay": { "type": "binding", "template": "${temperature}" },
    "conditionDisplay": { "type": "binding", "path": "condition" },
    "feelsLikeDisplay": { "type": "binding", "template": "Feels like ${feelsLike}°" },
    "humidityDisplay": { "type": "binding", "template": "${humidity}%" },
    "windDisplay": { "type": "binding", "template": "${windSpeed} mph" },
    "uvDisplay": { "type": "binding", "template": "${uvIndex}" },
    "visibilityDisplay": { "type": "binding", "template": "${visibility} mi" },
    "hour0Label": { "type": "binding", "path": "hour0Label" },
    "hour0Temp": { "type": "binding", "path": "hour0Temp" },
    "hour1Label": { "type": "binding", "path": "hour1Label" },
    "hour1Temp": { "type": "binding", "path": "hour1Temp" },
    "hour2Label": { "type": "binding", "path": "hour2Label" },
    "hour2Temp": { "type": "binding", "path": "hour2Temp" },
    "hour3Label": { "type": "binding", "path": "hour3Label" },
    "hour3Temp": { "type": "binding", "path": "hour3Temp" },
    "hour4Label": { "type": "binding", "path": "hour4Label" },
    "hour4Temp": { "type": "binding", "path": "hour4Temp" },
    "hour5Label": { "type": "binding", "path": "hour5Label" },
    "hour5Temp": { "type": "binding", "path": "hour5Temp" },
    "day0Label": { "type": "binding", "path": "day0Label" },
    "day0High": { "type": "binding", "path": "day0High" },
    "day0Low": { "type": "binding", "path": "day0Low" },
    "day1Label": { "type": "binding", "path": "day1Label" },
    "day1High": { "type": "binding", "path": "day1High" },
    "day1Low": { "type": "binding", "path": "day1Low" },
    "day2Label": { "type": "binding", "path": "day2Label" },
    "day2High": { "type": "binding", "path": "day2High" },
    "day2Low": { "type": "binding", "path": "day2Low" },
    "day3Label": { "type": "binding", "path": "day3Label" },
    "day3High": { "type": "binding", "path": "day3High" },
    "day3Low": { "type": "binding", "path": "day3Low" },
    "day4Label": { "type": "binding", "path": "day4Label" },
    "day4High": { "type": "binding", "path": "day4High" },
    "day4Low": { "type": "binding", "path": "day4Low" }
  },
  "root": {
    "actions": {
      "onAppear": "fetchWeather"
    },
    "children": [{
      "type": "zstack",
      "children": [
        {
          "type": "gradient",
          "gradientColors": [
            { "color": "#1E3A5F", "location": 0.0 },
            { "color": "#2E5077", "location": 0.5 },
            { "color": "#4A7C9B", "location": 1.0 }
          ],
          "gradientStart": "top", "gradientEnd": "bottom",
          "ignoresSafeArea": true
        },
        {
          "type": "sectionLayout",
          "sectionSpacing": 24,
          "sections": [
            {
              "id": "header",
              "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20, "top": 20 } },
              "children": [
                {
                  "type": "hstack",
                  "children": [
                    {
                      "type": "vstack", "spacing": 4, "alignment": "leading",
                      "children": [
                        { "type": "label", "dataSourceId": "locationDisplay", "styleId": "locationText" },
                        { "type": "label", "dataSourceId": "dateDisplay", "styleId": "dateText" }
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
              "id": "current",
              "layout": { "type": "list", "showsDividers": false, "contentInsets": { "horizontal": 20 } },
              "children": [
                {
                  "type": "hstack",
                  "children": [
                    {
                      "type": "vstack", "alignment": "leading",
                      "children": [
                        {
                          "type": "hstack", "alignment": "top",
                          "children": [
                            { "type": "label", "dataSourceId": "tempDisplay", "styleId": "tempLarge" },
                            { "type": "label", "text": "°", "styleId": "tempUnit" }
                          ]
                        },
                        { "type": "label", "dataSourceId": "conditionDisplay", "styleId": "conditionText" },
                        { "type": "label", "dataSourceId": "feelsLikeDisplay", "styleId": "feelsLikeText" }
                      ]
                    },
                    { "type": "spacer" },
                    { "type": "image", "image": { "sfsymbol": "sun.max.fill" }, "styleId": "weatherIcon" }
                  ]
                }
              ]
            },
            {
              "id": "stats",
              "layout": { "type": "grid", "columns": 2, "itemSpacing": 12, "lineSpacing": 12, "contentInsets": { "horizontal": 20 } },
              "children": [
                {
                  "type": "hstack", "spacing": 12, "styleId": "statCard",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "humidity.fill" }, "styleId": "statIcon" },
                    {
                      "type": "vstack", "spacing": 2, "alignment": "leading",
                      "children": [
                        { "type": "label", "dataSourceId": "humidityDisplay", "styleId": "statValue" },
                        { "type": "label", "text": "Humidity", "styleId": "statLabel" }
                      ]
                    }
                  ]
                },
                {
                  "type": "hstack", "spacing": 12, "styleId": "statCard",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "wind" }, "styleId": "statIcon" },
                    {
                      "type": "vstack", "spacing": 2, "alignment": "leading",
                      "children": [
                        { "type": "label", "dataSourceId": "windDisplay", "styleId": "statValue" },
                        { "type": "label", "text": "Wind", "styleId": "statLabel" }
                      ]
                    }
                  ]
                },
                {
                  "type": "hstack", "spacing": 12, "styleId": "statCard",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "sun.max.fill" }, "styleId": "statIcon" },
                    {
                      "type": "vstack", "spacing": 2, "alignment": "leading",
                      "children": [
                        { "type": "label", "dataSourceId": "uvDisplay", "styleId": "statValue" },
                        { "type": "label", "text": "UV Index", "styleId": "statLabel" }
                      ]
                    }
                  ]
                },
                {
                  "type": "hstack", "spacing": 12, "styleId": "statCard",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "eye.fill" }, "styleId": "statIcon" },
                    {
                      "type": "vstack", "spacing": 2, "alignment": "leading",
                      "children": [
                        { "type": "label", "dataSourceId": "visibilityDisplay", "styleId": "statValue" },
                        { "type": "label", "text": "Visibility", "styleId": "statLabel" }
                      ]
                    }
                  ]
                }
              ]
            },
            {
              "id": "hourly",
              "layout": { "type": "horizontal", "itemSpacing": 12, "contentInsets": { "horizontal": 20 } },
              "header": { "type": "label", "text": "HOURLY FORECAST", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
              "children": [
                {
                  "type": "vstack", "spacing": 8, "alignment": "center", "styleId": "hourCardSelected",
                  "children": [
                    { "type": "label", "dataSourceId": "hour0Label", "styleId": "hourText" },
                    { "type": "image", "image": { "sfsymbol": "sun.max.fill" }, "styleId": "hourIcon" },
                    { "type": "label", "dataSourceId": "hour0Temp", "styleId": "hourTemp" }
                  ]
                },
                {
                  "type": "vstack", "spacing": 8, "alignment": "center", "styleId": "hourCard",
                  "children": [
                    { "type": "label", "dataSourceId": "hour1Label", "styleId": "hourText" },
                    { "type": "image", "image": { "sfsymbol": "cloud.sun.fill" }, "styleId": "hourIcon" },
                    { "type": "label", "dataSourceId": "hour1Temp", "styleId": "hourTemp" }
                  ]
                },
                {
                  "type": "vstack", "spacing": 8, "alignment": "center", "styleId": "hourCard",
                  "children": [
                    { "type": "label", "dataSourceId": "hour2Label", "styleId": "hourText" },
                    { "type": "image", "image": { "sfsymbol": "cloud.fill" }, "styleId": "hourIcon" },
                    { "type": "label", "dataSourceId": "hour2Temp", "styleId": "hourTemp" }
                  ]
                },
                {
                  "type": "vstack", "spacing": 8, "alignment": "center", "styleId": "hourCard",
                  "children": [
                    { "type": "label", "dataSourceId": "hour3Label", "styleId": "hourText" },
                    { "type": "image", "image": { "sfsymbol": "cloud.fill" }, "styleId": "hourIcon" },
                    { "type": "label", "dataSourceId": "hour3Temp", "styleId": "hourTemp" }
                  ]
                },
                {
                  "type": "vstack", "spacing": 8, "alignment": "center", "styleId": "hourCard",
                  "children": [
                    { "type": "label", "dataSourceId": "hour4Label", "styleId": "hourText" },
                    { "type": "image", "image": { "sfsymbol": "cloud.sun.fill" }, "styleId": "hourIcon" },
                    { "type": "label", "dataSourceId": "hour4Temp", "styleId": "hourTemp" }
                  ]
                },
                {
                  "type": "vstack", "spacing": 8, "alignment": "center", "styleId": "hourCard",
                  "children": [
                    { "type": "label", "dataSourceId": "hour5Label", "styleId": "hourText" },
                    { "type": "image", "image": { "sfsymbol": "sun.max.fill" }, "styleId": "hourIcon" },
                    { "type": "label", "dataSourceId": "hour5Temp", "styleId": "hourTemp" }
                  ]
                }
              ]
            },
            {
              "id": "sunrise-sunset",
              "layout": { "type": "horizontal", "itemSpacing": 12, "contentInsets": { "horizontal": 20 } },
              "children": [
                {
                  "type": "vstack", "spacing": 8, "alignment": "center", "styleId": "sunTimeCard",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "sunrise.fill" }, "styleId": "sunIcon" },
                    { "type": "label", "text": "6:52 AM", "styleId": "sunTime" },
                    { "type": "label", "text": "Sunrise", "styleId": "sunLabel" }
                  ]
                },
                {
                  "type": "vstack", "spacing": 8, "alignment": "center", "styleId": "sunTimeCard",
                  "children": [
                    { "type": "image", "image": { "sfsymbol": "sunset.fill" }, "styleId": "sunIcon" },
                    { "type": "label", "text": "5:18 PM", "styleId": "sunTime" },
                    { "type": "label", "text": "Sunset", "styleId": "sunLabel" }
                  ]
                }
              ]
            },
            {
              "id": "weekly",
              "layout": { "type": "list", "showsDividers": false, "itemSpacing": 0, "contentInsets": { "horizontal": 20, "bottom": 40 } },
              "header": { "type": "label", "text": "5-DAY FORECAST", "styleId": "sectionTitle", "padding": { "bottom": 12 } },
              "children": [
                {
                  "type": "hstack", "styleId": "dayRow",
                  "children": [
                    { "type": "label", "dataSourceId": "day0Label", "styleId": "dayName" },
                    { "type": "image", "image": { "sfsymbol": "sun.max.fill" }, "styleId": "dayIcon" },
                    { "type": "spacer" },
                    { "type": "label", "dataSourceId": "day0High", "styleId": "dayTempHigh" },
                    { "type": "label", "dataSourceId": "day0Low", "styleId": "dayTempLow" }
                  ]
                },
                {
                  "type": "hstack", "styleId": "dayRow",
                  "children": [
                    { "type": "label", "dataSourceId": "day1Label", "styleId": "dayName" },
                    { "type": "image", "image": { "sfsymbol": "cloud.sun.fill" }, "styleId": "dayIcon" },
                    { "type": "spacer" },
                    { "type": "label", "dataSourceId": "day1High", "styleId": "dayTempHigh" },
                    { "type": "label", "dataSourceId": "day1Low", "styleId": "dayTempLow" }
                  ]
                },
                {
                  "type": "hstack", "styleId": "dayRow",
                  "children": [
                    { "type": "label", "dataSourceId": "day2Label", "styleId": "dayName" },
                    { "type": "image", "image": { "sfsymbol": "cloud.rain.fill" }, "styleId": "dayIcon" },
                    { "type": "spacer" },
                    { "type": "label", "dataSourceId": "day2High", "styleId": "dayTempHigh" },
                    { "type": "label", "dataSourceId": "day2Low", "styleId": "dayTempLow" }
                  ]
                },
                {
                  "type": "hstack", "styleId": "dayRow",
                  "children": [
                    { "type": "label", "dataSourceId": "day3Label", "styleId": "dayName" },
                    { "type": "image", "image": { "sfsymbol": "cloud.fill" }, "styleId": "dayIcon" },
                    { "type": "spacer" },
                    { "type": "label", "dataSourceId": "day3High", "styleId": "dayTempHigh" },
                    { "type": "label", "dataSourceId": "day3Low", "styleId": "dayTempLow" }
                  ]
                },
                {
                  "type": "hstack", "styleId": "dayRow",
                  "children": [
                    { "type": "label", "dataSourceId": "day4Label", "styleId": "dayName" },
                    { "type": "image", "image": { "sfsymbol": "sun.max.fill" }, "styleId": "dayIcon" },
                    { "type": "spacer" },
                    { "type": "label", "dataSourceId": "day4High", "styleId": "dayTempHigh" },
                    { "type": "label", "dataSourceId": "day4Low", "styleId": "dayTempLow" }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }]
  }
}
"""
