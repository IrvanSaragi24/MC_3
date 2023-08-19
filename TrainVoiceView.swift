//
//  TrainVoiceView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 16/07/23.
//

import SwiftUI

struct TrainVoiceView: View {
    @State private var isPickerVisible = false
    @State private var selectedValue: Double = 0.0

    var body: some View {
        VStack {
            Button("Show Picker") {
                isPickerVisible = true
            }
            .padding()

            if isPickerVisible {
                Picker("Double Value", selection: $selectedValue) {
                    ForEach(0..<10) { index in
                        let doubleValue = Double(index) / 2.0 // Adjust the range or step as needed
                        Text(String(format: "%.1f", doubleValue))
                    }
                }
                .pickerStyle(WheelPickerStyle()) // Use WheelPickerStyle for a spinning wheel picker
                .transition(.slide) // Add a transition for smooth appearance

                Button("Done") {
                    isPickerVisible = false
                }
                .padding()
            }

            Text("Selected Value: \(selectedValue)")
                .padding()
        }
        .padding()
    }
}

struct TrainVoiceView_Previews: PreviewProvider {
    static var previews: some View {
        TrainVoiceView()
    }
}
