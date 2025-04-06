//
//  ToolboxView.swift
//  ReFrameU
//
//  Created by Vaishnavi Mahajan on 4/3/25.
//

import SwiftUI

struct ToolboxView: View {
    @AppStorage("savedReframes") private var savedReframes: String = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                Text("🌼 Your Saved Reframes")
                    .font(.title3)
                    .fontWeight(.bold)

                List {
                    ForEach(savedReframes.components(separatedBy: "|").filter { !$0.isEmpty }, id: \.self) { reframe in
                        Text("🌱 \(reframe)")
                            .padding(.vertical, 4)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .padding()
            .navigationTitle("Toolbox")
        }
    }
}
