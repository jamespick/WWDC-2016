//
//  App.swift
//  Me
//
//  Created by James Pickering on 4/27/16.
//  Copyright © 2016 James Pickering. All rights reserved.
//

import UIKit

struct Flow {
    static func delay(seconds: NSTimeInterval, closure: () -> ()) {
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(seconds * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            closure()
        }
    }
}
