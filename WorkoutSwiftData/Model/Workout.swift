//
//  Workout.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 08/06/23.
//

import Foundation
import SwiftData

@Model
final class Workout {
    @Attribute(.unique) var id: String
    var name: String
    var description: String
    var exerciseList: [Exercise] = [] //Add @Relationship
    
    init(id: String, name: String, description: String, exerciseList: [Exercise]) {
        self.id = id
        self.name = name
        self.description = description
        self.exerciseList = exerciseList
    }
}

extension Workout {
    static func mock() -> [Workout] {
        [ Workout(id: "1", name: "Full Body Workout", description: "A comprehensive workout that targets all major muscle groups.", exerciseList: Exercise.mock()),
          Workout(id: "2", name: "Cardio Blast", description: "An intense cardio workout to improve cardiovascular endurance.", exerciseList: Exercise.mock() ),
          Workout(id: "3", name: "Leg Day", description: "Focuses on exercises for the lower body, including legs and glutes.", exerciseList: Exercise.mock() ),
          Workout(id: "4", name: "Upper Body Strength", description: "Strength training exercises for the upper body, including arms, chest, and back.",exerciseList: Exercise.mock())]
    }
}
