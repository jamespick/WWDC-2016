//
//  Created by Artem Sidorenko on 9/11/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/StarWars.iOS
//

import UIKit

class StarWarsUIViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var duration: NSTimeInterval = 2.0
    var spriteWidth: CGFloat = 20.0
    var snapshots = [UIView]()
    var transitionContext: UIViewControllerContextTransitioning?
    var animationGroup = dispatch_group_create()

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView()!
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
        
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)
        
        let size = fromView.frame.size
        
        func randomFloatBetween(smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
            let diff = bigNumber - smallNumber
            return CGFloat(arc4random()) / 100.0 % diff + smallNumber
        }
        
        // snapshot the from view, this makes subsequent snaphots more performant
        let fromViewSnapshot = fromView.snapshotViewAfterScreenUpdates(false)
        
        let width = spriteWidth
        let height = width
        
        for x in CGFloat(0).stride(through: size.width, by: width) {
            for y in CGFloat(0).stride(through: size.height, by: height) {
                
                let snapshotRegion = CGRect(x: x, y: y, width: width, height: height)
                
                let snapshot = fromViewSnapshot.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
                
                containerView.addSubview(snapshot)
                snapshot.frame = snapshotRegion
                snapshots.append(snapshot)
            }
        }
        
        print(snapshots.count)
        
        containerView.sendSubviewToBack(fromView)
        
        let d2 = pow(Double(fromView.center.x), 2) + pow(Double(fromView.center.y), 2)
        for view in snapshots {
            let m = Double((view.center.y - fromView.center.y) / (view.center.x - fromView.center.x))
            let x: Double
            if view.center.x < fromView.center.x {
                x = Double(view.center.x) - sqrt(d2 / (1 + pow(m, 2)))
            } else {
                x = Double(view.center.x) + sqrt(d2 / (1 + pow(m, 2)))
            }
            let y = m * (x - Double(view.center.x)) + Double(view.center.y)
            
            let xOffsetAnimation = CABasicAnimation(keyPath: "position.x")
            xOffsetAnimation.fromValue = NSNumber(double: Double(view.layer.position.x))
            xOffsetAnimation.toValue = NSNumber(double: x)
            
            let yOffsetAnimation = CABasicAnimation(keyPath: "position.y")
            yOffsetAnimation.fromValue = NSNumber(double: Double(view.layer.position.y))
            yOffsetAnimation.toValue = NSNumber(double: y)
            
            let group = CAAnimationGroup()
            group.duration = duration
            group.removedOnCompletion = false
            group.fillMode = kCAFillModeForwards
            group.timingFunction = CAMediaTimingFunction(controlPoints: 0.0, 0.9, 1, 1)
            group.animations = [xOffsetAnimation, yOffsetAnimation]
            group.delegate = self
            dispatch_group_enter(animationGroup)
            view.layer.addAnimation(group, forKey: "group")
        }
        
        dispatch_group_notify(animationGroup, dispatch_get_main_queue()) { 
            for view in self.snapshots {
                view.removeFromSuperview()
            }
            self.transitionContext!.completeTransition(!self.transitionContext!.transitionWasCancelled())
        }
        
//        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseIn,  animations: {
//            for view in self.snapshots {
//                
//                let xOffset: CGFloat = 0.0
//                let yOffset: CGFloat = randomFloatBetween(fromView.frame.height, and: fromView.frame.height * 1.3)
//                view.frame = view.frame.offsetBy(dx: xOffset, dy: yOffset)
//            }
//            }) { finished in
//                for view in self.snapshots {
//                    view.removeFromSuperview()
//                }
//                self.transitionContext!.completeTransition(!self.transitionContext!.transitionWasCancelled())
//        }
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        dispatch_group_leave(animationGroup)
    }
}
