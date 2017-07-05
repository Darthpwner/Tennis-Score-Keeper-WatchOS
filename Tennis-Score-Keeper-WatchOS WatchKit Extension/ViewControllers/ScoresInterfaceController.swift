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

    // Current set [1, 3]
    var current_set = 1

    var is_tiebreak = false
    
    //TODO
    var is_10_point_tiebreak = false
    
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
    
    /* Player Labels */
    @IBOutlet var player_1_label: WKInterfaceLabel!
    @IBOutlet var player_2_label: WKInterfaceLabel!
    
    @IBOutlet var announcement_label: WKInterfaceLabel!
    
    /* Increment Scores */
    @IBAction func incrementPlayerOneScore() {
        player_1_points_won_this_game += 1
        
        print("is_tiebreak: \(is_tiebreak)")
        
        if(!is_tiebreak) {
            if(player_1_points_won_this_game >= 4 && player_1_points_won_this_game - player_2_points_won_this_game >= 2) {    //Game: Player 1
                player_1_game_score_label.setText("0")
                player_2_game_score_label.setText("0")
                
                player_1_points_won_this_game = 0
                player_2_points_won_this_game = 0
                
                announcement_label.setHidden(false)
                announcement_label.setText("Game: P1")
                
                // Delay the dismissal by 5 seconds
                let when = DispatchTime.now() + 5 // change 5 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.announcement_label.setHidden(true)
                }
                
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
                    } else if(player_1_set_1_score == 7 && player_2_set_1_score == 5) {  //7-5
                        print("P1 Set 1 with 7")
                        
                        current_set += 1
                    } else if(player_1_set_1_score == 6 && player_2_set_1_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                    }
                } else if(current_set == 2) {
                    player_1_set_2_score += 1
                    player_1_set_2_score_label.setText(String(player_1_set_2_score))
                    
                    // Player 1 won Set 2
                    if(player_1_set_2_score == 6 && player_2_set_2_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        current_set += 1
                    } else if(player_1_set_2_score == 7 && player_2_set_2_score == 5) { //7-5
                        current_set += 1
                    } else if(player_1_set_2_score == 6 && player_2_set_2_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                    }
                } else {    //Set 3
                    player_1_set_3_score += 1
                    player_1_set_3_score_label.setText(String(player_1_set_3_score))
                    
                    // Player 1 won Set 3
                    if(player_1_set_3_score == 6 && player_2_set_3_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        current_set += 1
                    } else if(player_1_set_3_score == 7 && player_2_set_3_score == 5) {  //7-5
                        current_set += 1
                    } else if(player_1_set_3_score == 6 && player_2_set_3_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                    }
                }
                
                return
            } else if(player_1_points_won_this_game == 1) {
                player_1_game_score_label.setText("15")
            } else if(player_1_points_won_this_game == 2) {
                player_1_game_score_label.setText("30")
            } else if(player_1_points_won_this_game == 3) {
                player_1_game_score_label.setText("40")
            } else if(player_1_points_won_this_game - player_2_points_won_this_game == 0) {
                player_1_game_score_label.setText("40")  //Deuce
                player_2_game_score_label.setText("40")
            } else if(player_1_points_won_this_game - player_2_points_won_this_game == 1) {
                player_1_game_score_label.setText("AD") //Advantage: Player 1
            }
        } else {    //Tiebreaker
            player_1_game_score_label.setText(String(player_1_points_won_this_game))
            
            if(player_1_points_won_this_game >= 7 && player_1_points_won_this_game - player_2_points_won_this_game >= 2) {
                
                //Update set score corresponding to set
                if(current_set == 1) {
                    player_1_set_1_score += 1
                    player_1_set_1_score_label.setText(String(player_1_set_1_score))
                } else if (current_set == 2) {
                    player_1_set_2_score += 1
                    player_1_set_2_score_label.setText(String(player_1_set_2_score))
                } else {    //Set 3
                    player_1_set_3_score += 1
                    player_1_set_3_score_label.setText(String(player_1_set_3_score))
                }
                
                
                player_1_game_score_label.setText("0")
                player_2_game_score_label.setText("0")
                
                player_1_points_won_this_game = 0
                player_2_points_won_this_game = 0
                
                current_set += 1
                is_tiebreak = false
            }
        }
        
        print(player_1_points_won_this_game)
        print(player_2_points_won_this_game)
    }
    
    @IBAction func incrementPlayerTwoScore() {
        player_2_points_won_this_game += 1
        
        print("is_tiebreak: \(is_tiebreak)")
        
        if(!is_tiebreak) {
            if(player_2_points_won_this_game >= 4 && player_2_points_won_this_game - player_1_points_won_this_game >= 2) {    //Game: Player 2
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
                    } else if(player_2_set_1_score == 7 && player_1_set_1_score == 5) {  //7-5
                        print("P2 Set 1 with 6")
                        
                        current_set += 1
                    } else if(player_1_set_1_score == 6 && player_2_set_1_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                    }
                } else if(current_set == 2) {
                    player_2_set_2_score += 1
                    player_2_set_2_score_label.setText(String(player_2_set_2_score))
                    
                    // Player 2 won Set 2
                    if(player_2_set_2_score == 6 && player_1_set_2_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        current_set += 1
                    } else if(player_2_set_2_score == 7 && player_1_set_2_score == 5) { //7-5
                        current_set += 1
                    } else if(player_1_set_2_score == 6 && player_2_set_2_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                    }
                    
                } else {    //Set 3
                    player_2_set_3_score += 1
                    player_2_set_3_score_label.setText(String(player_2_set_3_score))
                    
                    // Player 2 won Set 3
                    if(player_2_set_3_score == 6 && player_1_set_3_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        current_set += 1
                    } else if(player_2_set_3_score == 7 && player_1_set_3_score == 5) {  //7-5
                        current_set += 1
                    } else if(player_1_set_3_score == 6 && player_2_set_3_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                    }
                }
                
                return
            } else if(player_2_points_won_this_game == 1) {
                player_2_game_score_label.setText("15")
            } else if(player_2_points_won_this_game == 2) {
                player_2_game_score_label.setText("30")
            } else if(player_2_points_won_this_game == 3) {
                player_2_game_score_label.setText("40")
            } else if(player_1_points_won_this_game - player_2_points_won_this_game == 0) {
                player_2_game_score_label.setText("40")  //Deuce
                player_1_game_score_label.setText("40")
            } else if(player_2_points_won_this_game - player_1_points_won_this_game == 1) {
                player_2_game_score_label.setText("AD") //Advantage: Player 2
            }
        } else {    //Tiebreaker
            player_2_game_score_label.setText(String(player_2_points_won_this_game))
            
            if(player_2_points_won_this_game >= 7 && player_2_points_won_this_game - player_1_points_won_this_game >= 2) {
                
                //Update set score corresponding to set
                if(current_set == 1) {
                    player_2_set_1_score += 1
                    player_2_set_1_score_label.setText(String(player_1_set_1_score))
                } else if(current_set == 2) {
                    player_2_set_2_score += 1
                    player_2_set_2_score_label.setText(String(player_2_set_2_score))
                } else {    //Set 3
                    player_2_set_3_score += 1
                    player_2_set_3_score_label.setText(String(player_2_set_3_score))
                }
                
                player_1_game_score_label.setText("0")
                player_2_game_score_label.setText("0")
                
                player_1_points_won_this_game = 0
                player_2_points_won_this_game = 0
                
                current_set += 1
                is_tiebreak = false
                
                
            }
        }
        
        print(player_1_points_won_this_game)
        print(player_2_points_won_this_game)
    }
    
    /* Reset */
    @IBAction func reset() {
        // Reset game score
        player_1_game_score_label.setText("0")
        player_2_game_score_label.setText("0")
        
        player_1_points_won_this_game = 0
        player_2_points_won_this_game = 0
        
        // Reset set scores 
        player_1_set_1_score = 0
        player_1_set_1_score_label.setText("0")
        
        player_2_set_1_score = 0
        player_2_set_1_score_label.setText("0")
        
        player_1_set_2_score = 0
        player_1_set_2_score_label.setText("0")
        
        player_2_set_2_score = 0
        player_2_set_2_score_label.setText("0")
        
        player_1_set_3_score = 0
        player_1_set_3_score_label.setText("0")
        
        player_2_set_3_score = 0
        player_2_set_3_score_label.setText("0")
    }
    
    
    /* Undo */
    
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
