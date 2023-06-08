//
//  ContentView.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 08/06/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    var workouts: [Workout] = []
    var body: some View {
        VStack {
            List(workouts) { workout in
                Text(workout.name)
                Text(workout.description)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(workouts: [])
}
