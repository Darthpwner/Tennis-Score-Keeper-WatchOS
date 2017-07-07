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

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("context: \(String(describing: context))")    // This prints nil
        
        // Configure interface objects here.
        if let metadata = context as? Metadata {
            print("match_type: \(metadata.match_length)")
            print("ten_point_tiebreaker_format: \(metadata.ten_point_tiebreaker_format)")
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
