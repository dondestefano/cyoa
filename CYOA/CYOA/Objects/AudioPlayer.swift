//
//  AudioPlayer.swift
//  CYOA
//
//  Created by Michael De Stefano on 2020-02-18.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer {
    
    var soundPlayer: AVAudioPlayer!

    func playSound(sound: String) {
        let path = Bundle.main.path(forResource: sound, ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.play()
        } catch {
            return
        }
    }
}
