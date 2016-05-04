//
//  VideoViewController.swift
//  Me
//
//  Created by James Pickering on 4/24/16.
//  Copyright © 2016 James Pickering. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {
    let playerController = AVPlayerViewController()
    var videoView: VideoView {
        return view as! VideoView
    }
    let descriptions = ["Name: James Pickering\nAge: 17\nOccupation: iOS Developer\nLocation: Abington, PA\nSchool: Germantown Friends School\nGrade: 11\nInterests: Programming, graphic design, writing music\nSports: Track & field, soccer, lacrosse\nFavorite Weather: 60 - 70 ˚F slightly cloudy\nFavorite Artists: Kendrick Lamar, Drake, BØRNS, Oh Wonder, The Weeknd, Future, Flume, Snakehips", "2013: Built app to find parking spots at the PilotPhilly hackathon\n2013-Present: Senior iOS Developer for Booksmart Technologies Inc., a company that automates booking concerts for artists and managers (used by 2 Chainz and A$AP Ferg)\n2014-Present: Consultant at Boston Heart Diagnostics doing web design\n2015: Built iOS app to scan ID's at clubs to automate checkin and registration (used at Coda in Philadelphia)\n2015: Built iOS app for Boston Heart Diagnostics to show videos at marketing trade shows\n2016: iOS internship at DeskConnect Inc. working on Workflow, an iOS automation app (won Apple Design Award 2015)", "Kanye West: Self confidence and not caring what other people think\nNikola Tesla: Work ethic and creativity\nMahatma Ghandi: Fighting peacefully\nMy Cousin: Strong feminism\nKendrick Lamar: Activism through music\nMy Father: Staying calm no matter what\n\n\"At the Grammys I said I inspired me\" - Kanye West"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoView.delegate = self
        
        let path = NSBundle.mainBundle().pathForResource("Club", ofType: ".mp4")!
        let URL = NSURL.fileURLWithPath(path)
        let player = AVPlayer(URL: URL)
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.None

        playerController.player = player
        playerController.view.frame = self.view.frame
        playerController.view.userInteractionEnabled = false
        playerController.showsPlaybackControls = false
        playerController.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerController.view.alpha = 0.0
        self.addChildViewController(playerController)
        self.view.insertSubview(playerController.view, atIndex: 0)
        
        player.play()
        NSNotificationCenter.defaultCenter().addObserverForName(AVPlayerItemDidPlayToEndTimeNotification, object: nil, queue: nil) { notification in
            player.seekToTime(kCMTimeZero)
            player.play()
        }
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: nil) { notification in
            player.seekToTime(kCMTimeZero)
            player.play()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        videoView.viewWillAppear()
        playerController.player?.play()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(10.0) {
            self.playerController.view.alpha = 1.0
        }
        if let flume = SoundService.shared.loadSound(FlumeSoundIdentifier, persistant: true) {
            flume.volume = 0.0
            flume.numberOfLoops = Int.max
            flume.play()
            SoundService.shared.fadeInSound(FlumeSoundIdentifier, maxVolume: 0.08, increment: 0.0008)
        }
    }
}

extension VideoViewController: VideoViewDelegate {
    
    func descriptionForSection(section: Int) -> String {
        return descriptions[section]
    }
}
