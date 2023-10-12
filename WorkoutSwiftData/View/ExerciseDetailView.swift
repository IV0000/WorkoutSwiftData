//
//  ExerciseDetailView.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 15/08/23.
//

import SwiftUI

struct ExerciseDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Bindable var selectedExercise: Exercise
    var body: some View {
        VStack {
            List {
                // Add check of not empty
                Section("New exercise") {
                    TextField("Exercise name", text: $selectedExercise.name)
                    TextField("Exercise description", text: $selectedExercise.information)
                    Picker("Select category", selection: $selectedExercise.category) {
                        ForEach(ExerciseCategory.allCases, id: \.self) { option in
                            Text(String(describing: option))
                        }
                    }
                    .pickerStyle(.wheel)
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
                                category: selectedExercise._category))
        resetFields()
//       }
    }

    func resetFields() {
        selectedExercise.name = ""
        selectedExercise.information = ""
        selectedExercise.category = .upperbody
    }
}

/* Don't work idk why */
// #Preview {
//    ExerciseDetailView(selectedExercise:Exercise.mock().first!)
//        .modelContainer(for: Exercise.self, inMemory: true)
// }
