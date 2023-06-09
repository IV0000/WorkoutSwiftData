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
    var information: String // * read the note below *
    var createdAt: Date
    @Relationship var exerciseList: [Exercise]
    
    init(id: String, name: String, createdAt: Date, information: String, exerciseList: [Exercise]) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.information = information
        self.exerciseList = exerciseList
    }
}

extension Workout {
    static func mock() -> [Workout] {
        [ Workout(id: "1", name: "Full Body Workout", createdAt: Date.now, information: "A comprehensive workout that targets all major muscle groups.", exerciseList: Exercise.mock()),
          Workout(id: "2", name: "Cardio Blast", createdAt: Date.now+1, information: "An intense cardio workout to improve cardiovascular endurance.", exerciseList: Exercise.mock() ),
          Workout(id: "3", name: "Leg Day", createdAt: Date.now+2, information: "Focuses on exercises for the lower body, including legs and glutes.", exerciseList: Exercise.mock() ),
          Workout(id: "4", name: "Upper Body Strength", createdAt: Date.now+3, information: "Strength training exercises for the upper body, including arms, chest, and back.",exerciseList: Exercise.mock())]
    }
}

/*
 Originally the attribute was called "description" but it gave me a fatal error at runtime -> Unable to have an Attribute named description
 Apparently using system names such as "description" is not allowed.
 I'm not sure if it a bug of the beta, or it is written somewhere in documentation.
 */
