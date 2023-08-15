//
//  WorkoutDetailView.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 14/08/23.
//

import SwiftData
import SwiftUI

struct WorkoutDetailView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor(\Exercise.name, order: .forward)],
           animation: .bouncy)
    var exercises: [Exercise]
    var workout: Workout
    @State private var selectedExercises: Set<Exercise> = []
    var body: some View {
        VStack {
            /* Selection aint working atm on beta iOS 17*/
            List(exercises, selection: $selectedExercises) { exercise in
                Text(exercise.name)
            }
            .toolbar {
                EditButton()
            }

            Button("Add selected") {
//                    workout.exercises = Array(selectedExercises)
                workout.exercises?.append(exercises.first ?? Exercise.mock().first!)
            }
        }
    }
}

#Preview {
    WorkoutDetailView(workout: Workout.mock().first!)
        .modelContainer(for: Workout.self, inMemory: true)
}
