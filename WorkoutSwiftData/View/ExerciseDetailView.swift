//
//  ExerciseDetailView.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 15/08/23.
//

import SwiftData
import SwiftUI

struct ExerciseDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Bindable var selectedExercise: Exercise

    @State private var name: String = ""
    @State private var information: String = ""
    @State private var category: ExerciseCategory = .upperbody

    let isUpdate: Bool

    private var fieldsEmpty: Bool {
        name.isEmpty || information.isEmpty
    }

    var body: some View {
        VStack {
            List {
                Section(isUpdate ? "Exercise" : "New exercise") {
                    TextField("Exercise name", text: $name)
                    TextField("Exercise description", text: $information)
                    Picker("Select category", selection: $category) {
                        ForEach(ExerciseCategory.allCases, id: \.self) { option in
                            Text(String(describing: option))
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .listStyle(.plain)
            Spacer()
            Button(isUpdate ? "Update" : "Create") {
                if isUpdate {
                    updateExerise()
                } else {
                    createExercise()
                }
                dismiss()
            }
            .disabled(fieldsEmpty)
            .buttonStyle(PrimaryButton())
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .onAppear(perform: {
            if isUpdate {
                name = selectedExercise.name
                information = selectedExercise.information
                category = selectedExercise.category
            }
        })
    }

    private func createExercise() {
        context.insert(Exercise(name: name,
                                information: information,
                                category: category.rawValue))
    }

    private func updateExerise() {
        selectedExercise.name = name
        selectedExercise.information = information
        selectedExercise.category = category
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)
    return ExerciseDetailView(selectedExercise: Exercise.mock().first!, isUpdate: true)
        .modelContainer(container)
}
