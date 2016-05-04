//
//  VideoView.swift
//  Me
//
//  Created by James Pickering on 4/30/16.
//  Copyright © 2016 James Pickering. All rights reserved.
//

import UIKit

protocol VideoViewDelegate {
    func descriptionForSection(section: Int) -> String
}

class VideoView: UIView {
    weak var aboutButton: UIButton!
    weak var workButton: UIButton!
    weak var inspirationButton: UIButton!
    weak var closeButton: UIButton!
    weak var descriptionView: UIView!
    weak var descriptionLabel: UITextView!
//    weak var profilePicture: UIImageView!
//    weak var linkedInButton: UIButton!
//    weak var facebookButton: UIButton!
    weak var profileView: UIView!
    @IBOutlet weak var introLabel: UILabel!
    
    var originalButtonFrames = [UIButton: CGRect]()
    var selectedButtonFrame: CGRect {
        return CGRectMake(center.x - 65, 100, 200, 50)
    }
    var selectedButton: UIButton?
    var unselectedButtons: [UIButton]?
    var delegate: VideoViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        let sectionButtonModel = UIButton(type: .Custom)
//        sectionButtonModel.frame = CGRectMake(0, 0, 200, 50)
//        sectionButtonModel.backgroundColor = UIColor.whiteColor()
//        sectionButtonModel.setTitleColor(Theme.orangeColor(), forState: .Normal)
//        sectionButtonModel.layer.cornerRadius = 25.0
//        sectionButtonModel.alpha = 0.0
//        let archived = NSKeyedArchiver.archivedDataWithRootObject(sectionButtonModel)
        
