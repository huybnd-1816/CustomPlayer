//
//  MainViewModel.swift
//  CustomPlayer
//
//  Created by mac on 6/16/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import AVFoundation

final class MainViewModel: BaseViewModel {
    var songs: [String] = [] {
        didSet {
            didChange?(.success)
        }
    }
    
    var count: Int {
        return songs.count
    }
    
    subscript (index: Int) -> String? {
        return songs[index]
    }
    
    private var didChange: ((BaseResult) -> Void)?
    
    func bind(didChange: @escaping (BaseResult) -> Void) {
        self.didChange = didChange
    }
    
    func reloadData() {
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for song in songPath {
                var mySong = song.absoluteString // Get song's url
                if mySong.contains(".mp3") {
                    let findString = mySong.components(separatedBy: "/") // Separate string has "/" into an array
                    mySong = findString[findString.count - 1] // Get the original song
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    songs.append(mySong)
                }
            }
        } catch {
            didChange?(.failure(error: error))
        }
    }
}
