//
//  ContentView.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 08/06/23.
//

import SwiftData
import SwiftUI

struct WorkoutView: View {
    @Environment(\.modelContext) private var context

    @Query(filter: #Predicate<Workout> { !$0.name.contains("test") },
           sort: [SortDescriptor(\Workout.createdAt, order: .reverse)],
           animation: .bouncy)
    var allWorkouts: [Workout]

    @Query(sort: [SortDescriptor(\Exercise.name, order: .forward)],
           animation: .bouncy)
    var allExercises: [Exercise]

    @State var workoutName: String = ""
    @State var workoutDescription: String = ""
    var exercises: [Exercise] = []
    var body: some View {
        VStack {
            List {
                Section("New workout") {
                    TextField("Workout name", text: $workoutName)
                    TextField("Workout description", text: $workoutDescription)
                        .lineLimit(1 ... 3)
                    Button("Save") {
                        createWorkout()
                    }
                }
                if allWorkouts.isEmpty {
                    ContentUnavailableView("You don't have workouts yet", systemImage: "dumbbell.fill")
                } else {
                    Section("Workouts") {
                        ForEach(allWorkouts) { workout in
                            VStack(alignment: .leading) {
                                NavigationLink(value: workout) {
                                    Text(workout.name)
                                    Text(workout.information)

                                    if exercises.isEmpty {
                                        Text("Exercises: " + exercises.map { $0.name }.joined(separator: ", "))
                                    }
                                }
                            }
                            .navigationDestination(for: Workout.self) { workout in
                                WorkoutDetailView(workout: workout)
                            }
                        }

                        .onDelete(perform: { indexSet in
                            indexSet.forEach {
                                context.delete(allWorkouts[$0])
                            }
                            /* After deleting an item, SwiftUI might attempt to reference the deleted content during the animation causing a crash.
                             Workaround: Explicitly save after a delete.
                             */
                            try? context.save()
                        })
                    }
                }
            }
            .listStyle(.plain)
        }
    }

    func createWorkout() {
        let workout = Workout(id: UUID().uuidString,
                              name: workoutName,
                              createdAt: Date(),
                              information: workoutDescription)
        context.insert(workout)
    }
}

#Preview {
    WorkoutView()
        .modelContainer(for: Workout.self, inMemory: true)
}
