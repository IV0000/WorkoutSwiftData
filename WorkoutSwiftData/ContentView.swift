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
    @Query(sort: \.createdAt,order: .reverse) var allWorkouts: [Workout]
    @State var workoutName: String = ""
    @State var workoutDescription: String = ""
    var body: some View {
        VStack {
            List {
                if allWorkouts.isEmpty {
                    Section("New note"){
                        TextField("Note name",text: $workoutName)
                        TextField("Note description",text: $workoutDescription)
                            .lineLimit(1...3)
                        Button("Save") {
                            createWorkout()
                        }
                    }
                    ContentUnavailableView("You don't have workouts yet",systemImage: "gymdumbbell.fill")
                } else {
                    ForEach(allWorkouts) { workout in
                        Text(workout.name)
                        Text(workout.description)
                    }
                }
            }
        }
    }
    func createWorkout() {
        let workout = Workout(id: UUID().uuidString,
                              name: workoutName,
                              createdAt: Date(),
                              description: workoutDescription,
                              exerciseList: [])
        context.insert(workout)
        try? context.save()
    }
}

#Preview {
    ContentView()
}
