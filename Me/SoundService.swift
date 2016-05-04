//
//  SoundService.swift
//  Me
//
//  Created by James Pickering on 4/26/16.
//  Copyright © 2016 James Pickering. All rights reserved.
//

import UIKit
import AVFoundation

let HumSoundIdentifier = "HumSound"
let BassSoundIdentifier = "BassSound"
let BoomSoundIdentifier = "BoomSound"
let FlumeSoundIdentifier = "FlumeSound"
let KeySoundIdentifier = "KeySound"

class SoundService: NSObject {
    static let shared = SoundService()
    private var loaded = [String: AVAudioPlayer]()
    private var references = [AVAudioPlayer]()
    
    func loadSound(identifier: String, persistant: Bool) -> AVAudioPlayer? {
        if persistant == true {
            if let sound = loaded[identifier] {
                return sound
            }
        }
        let path = NSBundle.mainBundle().pathForResource(identifier, ofType: "m4a")!
        let url = NSURL(fileURLWithPath: path)
        do {
            let sound =  try AVAudioPlayer(contentsOfURL: url)
            if persistant == true {
                loaded[identifier] = sound
            } else {
                references.append(sound)
            }
            return sound
        } catch {
            return nil
        }
    }
    
    func fadeOutSound(identifier: String) {
        if let sound = loaded[identifier] {
            sound.volume = sound.volume - 0.1
            if sound.volume > 0.0 {
                performSelector(#selector(SoundService.fadeOutSound(_:)), withObject: identifier, afterDelay: 0.1)
            } else {
                sound.stop()
            }
        }
    }
    
    func fadeInSound(identifier: String, maxVolume: Float, increment: Float) {
        func fadeIn() {
            if let sound = loaded[identifier] {
                sound.volume = sound.volume + increment
                if sound.volume < maxVolume {
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(NSEC_PER_SEC) / 10)
                    dispatch_after(time, dispatch_get_main_queue()) {
                        fadeIn()
                    }
                }
            }
        }
        fadeIn()
    }
}
