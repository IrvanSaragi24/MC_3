//
//  Audio.swift
//  RecordAndClassify
//
//  Created by Hanifah BN on 18/07/23.
//

import Foundation

struct Audio {
    var isRecording: Bool = false
    var fileURL: URL?
    var duration: TimeInterval = 0.0
    var currentDecibelLevel: Float?
    var isSpeechDetected: String?
    var speechConfidence: Double?
}
