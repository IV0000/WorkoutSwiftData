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
    @State var searchName: String = ""
    var body: some View {
        VStack {
            List {
                if allExercises.isEmpty {
                    ContentUnavailableView("You don't have exercises yet", systemImage: "figure.strengthtraining.traditional")
                } else {
                    ForEach(filteredExercises) { exercise in
                        VStack(alignment: .leading) {
                            Text(exercise.name)
                                .font(.title)
                            Text(exercise.category.rawValue)
                                .font(.callout)
                            Divider()
                            Text(exercise.information)
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
            .listStyle(.plain)
        }
        .searchable(text: $searchName, prompt: "Search an exercise name")
        .toolbar {
            ToolbarItem(placement: .bottomBar, content: {
                Button(action: {
                    showDetail.toggle()
                }, label: {
                    Text("Add new exercise")
                        .padding(10)
                        .font(.title2)
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                        }

                })
            })
        }
        .sheet(isPresented: $showDetail, content: {
            ExerciseDetailView(selectedExercise: (selectedExercise ?? Exercise.mock().first)!)

        })
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
            .modelContainer(for: Exercise.self, inMemory: true)
    }
}

func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
