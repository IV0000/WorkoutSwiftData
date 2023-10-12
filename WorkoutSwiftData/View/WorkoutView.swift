//
//  WorkoutView.swift
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

    @State var workoutName: String = ""
    @State var workoutDescription: String = ""
    var body: some View {
        VStack {
            List {
                if allWorkouts.isEmpty {
                    ContentUnavailableView("You don't have workouts yet", systemImage: "dumbbell.fill")
                        .foregroundStyle(Color.accentColor)
                } else {
                    ForEach(allWorkouts) { workout in
                        NavigationLink(value: workout) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(workout.selectedDay.rawValue.prefix(3))
                                        .font(.system(size: 20, weight: .semibold))

                                        .frame(width: 50, height: 50)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(Color.accentColor)
                                        }
                                    VStack(alignment: .leading) {
                                        Text(workout.name)
                                            .font(.title3)
                                        Text(workout.information)
                                            .font(.body)
                                    }
                                }

                                if let exercises = workout.exercises,!exercises.isEmpty {
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
                    .listRowBackground(Color.darkGrey)
                }
                Section("New workout") {
                    TextField("Workout name", text: $workoutName)
                    TextField("Workout description", text: $workoutDescription)
                        .lineLimit(1 ... 3)
                    Button("Create") {
                        createWorkout()
                    }
                    .disabled(workoutName.isEmpty || workoutDescription.isEmpty)
                }
                .listRowBackground(Color.darkGrey)
            }
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
        .modelContainer(for: Workout.self, inMemory: false)
}
