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
    
    var set_winners: [Int] = [-1, -1, -1]   // Indices can be 1 or 2
    
    //Outlets
    /* Reset/Undo Group */
    @IBOutlet var reset_button_outlet: WKInterfaceButton!
    @IBOutlet var home_button_outlet: WKInterfaceButton!
    
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
    
    /* Increment Scores Labels */
    @IBOutlet var increment_player_one_score_outlet: WKInterfaceButton!
    @IBOutlet var increment_player_two_score_outlet: WKInterfaceButton!
    
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
                
                // Announce "Game: P1"
                announcement_label.setHidden(false)
                announcement_label.setText("Game: P1")
                preventButtonSelection()
                delayAnnouncement()
                
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
                        
                        set_winners[0] = 1
                        
                        // Announce "Set 1: P1"
                        announcement_label.setHidden(false)
                        announcement_label.setText("Set 1: P1")
                        preventButtonSelection()
                        delayAnnouncement()
                        
                        current_set += 1
                    } else if(player_1_set_1_score == 7 && player_2_set_1_score == 5) {  //7-5
                        print("P1 Set 1 with 7")
                        
                        set_winners[0] = 1
                        
                        // Announce "Set 1: P1"
                        announcement_label.setHidden(false)
                        announcement_label.setText("Set 1: P1")
                        preventButtonSelection()
                        delayAnnouncement()
                        
                        current_set += 1
                    } else if(player_1_set_1_score == 6 && player_2_set_1_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                    }
                } else if(current_set == 2) {
                    player_1_set_2_score += 1
                    player_1_set_2_score_label.setText(String(player_1_set_2_score))
                    
                    // Player 1 won Set 2
                    if(player_1_set_2_score == 6 && player_2_set_2_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        
                        set_winners[1] = 1
                        
                        if(set_winners[0] == set_winners[1]) {  //Player 1 wins the match
                            announcement_label.setHidden(false)
                            announcement_label.setText("Game, Set, Match")
                            preventButtonSelection()
                            delayGameSetMatch()
                            return
                        }
                        
                        // Announce "Set 2: P1"
                        announcement_label.setHidden(false)
                        announcement_label.setText("Set 2: P1")
                        preventButtonSelection()
                        delayAnnouncement()
                        
                        current_set += 1
                    } else if(player_1_set_2_score == 7 && player_2_set_2_score == 5) { //7-5
                       
                        set_winners[1] = 1
                        
                        if(set_winners[0] == set_winners[1]) {  //Player 1 wins the match
                            announcement_label.setHidden(false)
                            announcement_label.setText("Game, Set, Match")
                            preventButtonSelection()
                            delayGameSetMatch()
                            return
                        }
                        
                        // Announce "Set 2: P1"
                        announcement_label.setHidden(false)
                        announcement_label.setText("Set 2: P1")
                        preventButtonSelection()
                        delayAnnouncement()
                        
                        current_set += 1
                    } else if(player_1_set_2_score == 6 && player_2_set_2_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                    }
                } else {    //Set 3
                    player_1_set_3_score += 1
                    player_1_set_3_score_label.setText(String(player_1_set_3_score))
                    
                    // Player 1 wins
                    if(player_1_set_3_score == 6 && player_2_set_3_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        set_winners[2] = 1
                        
                        // Announce "Set 3: P1"
                        announcement_label.setHidden(false)
                        announcement_label.setText("Game, Set, Match")
                        preventButtonSelection()
                        delayGameSetMatch()
                        return
                        
//                        current_set += 1
                    } else if(player_1_set_3_score == 7 && player_2_set_3_score == 5) {  //7-5
                        set_winners[2] = 1
                        
                        // Announce "Set 3: P1"
                        announcement_label.setHidden(false)
                        announcement_label.setText("Game, Set, Match")
                        preventButtonSelection()
                        delayGameSetMatch()
                        return
                        
//                        current_set += 1
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
                player_1_game_score_label.setText("0")
                player_2_game_score_label.setText("0")
                
                player_1_points_won_this_game = 0
                player_2_points_won_this_game = 0
                
                //Update set score corresponding to set
                if(current_set == 1) {
                    
                    player_1_set_1_score += 1
                    player_1_set_1_score_label.setText(String(player_1_set_1_score))
                    
                    set_winners[0] = 1
                    
                    // Announce "Set 1: P1"
                    announcement_label.setHidden(false)
                    announcement_label.setText("Set 1: P1")
                    preventButtonSelection()
                    delayAnnouncement()
                } else if (current_set == 2) {
                    player_1_set_2_score += 1
                    player_1_set_2_score_label.setText(String(player_1_set_2_score))
                    
                    set_winners[1] = 1
                    
                    if(set_winners[0] == set_winners[1]) {  //Player 1 wins
                        announcement_label.setHidden(false)
                        announcement_label.setText("Game, Set, Match")
                        preventButtonSelection()
                        delayGameSetMatch()
                        return
                    }
                    
                    // Announce "Set 2: P1"
                    announcement_label.setHidden(false)
                    announcement_label.setText("Set 2: P1")
                    preventButtonSelection()
                    delayAnnouncement()
                } else {    //Set 3
                    player_1_set_3_score += 1
                    player_1_set_3_score_label.setText(String(player_1_set_3_score))
                    
                    set_winners[2] = 1
                    
                    // Announce "Set 3: P1"
                    announcement_label.setHidden(false)
                    announcement_label.setText("Game, Set, Match")
                    preventButtonSelection()
                    delayGameSetMatch()
                }
                
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
                
                // Announce "Game: P2"
                announcement_label.setHidden(false)
                announcement_label.setText("Game: P2")
                preventButtonSelection()
                delayAnnouncement()
                
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
                        
                        set_winners[0] = 2
                        
                        // Announce "Set 1: P2"
                        announcement_label.setHidden(false)
                        announcement_label.setText("Set 1: P2")
                        preventButtonSelection()
                        delayAnnouncement()
                        
                        current_set += 1
                    } else if(player_2_set_1_score == 7 && player_1_set_1_score == 5) {  //7-5
                        print("P2 Set 1 with 6")
                        
                        set_winners[0] = 2
                        
                        // Announce "Set 1: P2"
                        announcement_label.setHidden(false)
                        announcement_label.setText("Set 1: P2")
                        preventButtonSelection()
                        delayAnnouncement()
                        
                        current_set += 1
                    } else if(player_1_set_1_score == 6 && player_2_set_1_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                    }
                } else if(current_set == 2) {
                    player_2_set_2_score += 1
                    player_2_set_2_score_label.setText(String(player_2_set_2_score))
                    
                    // Player 2 won Set 2
                    if(player_2_set_2_score == 6 && player_1_set_2_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        
                        set_winners[1] = 2
                        
                        if(set_winners[0] == set_winners[1]) {  //Player 2 wins
                            announcement_label.setHidden(false)
                            announcement_label.setText("Game, Set, Match")
                            preventButtonSelection()
                            delayGameSetMatch()
                            return
                        }
                        
                        // Announce "Set 2: P2"
                        announcement_label.setHidden(false)
                        announcement_label.setText("Set 2: P2")
                        preventButtonSelection()
                        delayAnnouncement()
                        
                        current_set += 1
                    } else if(player_2_set_2_score == 7 && player_1_set_2_score == 5) { //7-5
                        
                        set_winners[1] = 2
                        
                        if(set_winners[0] == set_winners[1]) {  //Player 2 wins
                            announcement_label.setHidden(false)
                            announcement_label.setText("Game, Set, Match")
                            preventButtonSelection()
                            delayGameSetMatch()
                            return
                        }
                        
                        // Announce "Set 2: P2"
                        announcement_label.setHidden(false)
                        announcement_label.setText("Set 2: P2")
                        preventButtonSelection()
                        delayAnnouncement()
                        
                        current_set += 1
                    } else if(player_1_set_2_score == 6 && player_2_set_2_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                    }
                    
                } else {    //Set 3
                    player_2_set_3_score += 1
                    player_2_set_3_score_label.setText(String(player_2_set_3_score))
                    
                    // Player 2 won Set 3
                    if(player_2_set_3_score == 6 && player_1_set_3_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        
                        set_winners[2] = 2
                        
                        // Announce "Set 3: P2"
                        announcement_label.setHidden(false)
                        announcement_label.setText("Game, Set, Match")
                        preventButtonSelection()
                        delayGameSetMatch()
                        
                        current_set += 1
                    } else if(player_2_set_3_score == 7 && player_1_set_3_score == 5) {  //7-5
                        
                        set_winners[2] = 2
                        
                        // Announce "Set 3: P2"
                        announcement_label.setHidden(false)
                        announcement_label.setText("Game, Set, Match")
                        preventButtonSelection()
                        delayGameSetMatch()
                        
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
                
                player_1_game_score_label.setText("0")
                player_2_game_score_label.setText("0")
                
                player_1_points_won_this_game = 0
                player_2_points_won_this_game = 0
                
                //Update set score corresponding to set
                if(current_set == 1) {
                    set_winners[0] = 2
                    
                    // Announce "Set 1: P2"
                    announcement_label.setHidden(false)
                    announcement_label.setText("Set 1: P2")
                    preventButtonSelection()
                    delayAnnouncement()
                    
                    player_2_set_1_score += 1
                    player_2_set_1_score_label.setText(String(player_1_set_1_score))
                } else if(current_set == 2) {
                    set_winners[1] = 2
                    
                    if(set_winners[0] == set_winners[1]) {  //Player 2 wins
                        announcement_label.setHidden(false)
                        announcement_label.setText("Game, Set, Match")
                        preventButtonSelection()
                        delayGameSetMatch()
                        return
                    }
                    
                    // Announce "Set 2: P2"
                    announcement_label.setHidden(false)
                    announcement_label.setText("Set 2: P2")
                    preventButtonSelection()
                    delayAnnouncement()
                    
                    player_2_set_2_score += 1
                    player_2_set_2_score_label.setText(String(player_2_set_2_score))
                } else {    //Set 3
                    set_winners[2] = 2
                    
                    // Announce "Set 3: P2"
                    announcement_label.setHidden(false)
                    announcement_label.setText("Game, Set, Match")
                    preventButtonSelection()
                    delayGameSetMatch()
                    
                    player_2_set_3_score += 1
                    player_2_set_3_score_label.setText(String(player_2_set_3_score))
                }
                
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
        
        current_set = 1
        
        //Allow the player to use increment buttons if they hit reset at the end of match
        self.increment_player_one_score_outlet.setEnabled(true)
        self.increment_player_two_score_outlet.setEnabled(true)
    }
    
    func delayAnnouncement() {
        // Delay the dismissal by 2 seconds
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.announcement_label.setHidden(true)
            
            // Allow selection of buttons after the delay
            self.reset_button_outlet.setEnabled(true)
            self.home_button_outlet.setEnabled(true)
            self.increment_player_one_score_outlet.setEnabled(true)
            self.increment_player_two_score_outlet.setEnabled(true)
        }
    }
    
    func delayGameSetMatch() {
        // Delay the dismissal by 3 seconds
        let when = DispatchTime.now() + 3 // change 3 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Allow selection of reset and home buttons after the delay
            self.reset_button_outlet.setEnabled(true)
            self.home_button_outlet.setEnabled(true)
        }
        
        self.increment_player_one_score_outlet.setEnabled(false)
        self.increment_player_two_score_outlet.setEnabled(false)
    }
    
    func preventButtonSelection() {
        // Prevent selection of buttons during the delay
        self.reset_button_outlet.setEnabled(false)
        self.home_button_outlet.setEnabled(false)
        self.increment_player_one_score_outlet.setEnabled(false)
        self.increment_player_two_score_outlet.setEnabled(false)
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
