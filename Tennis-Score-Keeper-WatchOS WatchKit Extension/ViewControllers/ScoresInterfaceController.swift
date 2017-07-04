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

    // Game score values
    var player_1_points_won_this_game = 0
    var player_2_points_won_this_game = 0
    
    // Set score values
    var player_1_set_1_score = 0
    var player_2_set_1_score = 0
    var player_1_set_2_score = 0
    var player_2_set_2_score = 0
    var player_1_set_3_score = 0
    var player_2_set_3_score = 0
    
    //Outlets
    /* Set Scores */
    @IBOutlet var player_1_set_1_score_label: WKInterfaceLabel!
    @IBOutlet var player_2_set_1_score_label: WKInterfaceLabel!
    @IBOutlet var player_1_set_2_score_label: WKInterfaceLabel!
    @IBOutlet var player_2_set_2_score_label: WKInterfaceLabel!
    @IBOutlet var player_1_set_3_score_label: WKInterfaceLabel!
    @IBOutlet var player_2_set_3_score_label: WKInterfaceLabel!
    
    /* Game Scores */
    @IBOutlet var player_1_game_score_label: WKInterfaceLabel!
    @IBOutlet var player_2_game_score_label: WKInterfaceLabel!
    
    /* Player Serving Images */
    @IBOutlet var player_1_serving_image: WKInterfaceImage!
    @IBOutlet var player_2_serving_image: WKInterfaceImage!
    
    /* Increment Scores */
    @IBAction func incrementPlayerOneScore() {
        if(player_1_points_won_this_game >= 3 && player_1_points_won_this_game - player_2_points_won_this_game >= 1) {    //Game: Player 1
            player_1_game_score_label.setText("0")
            player_2_game_score_label.setText("0")
            player_1_points_won_this_game = 0
            player_2_points_won_this_game = 0
            
            print("GAME P1")
            print(player_1_points_won_this_game)
            print(player_2_points_won_this_game)
            
            return
        } else if(player_1_points_won_this_game == 0) {
            player_1_game_score_label.setText("15")
        } else if(player_1_points_won_this_game == 1) {
            player_1_game_score_label.setText("30")
        } else if(player_1_points_won_this_game == 2) {
            player_1_game_score_label.setText("40")
        } else if(player_2_points_won_this_game - player_1_points_won_this_game == 0) {
            player_1_game_score_label.setText("A")  //Won the deuce point
        } else if(player_2_points_won_this_game - player_1_points_won_this_game == 1) {
            player_2_game_score_label.setText("40") //Won the point on opponent's ad
        }
            
        player_1_points_won_this_game += 1
        
        print(player_1_points_won_this_game)
        print(player_2_points_won_this_game)
    }
    
    @IBAction func incrementPlayerTwoScore() {
        if(player_2_points_won_this_game >= 3 && player_2_points_won_this_game - player_1_points_won_this_game >= 1) {    //Game: Player 2
            player_1_game_score_label.setText("0")
            player_2_game_score_label.setText("0")
            player_1_points_won_this_game = 0
            player_2_points_won_this_game = 0
            
            print("GAME P2")
            print(player_1_points_won_this_game)
            print(player_2_points_won_this_game)
            
            return
        } else if(player_2_points_won_this_game == 0) {
            player_2_game_score_label.setText("15")
        } else if(player_2_points_won_this_game == 1) {
            player_2_game_score_label.setText("30")
        } else if(player_2_points_won_this_game == 2) {
            player_2_game_score_label.setText("40")
        } else if(player_1_points_won_this_game - player_2_points_won_this_game == 0) {
            player_2_game_score_label.setText("A")  //Won the deuce point
        } else if(player_1_points_won_this_game - player_2_points_won_this_game == 1) {
            player_1_game_score_label.setText("40") //Won the point on opponent's ad
        }
        
        player_2_points_won_this_game += 1
        
        print(player_1_points_won_this_game)
        print(player_2_points_won_this_game)
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
