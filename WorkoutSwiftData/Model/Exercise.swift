//
//  Exercise.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 08/06/23.
//

import Foundation
import SwiftData

@Model
final class Exercise {
    @Attribute(.unique) var name: String
    var information: String
    var _category: ExerciseCategory.RawValue
    @Relationship(inverse: \Workout.exercises)
    var workout: Workout?

    init(name: String, information: String, category: ExerciseCategory.RawValue) {
        self.name = name
        self.information = information
        _category = category
    }
}

// We use this to handle the enum case
extension Exercise {
    /* Workaround to store enums */
    @Transient
    var category: ExerciseCategory {
        get { ExerciseCategory(rawValue: _category)! }
        set { _category = newValue.rawValue }
    }

    static func mock() -> [Exercise] {
        [Exercise(name: "Push-ups", information: "Perform push-ups to strengthen your upper body muscles", category: ExerciseCategory.upperbody.rawValue),
         Exercise(name: "Squats", information: "Perform squats to target your lower body muscles", category: ExerciseCategory.lowerbody.rawValue),
         Exercise(name: "Bicep Curls", information: "Do bicep curls to work on your arm muscles", category: ExerciseCategory.upperbody.rawValue),
         Exercise(name: "Lunges", information: "Perform lunges to engage your leg muscles", category: ExerciseCategory.lowerbody.rawValue)]
    }
}

enum ExerciseCategory: String, CaseIterable {
    case upperbody = "Upperbody"
    case lowerbody = "Lowerbody"
}
