//
//  SynthesizerViewModel.swift
//  RecordAndClassify
//
//  Created by Hanifah BN on 20/07/23.
//

import Foundation
import AVFoundation

class SynthesizerViewModel: ObservableObject {
    
    let synthesizer = AVSpeechSynthesizer()
    
    // Retrieve the British English voice.
    let voice = AVSpeechSynthesisVoice(language: "id-ID")
    
    func startSpeaking(spokenString: String){
        // Create an utterance.
        let utterance = AVSpeechUtterance(string: spokenString)


        // Configure the utterance.
        utterance.rate = 0.57
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 1.0

        // Assign the voice to the utterance.
        utterance.voice = voice

        // Tell the synthesizer to speak the utterance.
        synthesizer.speak(utterance)

//        synthesizer.stopSpeaking()
    }
}
