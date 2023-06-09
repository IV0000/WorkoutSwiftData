//
//  ExerciseView.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 09/06/23.
//

import SwiftUI
import SwiftData

struct ExerciseView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \.name,order: .forward) var allExercises: [Exercise]
    var body: some View {
        VStack{
            List{
                if allExercises.isEmpty {
                    ContentUnavailableView("You don't have workouts yet",systemImage: "dumbbell.fill")
                } else {
                    ForEach(allExercises) { exercise in
                        VStack(alignment: .leading){
                            Text(exercise.name)
                            Text(exercise.information)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        indexSet.forEach {
                            context.delete(allExercises[$0])
                        }
                        try? context.save()
                    })
               
                }
            }
        }
    }
}

#Preview {
    ExerciseView()
}
