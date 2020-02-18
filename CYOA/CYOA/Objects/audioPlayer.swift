////
////  audioPlayer.swift
////  CYOA
////
////  Created by Luigi Anonymus on 2020-02-18.
////  Copyright © 2020 Michael De Stefano. All rights reserved.
////
//
//import Foundation
//import AVFoundation
//
//var player: AVAudioPlayer?
//
//func playSound(sound: String) {
//    guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
//
//    do {
//        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//        try AVAudioSession.sharedInstance().setActive(true)
//
//        /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//        /* iOS 10 and earlier require the following line:
//        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//
//        guard let player = player else { return }
//
//        player.play()
//
//    } catch let error {
//        print(error.localizedDescription)
//    }
//}
