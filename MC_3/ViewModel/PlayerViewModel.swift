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
        let path = Bundle.main.path(forResource: fileName, ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            // couldn't load file :(
        }
    }
}
