//
//  WorkoutSwiftDataApp.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 08/06/23.
//

import SwiftData
import SwiftUI

@main
struct WorkoutSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                workoutView
                exerciseView
            }
            .modelContainer(for: [Workout.self, Exercise.self])
        }
    }

    var workoutView: some View {
        NavigationStack {
            WorkoutView()
                .navigationTitle("Workouts")
        }
        .tabItem { Label("Workouts", systemImage: "figure.run.circle.fill") }
    }

    var exerciseView: some View {
        NavigationStack {
            ExerciseView()
                .navigationTitle("Exercises")
        }
        .tabItem { Label("Exercises", systemImage: "pencil.circle.fill") }
    }
}
