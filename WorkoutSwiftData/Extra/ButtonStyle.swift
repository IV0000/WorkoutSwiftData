//
//  ButtonStyle.swift
//  WorkoutSwiftData
//
//  Created by Ivan Voloshchuk on 12/10/23.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                if !isEnabled {
                    Color.gray
                } else if configuration.isPressed {
                    Color.accentColor.opacity(0.5)
                } else {
                    Color.accentColor
                }
            }
            .foregroundStyle(configuration.isPressed ? .white.opacity(0.5) : .white)
            .cornerRadius(10)
    }
}

#Preview {
    Button("Action") {}
        .buttonStyle(PrimaryButton())
}
