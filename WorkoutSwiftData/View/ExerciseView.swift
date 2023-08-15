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
    @Query var allExercises: [Exercise]
    @State var showDetail: Bool = false
    @State var selectedExercise: Exercise?
    @State var searchName: String = ""
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
                                showDetail.toggle()
                                selectedExercise = exercise
                            }
                            .listRowBackground(Color.darkGrey)
                            .listSectionSeparatorTint(Color.red)
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
        .searchable(text: $searchName, prompt: "Search an exercise..")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    showDetail.toggle()
                }, label: {
                    Text("+ New exercise")
                        .padding(6)
                        .foregroundStyle(.accent)
                })
            })
        }
        .sheet(isPresented: $showDetail, content: {
            ExerciseDetailView(selectedExercise: (selectedExercise ?? Exercise.mock().first)!)

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

#Preview {
    NavigationStack {
        ExerciseView()
            .modelContainer(for: Exercise.self, inMemory: false)
    }
}

func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
