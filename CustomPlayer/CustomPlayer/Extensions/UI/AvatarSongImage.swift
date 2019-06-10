//
//  AvatarSongImage.swift
//  CustomPlayer
//
//  Created by mac on 6/22/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

final class AvatarSongImage: UIImageView {
    func addRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = 2.0
        rotationAnimation.repeatCount = Float.infinity
        layer.add(rotationAnimation, forKey: nil)
    }
    
    func pauseLayer() {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeLayer() {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}
