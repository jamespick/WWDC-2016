//
//  ViewController.swift
//  Me
//
//  Created by James Pickering on 4/19/16.
//  Copyright © 2016 James Pickering. All rights reserved.
//

import UIKit

let XDirection = "x"
let YDirection = "y"

class TerminalViewController: UIViewController {
    var viewModel = TerminalViewModel()
    var terminalView: TerminalView {
        return view as! TerminalView
    }
    
    //var currentForce: CGFloat = 0.0
    var bassEnabled = true
    var messageIdx = 0
    var token: dispatch_once_t = 0
    
    var currentLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hum = SoundService.shared.loadSound(HumSoundIdentifier, persistant: true)!
        hum.volume = 0.003
        hum.numberOfLoops = Int.max
        hum.play()
        
        let bass = SoundService.shared.loadSound(BassSoundIdentifier, persistant: true)!
        bass.volume = 0.008
        bass.numberOfLoops = Int.max
        
        let boom = SoundService.shared.loadSound(BoomSoundIdentifier, persistant: true)!
        boom.volume = 0.5
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        terminalView.viewWillAppear()
    }
        
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showNextMessage()
        Flow.delay(4.0) {
            self.showNextMessage()
            Flow.delay(4.0, closure: {
                self.showNextMessage()
            })
        }
    }
    
    func showNextMessage() {
        terminalView.consoleLabel.type(viewModel.consoleMessages[messageIdx], playsSound: true)
        terminalView.glyphLabel.type(viewModel.textGlyphs[messageIdx], playsSound: false)
        messageIdx += 1
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        viewModel.shakingEnabled = terminalView.updateShakeAnimation(viewModel.currentForce)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        updateCurrentForce(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        updateCurrentForce(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        updateCurrentForce(touches)
    }
    
    func updateCurrentForce(touches: Set<UITouch>) {
        if messageIdx == viewModel.consoleMessages.count {
            if let touch = touches.first where traitCollection.forceTouchCapability == .Available {
                if (viewModel.currentForce == 0.0 && touch.force > 0.0) && viewModel.shakingEnabled == false {
                    viewModel.shakingEnabled = terminalView.updateShakeAnimation(touch.force)
                }
                if bassEnabled == true {
                    if let bass = SoundService.shared.loadSound(BassSoundIdentifier, persistant: true) {
                        if bass.playing == false {
                            bass.play()
                        }
                        bass.volume = (Float(touch.force) / Float(touch.maximumPossibleForce))
                        print(bass.volume)
                    }
                }
                viewModel.currentForce = touch.force
                if touch.force == touch.maximumPossibleForce {
                    dispatch_once(&self.token, {
                        self.bassEnabled = false
                        SoundService.shared.loadSound(BoomSoundIdentifier, persistant: true)?.play()
                        SoundService.shared.fadeOutSound(BassSoundIdentifier)
                        SoundService.shared.fadeOutSound(HumSoundIdentifier)
                        self.performSegueWithIdentifier("1", sender: self)
                    })
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segue.destinationViewController.transitioningDelegate = self
    }
}

extension TerminalViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StarWarsUIViewAnimator()
    }
}