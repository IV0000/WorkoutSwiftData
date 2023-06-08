//
//  WorkoutSwiftDataApp.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 08/06/23.
//

import SwiftUI
import SwiftData

@main
struct WorkoutSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Workout.self,Exercise.self])
        }
    }
}
