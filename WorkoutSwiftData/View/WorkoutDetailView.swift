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
    @Bindable var workout: Workout
    @State private var selectedExercises: Set<Exercise> = []
    @State private var selectedDay: Day = .Monday
    var body: some View {
        VStack {
            // TODO: Implement selection
            /* Selection aint working atm on beta iOS 17*/
            List(exercises, selection: $selectedExercises) { exercise in
                Text(exercise.name)
            }
            .toolbar {
                EditButton()
            }

            List {
                Section("Workout day") {
                    Picker("Day", selection: $selectedDay) {
                        ForEach(Day.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                }
            }

            Button("Confirm") {
//                    workout.exercises = Array(selectedExercises)
                // NOT WORKING ATM
                workout.exercises?.append(exercises.first ?? Exercise.mock().first!)
                workout.selectedDay = selectedDay
            }
            .buttonStyle(PrimaryButton())
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .onAppear { selectedDay = workout.selectedDay }
    }
}

#Preview {
    /*
     https://www.hackingwithswift.com/quick-start/swiftdata/how-to-use-swiftdata-in-swiftui-previews
     */

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, configurations: config)
    return WorkoutDetailView(workout: Workout.mock().first!)
        .modelContainer(container)
}
