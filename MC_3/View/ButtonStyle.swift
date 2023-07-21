//
//  ButtonStyle.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 19/07/23.
//

import SwiftUI

struct MultipeerButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding()
      .font(.headline)
      .background(configuration.isPressed ? Color.black : Color.accentColor)
      .cornerRadius(9.0)
      .foregroundColor(.white)
  }
}

struct ChatMessageButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Spacer()
      configuration.label
      Spacer()
    }
    .padding(8)
    .background(configuration.isPressed ? Color.black : Color.green)
    .cornerRadius(9.0)
    .foregroundColor(.white)
  }
}

struct FooterButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
          .foregroundColor(configuration.isPressed ? Color.black : .accentColor)
      .font(.headline)
      .padding(8)
  }
}
struct BackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
            .ignoresSafeArea()
    }
}

extension View {
    func backgroundStyle() -> some View {
        self.modifier(BackgroundStyle())
    }
}
