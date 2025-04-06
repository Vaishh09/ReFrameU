//
//  ReFrameUApp.swift
//  ReFrameU
//
//  Created by Vaishnavi Mahajan on 4/3/25.
//

// ReFrameUApp.swift

import SwiftUI
import FirebaseCore

@main
struct ReFrameUApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
