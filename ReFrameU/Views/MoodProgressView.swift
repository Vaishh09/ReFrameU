//
//  MoodProgressView.swift
//  ReFrameU
//
//  Created by Vaishnavi Mahajan on 4/3/25.
//


import SwiftUI

struct MoodProgressView: View {
    @State private var moodLog: [(String, Int)] = []
    @State private var selectedMood = 3
    @State private var level = 1

    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        VStack(spacing: 20) {
            Text("🌿 Mood Tracker")
                .font(.title2)
                .fontWeight(.semibold)

            Picker("Today’s Mood", selection: $selectedMood) {
                ForEach(1...5, id: \.self) { mood in
                    Text("Mood \(mood)").tag(mood)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            Button("Log Today’s Mood") {
                logMood()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)

            Text("🌸 Garden Level: \(level)")
                .font(.headline)

            HStack(spacing: 12) {
                ForEach(moodLog.indices, id: \.self) { i in
                    VStack {
                        Text("\(moodLog[i].1)")
                            .font(.caption)
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.green)
                            .frame(width: 20, height: CGFloat(moodLog[i].1) * 15)
                        Text(moodLog[i].0)
                            .font(.caption2)
                    }
                }
            }

            Spacer()
        }
        .padding()
    }

    func logMood() {
        let weekday = days[moodLog.count % 7]
        moodLog.append((weekday, selectedMood))

        if moodLog.count % 3 == 0 {
            level += 1
        }
    }
}
