//
//  TerminalView.swift
//  Me
//
//  Created by James Pickering on 4/30/16.
//  Copyright © 2016 James Pickering. All rights reserved.
//

import UIKit

let FlickerAnimationKey = "FlickerAnimationKey"
let ShakeAnimationKey = "ShakeAnimationKey"

class TerminalView: UIView {
    @IBOutlet weak var glyphLabel: UILabel!
    @IBOutlet weak var consoleLabel: UILabel!
    weak var linesView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let linesView = UIImageView()
        linesView.image = UIImage(named: "Terminal Background")
        linesView.contentMode = .ScaleAspectFill
        self.insertSubview(linesView, atIndex: 0)
        self.linesView = linesView
    }
    
    func viewWillAppear() {
        linesView.frame = bounds
        linesView.layer.addAnimation(flickerAnimation(YDirection), forKey: FlickerAnimationKey)
        glyphLabel.layer.addAnimation(flickerAnimation(XDirection), forKey: FlickerAnimationKey)
        consoleLabel.layer.addAnimation(flickerAnimation(XDirection), forKey: FlickerAnimationKey)
    }
    
    func flickerAnimation(direction: String) -> CAAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.\(direction)")
        let from = NSNumber(double: -1.0)
        let to = NSNumber(double: 1.0)
        animation.values = [from, to]
        animation.autoreverses = true
        animation.duration = 0.003
        animation.repeatCount = Float.infinity
        return animation
    }
    
    func shakeAnimation(angle: CGFloat) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        let left = NSValue(CATransform3D: CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0))
        let right = NSValue(CATransform3D: CATransform3DMakeRotation(-angle, 0.0, 0.0, 1.0))
        animation.values = [left, right]
        animation.autoreverses = true
        animation.duration = 0.03
        animation.delegate = self
        return animation
    }
    
//    func applyShakeAnimation(force: CGFloat) {
//        consoleLabel.layer.addAnimation(shakeAnimation(force / 100.0), forKey: ShakeAnimationKey)
//        glyphLabel.layer.addAnimation(shakeAnimation(force / 100.0), forKey: ShakeAnimationKey)
//        linesView.layer.addAnimation(shakeAnimation(force / 100.0), forKey: ShakeAnimationKey)
//    }
    
    func updateShakeAnimation(force: CGFloat) -> Bool {
        if consoleLabel.layer.animationForKey(ShakeAnimationKey) != nil {
            consoleLabel.layer.removeAnimationForKey(ShakeAnimationKey)
//            glyphLabel.layer.removeAnimationForKey(ShakeAnimationKey)
//            linesView.layer.removeAnimationForKey(ShakeAnimationKey)
        }
        if force > 0 {
            consoleLabel.layer.addAnimation(shakeAnimation(force / 100.0), forKey: ShakeAnimationKey)
//            glyphLabel.layer.addAnimation(shakeAnimation(force / 100.0), forKey: ShakeAnimationKey)
//            linesView.layer.addAnimation(shakeAnimation(force / 100.0), forKey: ShakeAnimationKey)
            return true
        } else {
            return false
        }
    }
}
