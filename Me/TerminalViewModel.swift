//
//  TerminalViewModel.swift
//  Me
//
//  Created by James Pickering on 4/27/16.
//  Copyright © 2016 James Pickering. All rights reserved.
//

import UIKit

class TerminalViewModel: NSObject {
    let consoleMessages = ["[!] Please use headphones", "[*] Rendering person...", "[*] Press forcefully to continue..."]
    let textGlyphs = [".r===a.\n//    \\\\\n|X      X|\n•OM•    <A0*\n\\VV•    \\VV*", ".==.\nC••D\n\\--/\ne--|--e\n/\\\n='  `=", "   H\\\n     HHHA\n========HHHHHO>\n     HHHV\n   H/"]
    
    var shakingEnabled = false
    var currentForce: CGFloat = 0.0
}