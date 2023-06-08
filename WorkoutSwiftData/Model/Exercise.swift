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
    var description: String
    var category: ExerciseCategory.RawValue
    
    init(name: String, description: String, category: ExerciseCategory.RawValue) {
        self.name = name
        self.description = description
        self.category = category
    }
    
}

// We use this to handle the enum case 
extension Exercise {
    @Transient
    var categoryType: ExerciseCategory {
        ExerciseCategory(rawValue: self.category) ?? .upperbody
    }
    
    static func mock() -> [Exercise] {
        [ Exercise(name: "Push-ups", description: "Perform push-ups to strengthen your upper body muscles", category: ExerciseCategory.upperbody.rawValue),
          Exercise(name: "Squats", description: "Perform squats to target your lower body muscles", category: ExerciseCategory.lowerbody.rawValue),
          Exercise(name: "Bicep Curls", description: "Do bicep curls to work on your arm muscles", category: ExerciseCategory.upperbody.rawValue),
          Exercise(name: "Lunges", description: "Perform lunges to engage your leg muscles", category: ExerciseCategory.lowerbody.rawValue)
        ]
        
    }
}

enum ExerciseCategory: String,CaseIterable {
    case upperbody
    case lowerbody
}
