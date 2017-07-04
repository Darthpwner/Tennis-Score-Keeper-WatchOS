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

    // TODO?
    @IBOutlet var announcement_label: WKInterfaceLabel!
    
    // Current set [1, 3]
    var current_set = 1
    
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
            
            
            // Update set score
            if(current_set == 1) {
                player_1_set_1_score += 1
                player_1_set_1_score_label.setText(String(player_1_set_1_score))

                // Player 1 won Set 1
                if(player_1_set_1_score == 6 && player_2_set_1_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                    print("P1 Set 1 with 6")

                    current_set += 1
                } else if(player_1_set_1_score == 7 && (player_2_set_1_score == 5 || player_2_set_1_score == 6)) {  //7-5, 7-6
                    print("P1 Set 1 with 7")
                    
                    current_set += 1
                }
            } else if(current_set == 2) {
                player_1_set_2_score += 1
                player_1_set_2_score_label.setText(String(player_1_set_2_score))

                // Player 1 won Set 2
                if(player_1_set_2_score == 6 && player_2_set_2_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                    current_set += 1
                } else if(player_1_set_2_score == 7 && (player_2_set_2_score == 5 || player_2_set_2_score == 6)) { //7-5, 7-6
                    current_set += 1
                }
            } else {
                player_1_set_3_score += 1
                player_1_set_3_score_label.setText(String(player_1_set_3_score))
                
                // Player 1 won Set 3
                if(player_1_set_3_score == 6 && player_2_set_3_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                    current_set += 1
                    
                    announcement_label.setText("Player 1 wins")
                    announcement_label.setHidden(false)
                } else if(player_1_set_3_score == 7 && (player_2_set_3_score == 5 || player_2_set_3_score == 6)) {  //7-5, 7-6
                    current_set += 1
                    
                    announcement_label.setText("Player 1 wins")
                    announcement_label.setHidden(false)
                }
            }
            
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

            // Update set score
            if(current_set == 1) {
                player_2_set_1_score += 1
                player_2_set_1_score_label.setText(String(player_2_set_1_score))
                
                // Player 2 won Set 1
                if(player_2_set_1_score == 6 && player_1_set_1_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                    print("P2 Set 1 with 6")
                    
                    current_set += 1
                } else if(player_2_set_1_score == 7 && (player_1_set_1_score == 5 || player_1_set_1_score == 6)) {  //7-5, 7-6
                    print("P2 Set 1 with 6")
                    
                    current_set += 1
                }
            } else if(current_set == 2) {
                player_2_set_2_score += 1
                player_2_set_2_score_label.setText(String(player_2_set_2_score))
                
                // Player 2 won Set 2
                if(player_2_set_2_score == 6 && player_1_set_2_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                    current_set += 1
                } else if(player_2_set_2_score == 7 && (player_1_set_2_score == 5 || player_1_set_2_score == 6)) { //7-5, 7-6
                    current_set += 1
                }
            } else {
                player_2_set_3_score += 1
                player_2_set_3_score_label.setText(String(player_2_set_3_score))
                
                // Player 2 won Set 3
                if(player_2_set_3_score == 6 && player_1_set_3_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                    current_set += 1
                    
                    announcement_label.setText("Player 2 wins")
                    announcement_label.setHidden(false)
                } else if(player_2_set_3_score == 7 && (player_1_set_3_score == 5 || player_1_set_3_score == 6)) {  //7-5, 7-6
                    current_set += 1
                    
                    announcement_label.setText("Player 2 wins")
                    announcement_label.setHidden(false)
                }
            }
                
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
