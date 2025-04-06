//
//  ContentView.swift
//  ReFrameU
//
//  Created by Vaishnavi Mahajan on 4/3/25.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ThoughtInputView()
                .tabItem {
                    Label("Reframe", systemImage: "bubble.left.and.bubble.right")
                }

            ToolboxView()
                .tabItem {
                    Label("Toolbox", systemImage: "archivebox")
                }

            MoodProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
        .accentColor(Color("AccentColor"))
    }
}
