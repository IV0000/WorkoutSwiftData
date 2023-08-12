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
    @Query(sort: [SortDescriptor(\Exercise.name, order: .forward)]) var allExercises: [Exercise]
    @State var showDetail: Bool = false
    @State var selectedExercise: Exercise?
    var body: some View {
        VStack {
            List {
                if allExercises.isEmpty {
                    ContentUnavailableView("You don't have exercises yet", systemImage: "figure.strengthtraining.traditional")
                } else {
                    ForEach(allExercises) { exercise in
                        VStack(alignment: .leading) {
                            Text(exercise.name)
                            Text(exercise.information)
                            Text(exercise.category)
                        }
                        .onTapGesture {
                            showDetail.toggle()
                            selectedExercise = exercise
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
        .toolbar {
            Button("Add new") {
                showDetail.toggle()
            }
        }
        .sheet(isPresented: $showDetail, content: {
            ExerciseDetailView(selectedExercise: (selectedExercise ?? Exercise.mock().first)!)

        })
    }
}

struct ExerciseDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Bindable var selectedExercise: Exercise
    @State var exerciseName: String = ""
    @State var exerciseDescription: String = ""
    @State var exerciseCategory: ExerciseCategory = .upperbody
    var body: some View {
        VStack {
            List {
                // Add check of not empty
                Section("New exercise") {
                    // Handle binding optional

                    TextField("Exercise name", text: $selectedExercise.name)

//                    TextField("Exercise description", text: Binding(selectedExercise?.information ?? ""))
//                        .lineLimit(1 ... 3)
//                    Picker("Exercise type", selection: Binding( selectedExercise?.categoryType ?? ExerciseCategory.upperbody)) {
//                        ForEach(ExerciseCategory.allCases, id: \.self) { category in
//                            Text(category.rawValue.capitalized)
//                        }
//                    }
                    Button("Save") {
                        createExercise()
                        dismiss()
                    }
                }
            }
            .listStyle(.plain)
        }
    }

    func createExercise() {
//       if let exercise = selectedExercise {
        context.insert(Exercise(name: selectedExercise.name,
                                information: selectedExercise.information,
                                category: selectedExercise.category))
        try? context.save()
        resetFields()
//       }
    }

    func resetFields() {
        exerciseName = ""
        exerciseDescription = ""
        exerciseCategory = .upperbody
    }
}

#Preview {
    ExerciseView()
}

func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
