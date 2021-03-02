//
//  RoundedButton.swift
//  Cardsneak (iOS)
//
//  Created by Cameron Grigoriadis on 2/27/21.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        RoundedButtonStyleView(configuration: configuration)
    }
}

private extension RoundedButtonStyle {
    
    struct RoundedButtonStyleView: View {
      // tracks if the button is enabled or not
      @Environment(\.isEnabled) var isEnabled
      // tracks the pressed state
      let configuration: RoundedButtonStyle.Configuration

      var body: some View {
        configuration.label
            .font(Font.system(.title3).weight(.bold))
            .foregroundColor(.white)
                .padding(.horizontal, 15)
            .padding()
            .background(isEnabled ? Color.blue.cornerRadius(20) : Color.secondary.cornerRadius(20))
            .opacity(isEnabled ? 1 : 0.9)
            .blur(radius: configuration.isPressed ? 0 : 0.5)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
      }
    }
}

struct RoundedButton: View {
    
    let title: String
    
    let action: () -> Void
    
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(RoundedButtonStyle())
    }
    
}
