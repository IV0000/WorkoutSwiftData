//
//  ContentView.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 08/06/23.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \.createdAt,order: .reverse) var allWorkouts: [Workout]
    @State var workoutName: String = ""
    @State var workoutDescription: String = ""
    var body: some View {
        VStack {
            List {
                Section("New workout"){
                    TextField("Workout name",text: $workoutName)
                    TextField("Workout description",text: $workoutDescription)
                        .lineLimit(1...3)
                    Button("Save") {
                        createWorkout()
                    }
                }
                if allWorkouts.isEmpty {
                    ContentUnavailableView("You don't have workouts yet",systemImage: "dumbbell.fill")
                } else {
                    ForEach(allWorkouts) { workout in
                        VStack(alignment: .leading){
                            Text(workout.name)
                            Text(workout.information)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        indexSet.forEach {
                            context.delete(allWorkouts[$0])
                        }
                        try? context.save()
                    })
               
                }
            }
        }
    }
    func createWorkout() {
        let workout = Workout(id: UUID().uuidString,
                              name: workoutName,
                              createdAt: Date(),
                              information: workoutDescription,
                              exerciseList: [])
        context.insert(workout)
        try? context.save()
    }
}

#Preview {
    WorkoutView()
}
