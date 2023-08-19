//
//  LobbyViewModel.swift
//  MC_3
//
//  Created by Hanifah BN on 25/07/23.
//

import Foundation

class LobbyViewModel: ObservableObject {
    @Published var lobby = Lobby(name: "Player")

    private var timer: Timer?
    private var startTime: Date?

    var formattedElapsedTime: String {
        let elapsedTime = lobby.elapsedTime
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func startTimer() {
        if !lobby.isTimerRunning {
            lobby.isTimerRunning = true
            startTime = Date()

            // Schedule a timer to update the elapsed time every 0.1 seconds
            // Underscore bisa diganti jadi timer kalo mau dipake.
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.updateElapsedTime()
            }
        }
    }

    func stopTimer() {
        if lobby.isTimerRunning {
            timer?.invalidate()
            timer = nil
            lobby.isTimerRunning = false
            lobby.elapsedTime = 0
        }
    }

    func pauseTimer() {
        if lobby.isTimerRunning {
            timer?.invalidate()
            timer = nil
            if let startTime = startTime {
                lobby.elapsedTime += Date().timeIntervalSince(startTime)
            }
            lobby.isTimerRunning = false
        }
    }

    private func updateElapsedTime() {
        if let startTime = startTime {
            lobby.elapsedTime = Date().timeIntervalSince(startTime)
        }
    }

    func getQuestion(candidates: [String]) -> Int {
        var result = -1
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            print("Json file not found")
            return result
        }

        do {
            let data = try Data(contentsOf: url)
            let questions = try JSONDecoder().decode([Question].self, from: data)

            // Pick a random question from the loaded array
            if let randomQuestion = questions.randomElement() {
            // self.lobby.question = randomQuestion.text
                let randomInt = Int.random(in: 0..<candidates.count)
                let replacementString = candidates[randomInt]
                let originalString = randomQuestion.text

                self.lobby.question = originalString.replacingOccurrences(of: "[Objek]", with: replacementString)
                result = randomInt
            }
        } catch {
            print("Error loading or decoding JSON: \(error)")
        }
        return result
    }

    func reset() {
    }

}
