//
//  CreateLobbyView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 19/07/23.
//


import SwiftUI

struct CreateLobbyView: View {
    @State private var input1: String = ""
    @State private var input2: String = ""
    @State private var input3: Int = 0
    @State private var showingResultView = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter input 1", text: $input1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Enter input 2", text: $input2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Enter input 3", value: $input3, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()

                Button(action: {
                    showingResultView = true
                }) {
                    Text("Go to Result")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showingResultView) {
                    ResultView2(input1: input1, input2: input2, input3: input3)
                }
            }
            .navigationTitle("Input View")
        }
    }
}

struct ResultView2: View {
    var input1: String
    var input2: String
    var input3: Int

    var body: some View {
        VStack {
            Text("Input 1: \(input1)")
                .font(.title)
                .padding()

            Text("Input 2: \(input2)")
                .font(.title)
                .padding()

            Text("Input 3: \(input3)")
                .font(.title)
                .padding()
        }
        .navigationTitle("Result View")
    }
}

struct CreateLobbyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateLobbyView()
    }
}
