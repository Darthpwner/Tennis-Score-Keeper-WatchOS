//
//  MatchLengthInterfaceController.swift
//  Tennis-Score-Keeper-WatchOS
//
//  Created by Matthew Allen Lin on 7/3/17.
//  Copyright © 2017 Matthew Allen Lin Software. All rights reserved.
//

import WatchKit
import Foundation


class MatchLengthInterfaceController: WKInterfaceController {
    
    var metadata = Metadata(match_length_parameter: 1, ten_point_tiebreaker_format_parameter: 1)
    
    @IBAction func bestOfOneButton() {
        metadata.match_length = 0
        
        // Use pushControllerWithName for a push segue
        self.pushController(withName: "Ten Point Tiebreaker", context: metadata)
    }
    
    @IBAction func bestOfThreeButton() {
        metadata.match_length = 1
        
        // Use pushControllerWithName for a push segue
        self.pushController(withName: "Ten Point Tiebreaker", context: metadata)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
