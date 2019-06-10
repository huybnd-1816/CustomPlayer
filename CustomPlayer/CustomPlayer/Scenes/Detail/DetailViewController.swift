//
//  DetailViewController.swift
//  CustomPlayer
//
//  Created by mac on 6/10/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import AVFoundation
import MediaPlayer

final class DetailViewController: UIViewController {
    @IBOutlet private weak var songTitleLabel: UILabel!
    @IBOutlet private weak var avatarSongImage: AvatarSongImage!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var audioTimeSlider: UISlider!
    
    private let audioManager = AudioManager.share
    private let timer = TimeCountDown.shared
    private var songs: [String] = []
    var songIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        audioManager.listenVolumeButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioManager.removeVolumeObserver()
    }
    
    func bindingData(_ songs: [String]) {
        self.songs = songs
    }
    
    private func config() {
        avatarSongImage.addRotationAnimation()
        audioManager.playInBackground()
        playButton.setImage(#imageLiteral(resourceName: "icon-play"), for: .selected)
        songTitleLabel.text = songs[songIndex]
        
        timer.startOrResumeTimer()
        
        // Set audio original volume
        audioManager.audioPlayer.volume = audioManager.audioLevel
        
        // Set slider's original value
        slider.value = self.audioManager.audioLevel
        
        // Set slider's value match MPVolumeView's volume
        audioManager.didVolumeChange = { [weak self] in
            guard let self = self else { return }
            self.slider.value = self.audioManager.audioLevel
        }
        
        // Action when timer count, audio time slider value will change
        timer.didSliderChanged = { [weak self] in
            guard let self = self else { return }
            self.audioTimeSlider.maximumValue = Float(self.audioManager.audioPlayer.duration)
            
            let index = Float(self.audioTimeSlider.value + 1)   // increase by 1
            self.audioTimeSlider.setValue(index, animated: true) // Set audio time slider value
            print(index)
            
            if self.audioTimeSlider.value >= self.audioTimeSlider.maximumValue {
                self.timer.pauseTimer()
                self.moveToNextAudio()
            }
        }
    }
    
    @IBAction func handlePlayButtonTapped(_ sender: Any) {
        if audioManager.audioPlayer.isPlaying { // Audio is playing
            audioManager.audioPlayer.pause()
            avatarSongImage.pauseLayer()
            playButton.isSelected = true
            timer.pauseTimer()
        } else {
            audioManager.audioPlayer.play()
            avatarSongImage.resumeLayer()
            playButton.isSelected = false
            timer.startOrResumeTimer()
        }
    }
    
    @IBAction func handlePrevButtonTapped(_ sender: Any) {
        playButton.isSelected = false
        resetTimer()
        timer.startOrResumeTimer()
        
        if songIndex != 0 {
            audioManager.playAudio(songs[songIndex - 1])
            songIndex -= 1
            songTitleLabel.text = songs[songIndex]
        }
    }
    
    @IBAction func handleNextButtonTapped(_ sender: Any) {
        moveToNextAudio()
    }
    
    func moveToNextAudio() {
        playButton.isSelected = false
        audioTimeSlider.value = 0
        resetTimer()
        timer.startOrResumeTimer()
        
        if songIndex < songs.count - 1 {
            audioManager.playAudio(songs[songIndex + 1])
            songIndex += 1
            songTitleLabel.text = songs[songIndex]
        } else {
            audioManager.playAudio(songs[0])
            songIndex = 0
            songTitleLabel.text = songs[0]
        }
    }
    
    func resetTimer() {
        audioTimeSlider.value = 0
        timer.pauseTimer()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        // Set audio volume match slider's value
        audioManager.audioPlayer.volume = sender.value
            
        // Set MPVolumeView's volume match slider's value
        MPVolumeView.setVolume(sender.value)
    }
    
    @IBAction func audioTimeSliderValueChanged(_ sender: UISlider) {
        audioManager.audioPlayer.currentTime = Double(sender.value)
    }
}
