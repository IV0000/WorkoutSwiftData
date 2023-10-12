//
//  ExerciseView.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 09/06/23.
//

import SwiftData
import SwiftUI

struct ExerciseView: View {
    @Environment(\.modelContext) private var context
//    @Query(sort: [SortDescriptor<Workout>(\Workout.exercises.name, order: .forward)]) var allExercises: [Exercise]
    @Query private var allExercises: [Exercise]
    @State private var showDetail: Bool = false
    @State private var selectedExercise: Exercise?
    @State private var searchName: String = ""
    @State private var isUpdate: Bool = false
    var body: some View {
        VStack {
            List {
                if allExercises.isEmpty {
                    ContentUnavailableView("No exercises", systemImage: "figure.strengthtraining.traditional")
                        .foregroundStyle(Color.accentColor)
                } else {
                    ForEach(filteredExercises) { exercise in
                        exerciseRow(exercise: exercise)
                            .onTapGesture {
                                isUpdate = true
                                selectedExercise = exercise
                                showDetail.toggle()
                            }
                            .listRowBackground(Color.darkGrey)
                    }
                    .onDelete(perform: { indexSet in
                        indexSet.forEach {
                            context.delete(allExercises[$0])
                        }
                        try? context.save()
                    })
                }
            }
            Button("+ New exercise", action: {
                isUpdate = false
                showDetail.toggle()
            })
            .buttonStyle(PrimaryButton())
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .searchable(text: $searchName, prompt: "Search an exercise..")
        .sheet(isPresented: $showDetail, content: {
            ExerciseDetailView(selectedExercise: (selectedExercise ?? Exercise.mock().first)!,
                               isUpdate: isUpdate)
        })
    }

    @ViewBuilder
    func exerciseRow(exercise: Exercise) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(exercise.name)
                .font(.title)
            Text(exercise.category.rawValue)
                .font(.caption)
                .foregroundStyle(Color.white)
                .padding(5)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(exercise.category == .upperbody ? Color.blue.opacity(0.7) : Color.red.opacity(0.7))
                }
            Text(exercise.information)
        }
    }

    /* Filtering for search */
    var filteredExercises: [Exercise] {
        if searchName.isEmpty {
            return allExercises
        }

        var descriptor = FetchDescriptor<Exercise>()
        descriptor.predicate = #Predicate { exercise in
            exercise.name.localizedStandardContains(searchName)
        }
        let filteredList = try? context.fetch(descriptor)
        return filteredList ?? []
    }
}

#Preview {
    NavigationStack {
        ExerciseView()
            .modelContainer(for: Exercise.self, inMemory: false)
    }
}
