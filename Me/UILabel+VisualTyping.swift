//
//  UILabel+VisualTyping.swift
//  Me
//
//  Created by James Pickering on 4/26/16.
//  Copyright © 2016 James Pickering. All rights reserved.
//

import UIKit

extension UILabel {
    func type(message: String, playsSound: Bool){
        text = ""
        let duration = 0.7 * Double(NSEC_PER_SEC)
        let sleepTime = duration / Double(message.characters.count)
        var i = 0
        var currentText = ""
        func type() {
            if i < message.characters.count {
                currentText += String(message[message.startIndex.advancedBy(i)])
                if playsSound == true {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                        if let sound = SoundService.shared.loadSound(KeySoundIdentifier, persistant: false) {
                            sound.pan = Float(drand48()) * (arc4random_uniform(2) == 0 ? 1.0: -1.0)
                            sound.volume = Float(drand48()) * 0.5
                            sound.play()
                        }
                    })
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.text = currentText
                })
                i += 1
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(sleepTime))
                dispatch_after(time, dispatch_get_main_queue()) {
                    type()
                }
            }
        }
        type()
    }
}