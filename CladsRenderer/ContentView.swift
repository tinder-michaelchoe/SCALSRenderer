//
//  ContentView.swift
//  CladsRenderer
//
//  Main app view with tabs for Examples and JSON Playground.
//

import CladsExamples
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            CladsExamplesView()
                .tabItem {
                    Label("Examples", systemImage: "list.bullet.rectangle")
                }
                .tag(0)

            JSONPlaygroundView()
                .tabItem {
                    Label("Playground", systemImage: "curlybraces")
                }
                .tag(1)
        }
    }
}
