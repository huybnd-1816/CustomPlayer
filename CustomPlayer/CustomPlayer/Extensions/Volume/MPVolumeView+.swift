//
//  MPVolumeView+.swift
//  CustomPlayer
//
//  Created by mac on 6/18/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import MediaPlayer

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        // Need to use the MPVolumeView in order to change volume, but don't care about UI set so frame to .zero
        let volumeView = MPVolumeView()
        // Search for the slider
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        // Update the slider value with the desired volume.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
        
        // Optional - Remove the HUD
//        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//            volumeView.alpha = 0.000001
//            window.addSubview(volumeView)
//        }
    }
}
