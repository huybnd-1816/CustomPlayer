//
//  TimeCountDown.swift
//  CustomPlayer
//
//  Created by mac on 6/22/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

class TimeCountDown: NSObject {
    static let shared = TimeCountDown()
    private var timer = Timer()
    var didSliderChanged: (() -> Void)?
    
    private override init() {}
    
    func pauseTimer() {
        timer.invalidate()
    }
    
    func startOrResumeTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    @objc
    func updateSlider(timer: Timer) {
        didSliderChanged?()
    }
}
