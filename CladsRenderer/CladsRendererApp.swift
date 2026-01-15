//
//  CladsRendererApp.swift
//  CladsRenderer
//
//  Created by mexicanpizza on 12/25/25.
//

import SwiftUI
import UIKit

@main
struct CladsRendererApp: App {
    
    init() {
        // Print all available fonts to find correct PostScript names
        printAvailableFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    /// Debug helper: prints all available font names
    /// Look for "Merriweather" in the output to find the correct PostScript names
    private func printAvailableFonts() {
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📝 AVAILABLE FONTS (searching for Merriweather):")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        
        var foundMerriweather = false
        for family in UIFont.familyNames.sorted() {
            let fontNames = UIFont.fontNames(forFamilyName: family)
            
            // Check if any font in this family contains "merri"
            if family.lowercased().contains("merri") || 
               fontNames.contains(where: { $0.lowercased().contains("merri") }) {
                foundMerriweather = true
                print("Family: \(family)")
                for name in fontNames {
                    print("  → PostScript name: \(name)")
                }
            }
        }
        
        if !foundMerriweather {
            print("⚠️ No Merriweather fonts found!")
            print("   Make sure fonts are:")
            print("   1. Added to 'Copy Bundle Resources' build phase")
            print("   2. Listed in Info.plist under 'Fonts provided by application'")
        }
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
}
