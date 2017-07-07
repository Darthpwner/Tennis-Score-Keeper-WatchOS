//
//  TenPointTiebreakerInterfaceController.swift
//  Tennis-Score-Keeper-WatchOS
//
//  Created by Matthew Allen Lin on 7/6/17.
//  Copyright © 2017 Matthew Allen Lin Software. All rights reserved.
//

import WatchKit
import Foundation


class TenPointTiebreakerInterfaceController: WKInterfaceController {

    var metadata = Metadata(match_length_parameter: 1, ten_point_tiebreaker_format_parameter: 1)
    
    @IBAction func yesButtonAction() {
        metadata.ten_point_tiebreaker_format = 0
        
        // Use pushControllerWithName for a push segue
        self.pushController(withName: "ScoresInterfaceController", context: metadata)
    }
    
    @IBAction func noButtonAction() {
        metadata.ten_point_tiebreaker_format = 1
        
        // Use pushControllerWithName for a push segue
        self.pushController(withName: "ScoresInterfaceController", context: metadata)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        print("context: \(String(describing: context))")    // This prints nil
        
        // Configure interface objects here.
        if let passed_metadata = context as? Metadata {
            print("match_type: \(passed_metadata.match_length)")
            print("ten_point_tiebreaker_format: \(passed_metadata.ten_point_tiebreaker_format)")
            
            // Get the correct value of match_length from previous Interface Controller
            metadata.match_length = passed_metadata.match_length
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        print("Activated 10 point tiebreaker")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
