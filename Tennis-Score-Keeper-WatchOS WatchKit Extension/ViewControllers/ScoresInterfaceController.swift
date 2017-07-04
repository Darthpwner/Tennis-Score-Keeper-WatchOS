//
//  ScoresInterfaceController.swift
//  Tennis-Score-Keeper-WatchOS
//
//  Created by Matthew Allen Lin on 7/3/17.
//  Copyright © 2017 Matthew Allen Lin Software. All rights reserved.
//

import WatchKit
import Foundation


class ScoresInterfaceController: WKInterfaceController {

    //Outlets
    /* Set Scores */
    @IBOutlet var player_1_set_1_score: WKInterfaceLabel!
    @IBOutlet var player_2_set_1_score: WKInterfaceLabel!
    @IBOutlet var player_1_set_2_score: WKInterfaceLabel!
    @IBOutlet var player_2_set_2_score: WKInterfaceLabel!
    @IBOutlet var player_1_set_3_score: WKInterfaceLabel!
    @IBOutlet var player_2_set_3_score: WKInterfaceLabel!
    
    /* Game Scores */
    @IBOutlet var player_1_game_score: WKInterfaceLabel!
    @IBOutlet var player_2_game_score: WKInterfaceLabel!
    
    /* Player Serving Images */
    @IBOutlet var player_1_serving_image: WKInterfaceImage!
    @IBOutlet var player_2_serving_image: WKInterfaceImage!
    
    /* Increment Scores */
    @IBAction func incrementPlayerOneScore() {
    
    }
    
    @IBAction func incrementPlayerTwoScore() {
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
