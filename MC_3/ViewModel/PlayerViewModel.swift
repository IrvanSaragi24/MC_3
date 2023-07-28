//
//  PlayerViewModel.swift
//  MC_3
//
//  Created by Hanifah BN on 28/07/23.
//

import Foundation
import AVFoundation

class PlayerViewModel: ObservableObject {
    var player: AVAudioPlayer?
    
    func playAudio(fileName: String){
        do {
           // Set the audio session category to Playback
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
        
        guard let audioURL = Bundle.main.url(forResource: fileName, withExtension: "m4a") else {
            print("Audio file not found.")
                return
        }

        do {
            // Create the AVAudioPlayer instance with the audio file URL
            player = try AVAudioPlayer(contentsOf: audioURL)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}