        let aboutButton = modelButton()
        aboutButton.tag = 0
        aboutButton.setTitle("About", forState: .Normal)
        aboutButton.addTarget(self, action: #selector(VideoView.showAbout), forControlEvents: .TouchUpInside)
        self.addSubview(aboutButton)
        self.aboutButton = aboutButton
        
        let workButton = modelButton()
        workButton.tag = 1
        workButton.setTitle("Experience", forState: .Normal)
        workButton.addTarget(self, action: #selector(VideoView.showWork), forControlEvents: .TouchUpInside)
        self.addSubview(workButton)
        self.workButton = workButton
        
        let inspirationButton = modelButton()
        inspirationButton.tag = 2
        inspirationButton.setTitle("Inspirations", forState: .Normal)
        inspirationButton.addTarget(self, action: #selector(VideoView.showInspiration), forControlEvents: .TouchUpInside)
        self.addSubview(inspirationButton)
        self.inspirationButton = inspirationButton
        
        let closeButton = UIButton(type: .Custom)
        closeButton.frame = CGRectMake(0, 0, 50.0, 50.0)
        closeButton.backgroundColor = UIColor.whiteColor()
        closeButton.layer.cornerRadius = 25.0
        closeButton.alpha = 0.0
        closeButton.setImage(UIImage(named: "Close"), forState: .Normal)
        closeButton.addTarget(self, action: #selector(VideoView.closeSection), forControlEvents: .TouchUpInside)
        self.addSubview(closeButton)
        self.closeButton = closeButton
        
        let descriptionView = UIView(frame: CGRectMake(0, 0, 270, bounds.height - 200))
        //let descriptionView = UIView(frame: CGRectMake(0, 0, bounds.width, bounds.height - 170))
        descriptionView.backgroundColor = UIColor.whiteColor()
        descriptionView.layer.cornerRadius = 25.0
        descriptionView.clipsToBounds = true
        self.addSubview(descriptionView)
        self.descriptionView = descriptionView
        
        let descriptionLabel = UITextView(frame: descriptionView.frame)
        descriptionLabel.textColor = UIColor(red: 40/255.0, green: 40/255.0, blue: 50/255.0, alpha: 1.0)
        descriptionLabel.editable = false
        descriptionLabel.selectable = false
        descriptionLabel.textContainerInset = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)
        descriptionView.addSubview(descriptionLabel)
        self.descriptionLabel = descriptionLabel
        
        let profileView = UIView(frame: CGRectMake(0, 0, 150.0, 150.0))
        profileView.backgroundColor = UIColor.clearColor()
        profileView.alpha = 0.0
        self.addSubview(profileView)
        self.profileView = profileView
        
        let profilePicture = UIImageView(image: UIImage(named: "Profile"))
        profilePicture.contentMode = .ScaleAspectFill
        profilePicture.layer.cornerRadius = 75
        profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        profilePicture.layer.borderWidth = 5.0
        profilePicture.clipsToBounds = true
        profilePicture.frame = CGRectMake(0, 0, 150.0, 150.0)
        profileView.addSubview(profilePicture)
        //self.profilePicture = profilePicture
        
        let linkedInButton = UIButton(type: .Custom)
        linkedInButton.setImage(UIImage(named: "LinkedIn"), forState: .Normal)
        linkedInButton.frame = CGRectMake(0, 110, 40.0, 40.0)
        linkedInButton.layer.cornerRadius = 20.0
        linkedInButton.backgroundColor = UIColor.whiteColor()
        linkedInButton.addTarget(self, action: #selector(VideoView.openLinkedIn), forControlEvents: .TouchUpInside)
        profileView.addSubview(linkedInButton)
        //self.linkedInButton = linkedInButton
        
        let facebookButton = UIButton(type: .Custom)
        facebookButton.setImage(UIImage(named: "Facebook"), forState: .Normal)
        facebookButton.frame = CGRectMake(110, 110, 40.0, 40.0)
        facebookButton.layer.cornerRadius = 20.0
        facebookButton.backgroundColor = UIColor.whiteColor()
        facebookButton.addTarget(self, action: #selector(VideoView.openFacebook), forControlEvents: .TouchUpInside)
        profileView.addSubview(facebookButton)
        //self.facebookButton = facebookButton
    }
    
    func modelButton() -> UIButton {
        let sectionButtonModel = UIButton(type: .Custom)
        sectionButtonModel.frame = CGRectMake(0, 0, 200, 50)
        sectionButtonModel.backgroundColor = UIColor.whiteColor()
        sectionButtonModel.setTitleColor(Theme.orangeColor(), forState: .Normal)
        sectionButtonModel.layer.cornerRadius = 25.0
        sectionButtonModel.alpha = 0.0
        sectionButtonModel.titleLabel!.font = UIFont.systemFontOfSize(17.0, weight: UIFontWeightMedium)
        return sectionButtonModel
    }
    
    func openFacebook() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/jamesestmoi")!)
    }
    
    func openLinkedIn() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.linkedin.com/in/jamespickering1")!)
    }
    
    func viewWillAppear() {
//        let heightOfElements: CGFloat = 360.0
//        let topOffset = (bounds.height - heightOfElements) / 2.0
//        profilePicture.center = CGPointMake(center.x, topOffset + 75)
//        setOriginalFrame(aboutButton, center: CGPointMake(center.x, topOffset + 195))
//        setOriginalFrame(workButton, center: CGPointMake(center.x, topOffset + 265))
//        setOriginalFrame(inspirationButton, center: CGPointMake(center.x, topOffset + 340))
        
        let spacing: CGFloat = 30.0
        let buttonHeight: CGFloat = 50.0
        let totalHeight = profileView.frame.size.height + buttonHeight * 3.0 + spacing * 3.0
        
        var yOffset = (bounds.height - totalHeight) / 2.0
        profileView.frame = offset(profileView.frame, y: yOffset)
//        linkedInButton.frame = CGRectOffset(linkedInButton.frame, bounds.width / 2.0 - 70, yOffset + profilePicture.frame.height - linkedInButton.frame.height)
//        facebookButton.frame = CGRectOffset(facebookButton.frame, bounds.width / 2.0 + 70 - facebookButton.frame.width, yOffset + profilePicture.frame.height - linkedInButton.frame.height)
        
        yOffset += profileView.frame.height + spacing
        aboutButton.frame = offset(aboutButton.frame, y: yOffset)
        aboutButton.layer.cornerRadius = 25.0
        originalButtonFrames[aboutButton] = aboutButton.frame
        
        yOffset += aboutButton.frame.height + spacing
        workButton.frame = offset(workButton.frame, y: yOffset)
        workButton.layer.cornerRadius = 25.0
        originalButtonFrames[workButton] = workButton.frame
        
        yOffset += workButton.frame.height + spacing
        inspirationButton.frame = offset(inspirationButton.frame, y: yOffset)
        inspirationButton.layer.cornerRadius = 25.0
        originalButtonFrames[inspirationButton] = inspirationButton.frame
        
        closeButton.center = CGPointMake(center.x - 110, 125)
        descriptionView.center = CGPointMake(center.x, bounds.height + descriptionView.frame.height / 2.0)
        
        Flow.delay(1.5) {
            //self.introLabel.type("[*] This is my life...", playsSound: true)
            Flow.delay(2.0) {
                UIView.animateWithDuration(3.0, animations: {
                    self.introLabel.alpha = 0.0
                    self.aboutButton.alpha = 1.0
                    self.workButton.alpha = 1.0
                    self.inspirationButton.alpha = 1.0
                    self.profileView.alpha = 1.0
                })
            }
        }
    }
    
    func offset(rect: CGRect, y: CGFloat) -> CGRect {
        return CGRectOffset(rect, bounds.width / 2.0 - rect.width / 2.0, y)
    }
    
    func setOriginalFrame(button: UIButton, center: CGPoint) {
        button.center = center
        button.layer.cornerRadius = 25.0
        originalButtonFrames[button] = button.frame
    }
    
    func showAbout() {
        showSection(aboutButton, otherButtons: [workButton, inspirationButton])
    }
    
    func showWork() {
        showSection(workButton, otherButtons: [inspirationButton, aboutButton])
    }
    
    func showInspiration() {
        showSection(inspirationButton, otherButtons: [aboutButton, workButton])
    }
    
    func showSection(selectedButton: UIButton, otherButtons: [UIButton]) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 10.0
        
        let string = NSMutableAttributedString(string: delegate!.descriptionForSection(selectedButton.tag))
        string.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, string.length))
        string.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(15.0), range: NSMakeRange(0, string.length))
        let rect = descriptionLabel.attributedText!.boundingRectWithSize(CGSizeMake(descriptionView.frame.width - 40, 1000),
                                                              options: .UsesLineFragmentOrigin, context: nil)
        var descriptionLabelFrame = descriptionLabel.frame
        descriptionLabelFrame.size.height = rect.height
        
        let expression = try! NSRegularExpression(pattern: ".*:", options: NSRegularExpressionOptions())
        expression.enumerateMatchesInString(string.string, options: NSMatchingOptions(), range: NSMakeRange(0, string.length)) { (result, _, _) in
            string.addAttribute(NSForegroundColorAttributeName, value: Theme.orangeColor(), range: result!.rangeAtIndex(0))
        }
        descriptionLabel.attributedText = string
        //descriptionLabel.frame = descriptionLabelFrame
        
        self.unselectedButtons = otherButtons
        selectedButton.userInteractionEnabled = false
        self.selectedButton = selectedButton
        var closeFrame = closeButton.frame
        closeFrame.size.width = 50.0
        closeFrame.size.height = 50.0
        var descriptionFrame = descriptionView.frame
        descriptionFrame.origin.y = 170.0
        bounce {
            self.profileView.alpha = 0.0
            self.descriptionView.frame = descriptionFrame
            //self.closeButton.frame = closeFrame
            self.closeButton.alpha = 1.0
            self.closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            selectedButton.frame = self.selectedButtonFrame
            for button in otherButtons {
                button.frame = self.originalButtonFrames[button]!
                button.alpha = 0.0
            }
        }
    }
    
    func closeSection() {
        let selectedButton = self.selectedButton!
        let unselectedButtons = self.unselectedButtons!
        selectedButton.userInteractionEnabled = true
        var closeFrame = closeButton.frame
        closeFrame.size.width = 0.0
        closeFrame.size.height = 0.0
        var descriptionFrame = descriptionView.frame
        descriptionFrame.origin.y = bounds.height + 100
        bounce {
            self.profileView.alpha = 1.0
            self.descriptionView.frame = descriptionFrame
            //self.closeButton.frame = closeFrame
            self.closeButton.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI_2))
            self.closeButton.alpha = 0.0
            selectedButton.frame = self.originalButtonFrames[self.selectedButton!]!
            for button in unselectedButtons {
                button.alpha = 1.0
            }
        }
        self.unselectedButtons = nil
        self.selectedButton = nil
    }
    
    func bounce(animations: () -> ()) {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .CurveLinear, animations: animations, completion: nil)
    }
}
