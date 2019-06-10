//
//  AudioManager.swift
//  CustomPlayer
//
//  Created by mac on 6/16/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import AVFoundation

class AudioManager: NSObject {
    static let share = AudioManager()
    
    var audioPlayer: AVAudioPlayer!
    let audioSession = AVAudioSession.sharedInstance()
    var audioLevel: Float = AVAudioSession.sharedInstance().outputVolume {
        didSet {
            didVolumeChange?()
        }
    }
    
    let audioKey = "outputVolume"
    var didVolumeChange: (() -> Void)?
    
    func playAudio(_ song: String?) {
        let audioPath = Bundle.main.path(forResource: song, ofType: ".mp3")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayer.play()
        } catch {
            print("Cannot play audio: \(error.localizedDescription)")
        }
        return
    }
}

extension AudioManager {
    // Tracking volume button
    func listenVolumeButton(){
        do {
            try audioSession.setActive(true, options: [])
            audioSession.addObserver(self, forKeyPath: audioKey,
                                     options: NSKeyValueObservingOptions.new, context: nil)
            audioLevel = audioSession.outputVolume
        } catch {
            print("Error")
        }
    }
    
    func removeVolumeObserver() {
        audioSession.removeObserver(self, forKeyPath: audioKey)
    }
    
    // Play song in background
    func playInBackground() {
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == audioKey {
            let audioSession = AVAudioSession.sharedInstance()
            if audioSession.outputVolume > audioLevel { // Volume Up
                print("Volume Up")
            }
            if audioSession.outputVolume < audioLevel { // Volume Down
                print("Volume Down")
            }
            
            self.audioLevel = audioSession.outputVolume
            self.audioPlayer.volume = self.audioLevel
        }
    }
}
