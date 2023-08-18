//
//  VoiceActivityDetector.swift
//  RecordAndClassify
//
//  Created by Hanifah BN on 20/07/23.
//

import SoundAnalysis
import Foundation

class VoiceActivityDetector: NSObject, SNResultsObserving {
    private let categoryID: String = "speech"
    var isSpeechDetected: String?
    var speechConfidence: Double?
    var lastSpeechDetectedTimestamp: Date?

    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let speechResult = result as? SNClassificationResult else {
            return
        }

        if let speechObservation = speechResult.classifications.first(where: { $0.identifier == "speech" }) {
            let isSpeechDetected = speechObservation.confidence >= 0.5

            if isSpeechDetected {
                // Speech is detected, update the lastSpeechDetectedTimestamp
                lastSpeechDetectedTimestamp = Date()
            }

            self.isSpeechDetected = speechObservation.confidence >= 0.5 ? "Yes" : "No"
            self.speechConfidence = speechObservation.confidence
        }
    }

    // Notifies the observer when a request generates an error.
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The analysis failed: \(error.localizedDescription)")
    }

    // Notifies the observer when a request is complete.
    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }

//    func request(_ request: SNRequest, didProduce result: SNResult) {
//        guard let result = result as? SNClassificationResult,
//              let _ = result.classification(forIdentifier: categoryID) else {
//            return
//        }
//
//        lastestTimeStamp = result.timeRange.start
//    }
}

//    /// Notifies the observer when a request generates a prediction.
//    func request(_ request: SNRequest, didProduce result: SNResult) {
//        // Downcast the result to a classification result.
//        guard let result = result as? SNClassificationResult else  { return }
//
//
//        // Get the prediction with the highest confidence.
//        guard let classification = result.classifications.first else { return }
//
//
//        // Get the starting time.
//        let timeInSeconds = result.timeRange.start.seconds
//
//
//        // Convert the time to a human-readable string.
//        let formattedTime = String(format: "%.2f", timeInSeconds)
//        print("Analysis result for audio at time: \(formattedTime)")
//
//
//        // Convert the confidence to a percentage string.
//        let percent = classification.confidence * 100.0
//        let percentString = String(format: "%.2f%%", percent)
//
//
//        // Print the classification's name (label) with its confidence.
//        print("\(classification.identifier): \(percentString) confidence.\n")
//    }
