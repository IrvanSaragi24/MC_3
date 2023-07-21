//
//  TrainVoiceView.swift
//  MC_3
//
//  Created by Irvan P. Saragi on 16/07/23.
//

import SwiftUI

struct TrainVoiceView: View {

    let minValue: Double = 0.0
    let maxValue: Double = 10.0
    let step: Double = 0.1 // Set the step size for the picker
    @State private var selectedValue: Double = 0.0
    
    var body: some View {
        VStack {
            Text("Select a Double Value:")
                .font(.headline)
                .padding()
            
            Picker("Double Value", selection: $selectedValue) {
                ForEach(0..<10) { index in
                    let doubleValue = Double(index) / 2.0 // Adjust the range or step as needed
                    Text(String(format: "%.1f", doubleValue))
                }
            }
            .pickerStyle(WheelPickerStyle()) // Use WheelPickerStyle for a spinning wheel picker
            
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
