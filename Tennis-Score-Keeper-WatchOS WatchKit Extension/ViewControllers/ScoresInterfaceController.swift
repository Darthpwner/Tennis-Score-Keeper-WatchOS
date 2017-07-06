//
//  ScoresInterfaceController.swift
//  Tennis-Score-Keeper-WatchOS
//
//  Created by Matthew Allen Lin on 7/3/17.
//  Copyright © 2017 Matthew Allen Lin Software. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation //For speech output

class ScoresInterfaceController: WKInterfaceController {

    //Speech
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    // Current set [1, 3]
    var current_set = 1

    var is_tiebreak = false
    
    // Player serving [0, 1] where 0 is P1 and 1 is P2
    var player_serving = 0
    
    // Tracks which player started serving in the tiebreak to handle the start of the next set
    var player_serving_to_start_tiebreak = -1
    
    //TODO
    var is_10_point_tiebreak = false
    
    // Game score values
    var player_1_points_won_this_game = 0
    var player_2_points_won_this_game = 0
    
    //For score announcements
    var player_1_game_score_string = "Love"
    var player_2_game_score_string = "Love"
    
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
                
                changeServer()
                
                // Update set score
                if(current_set == 1) {
                    player_1_set_1_score += 1
                    player_1_set_1_score_label.setText(String(player_1_set_1_score))
                    
                    // Player 1 won Set 1
                    if(player_1_set_1_score == 6 && player_2_set_1_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        
                        set_winners[0] = 1
                        
                        // Announce "Set 1: P1"
                        setAnnouncement(player: "P1", set_number: "1")
                        
                        current_set += 1
                    } else if(player_1_set_1_score == 7 && player_2_set_1_score == 5) {  //7-5
                        print("P1 Set 1 with 7")
                        
                        set_winners[0] = 1
                        
                        // Announce "Set 1: P1"
                        setAnnouncement(player: "P1", set_number: "1")
                        
                        current_set += 1
                    } else if(player_1_set_1_score == 6 && player_2_set_1_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                        player_serving_to_start_tiebreak = player_serving
                        
                        // Announce "Game: P1"
                        gameAnnouncement(player: "P1")
                        
                        // Announce set score
                        setScoreAnnouncement(current_set: current_set, player_1_set_score: player_1_set_1_score, player_2_set_score: player_2_set_1_score)
                    } else {    //Normal Game announcement
                        // Announce "Game: P1"
                        gameAnnouncement(player: "P1")
                        
                        // Announce set score
                        setScoreAnnouncement(current_set: current_set, player_1_set_score: player_1_set_1_score, player_2_set_score: player_2_set_1_score)
                    }
                } else if(current_set == 2) {
                    player_1_set_2_score += 1
                    player_1_set_2_score_label.setText(String(player_1_set_2_score))
                    
                    // Player 1 won Set 2
                    if(player_1_set_2_score == 6 && player_2_set_2_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        
                        set_winners[1] = 1
                        
                        if(set_winners[0] == set_winners[1]) {  //Player 1 wins the match
                            gameSetMatchAnnouncement(player: "P1")
                        } else {
                            // Announce "Set 2: P1"
                            setAnnouncement(player: "P1", set_number: "2")
                        }
                        
                        current_set += 1
                    } else if(player_1_set_2_score == 7 && player_2_set_2_score == 5) { //7-5
                       
                        set_winners[1] = 1
                        
                        if(set_winners[0] == set_winners[1]) {  //Player 1 wins the match
                            gameSetMatchAnnouncement(player: "P1")
                        } else {
                            // Announce "Set 2: P1"
                            setAnnouncement(player: "P1", set_number: "2")
                        }
                        
                        current_set += 1
                    } else if(player_1_set_2_score == 6 && player_2_set_2_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                        player_serving_to_start_tiebreak = player_serving
                        
                        // Announce "Game: P1"
                        gameAnnouncement(player: "P1")
                        
                        // Announce set score
                        setScoreAnnouncement(current_set: current_set, player_1_set_score: player_1_set_2_score, player_2_set_score: player_2_set_2_score)
                    } else {    //Normal Game announcement
                        // Announce "Game: P1"
                        gameAnnouncement(player: "P1")
                        
                        // Announce set score
                        setScoreAnnouncement(current_set: current_set, player_1_set_score: player_1_set_2_score, player_2_set_score: player_2_set_2_score)
                    }
                } else {    //Set 3
                    player_1_set_3_score += 1
                    player_1_set_3_score_label.setText(String(player_1_set_3_score))
                    
                    // Player 1 wins
                    if(player_1_set_3_score == 6 && player_2_set_3_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        set_winners[2] = 1
                        
                        gameSetMatchAnnouncement(player: "P1")
                        
                        current_set += 1
                    } else if(player_1_set_3_score == 7 && player_2_set_3_score == 5) {  //7-5
                        set_winners[2] = 1
                        
                        gameSetMatchAnnouncement(player: "P1")
                        
                        current_set += 1
                    } else if(player_1_set_3_score == 6 && player_2_set_3_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                        player_serving_to_start_tiebreak = player_serving
                        
                        // Announce "Game: P1"
                        gameAnnouncement(player: "P1")
                        
                        // Announce set score
                        setScoreAnnouncement(current_set: current_set, player_1_set_score: player_1_set_3_score, player_2_set_score: player_2_set_3_score)
                    } else {    //Normal Game announcement
                        // Announce "Game: P1"
                        gameAnnouncement(player: "P1")
                        
                        // Announce set score
                        setScoreAnnouncement(current_set: current_set, player_1_set_score: player_1_set_3_score, player_2_set_score: player_2_set_3_score)
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
            
            //Announce game score
            obtainGameScore()
            
            if(player_serving == 0) {
                gameScoreAnnouncement(server_score: player_1_game_score_string, receiver_score: player_2_game_score_string)
            } else {
                gameScoreAnnouncement(server_score: player_2_game_score_string, receiver_score: player_1_game_score_string)
            }
        } else {    //Tiebreaker
            player_1_game_score_label.setText(String(player_1_points_won_this_game))
            
            if((player_1_points_won_this_game + player_2_points_won_this_game) % 2 == 1) {
                changeServer()
            }
            
            if(player_1_points_won_this_game >= 7 && player_1_points_won_this_game - player_2_points_won_this_game >= 2) {
                
                player_1_game_score_label.setText("0")
                player_2_game_score_label.setText("0")
                
                player_1_points_won_this_game = 0
                player_2_points_won_this_game = 0
                
                // Changes server to the player who received first to the start the tiebreaker
                if(player_serving_to_start_tiebreak == player_serving) {
                    changeServer()
                }
                
                //Update set score corresponding to set
                if(current_set == 1) {
                    
                    player_1_set_1_score += 1
                    player_1_set_1_score_label.setText(String(player_1_set_1_score))
                    
                    set_winners[0] = 1
                    
                    // Announce "Set 1: P1"
                    setAnnouncement(player: "P1", set_number: "1")
                } else if (current_set == 2) {
                    
                    player_1_set_2_score += 1
                    player_1_set_2_score_label.setText(String(player_1_set_2_score))
                    
                    set_winners[1] = 1
                    
                    if(set_winners[0] == set_winners[1]) {  //Player 1 wins
                        gameSetMatchAnnouncement(player: "P1")
                    } else {
                        // Announce "Set 2: P1"
                        setAnnouncement(player: "P1", set_number: "2")
                    }
                } else {    //Set 3
                    player_1_set_3_score += 1
                    player_1_set_3_score_label.setText(String(player_1_set_3_score))
                    
                    set_winners[2] = 1
                    
                    gameSetMatchAnnouncement(player: "P1")
                }
                
                current_set += 1
                is_tiebreak = false
            } else {    // Still in the the tiebreak so call the score
                //Announce game score
                obtainGameScore()
                
                if(player_serving == 0) {
                    gameScoreAnnouncement(server_score: String(player_1_points_won_this_game), receiver_score: String(player_2_points_won_this_game))
                } else {
                    gameScoreAnnouncement(server_score: String(player_2_points_won_this_game), receiver_score: String(player_1_points_won_this_game))
                }
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
                
                changeServer()
                
                // Update set score
                if(current_set == 1) {
                    player_2_set_1_score += 1
                    player_2_set_1_score_label.setText(String(player_2_set_1_score))
                    
                    // Player 2 won Set 1
                    if(player_2_set_1_score == 6 && player_1_set_1_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        
                        set_winners[0] = 2
                        
                        // Announce "Set 1: P2"
                        setAnnouncement(player: "P2", set_number: "1")
                        
                        current_set += 1
                    } else if(player_2_set_1_score == 7 && player_1_set_1_score == 5) {  //7-5
                        
                        set_winners[0] = 2
                        
                        // Announce "Set 1: P2"
                        setAnnouncement(player: "P2", set_number: "1")
                        
                        current_set += 1
                    } else if(player_1_set_1_score == 6 && player_2_set_1_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                        player_serving_to_start_tiebreak = player_serving
                        
                        // Announce "Game: P2"
                        gameAnnouncement(player: "P2")
                        
                        // Announce set score
                        setScoreAnnouncement(current_set: current_set, player_1_set_score: player_1_set_1_score, player_2_set_score: player_2_set_1_score)
                    } else {    //Normal Game Announcement
                        // Announce "Game: P2"
                        gameAnnouncement(player: "P2")
                        
                        // Announce set score
                        setScoreAnnouncement(current_set: current_set, player_1_set_score: player_1_set_1_score, player_2_set_score: player_2_set_1_score)
                    }
                } else if(current_set == 2) {
                    player_2_set_2_score += 1
                    player_2_set_2_score_label.setText(String(player_2_set_2_score))
                    
                    // Player 2 won Set 2
                    if(player_2_set_2_score == 6 && player_1_set_2_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        
                        set_winners[1] = 2
                        
                        if(set_winners[0] == set_winners[1]) {  //Player 2 wins
                            gameSetMatchAnnouncement(player: "P2")
                        } else {
                            // Announce "Set 2: P2"
                            setAnnouncement(player: "P2", set_number: "2")
                        }
                        
                        current_set += 1
                    } else if(player_2_set_2_score == 7 && player_1_set_2_score == 5) { //7-5
                        
                        set_winners[1] = 2
                        
                        if(set_winners[0] == set_winners[1]) {  //Player 2 wins
                            gameSetMatchAnnouncement(player: "P2")
                        } else {
                            // Announce "Set 2: P2"
                            setAnnouncement(player: "P2", set_number: "2")
                        }
                        
                        current_set += 1
                    } else if(player_1_set_2_score == 6 && player_2_set_2_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                        player_serving_to_start_tiebreak = player_serving
                        
                        // Announce "Game: P2"
                        gameAnnouncement(player: "P2")
                        
                        // Announce set score
                        setScoreAnnouncement(current_set: current_set, player_1_set_score: player_1_set_2_score, player_2_set_score: player_2_set_2_score)
                    } else {    //Normal Game announcement
                        // Announce "Game: P2"
                        gameAnnouncement(player: "P2")
                        
                        // Announce set score
                        setScoreAnnouncement(current_set: current_set, player_1_set_score: player_1_set_2_score, player_2_set_score: player_2_set_2_score)
                    }
                    
                } else {    //Set 3
                    player_2_set_3_score += 1
                    player_2_set_3_score_label.setText(String(player_2_set_3_score))
                    
                    // Player 2 won Set 3
                    if(player_2_set_3_score == 6 && player_1_set_3_score <= 4) {    //6-0, 6-1, 6-2, 6-3, 6-4
                        
                        set_winners[2] = 2
                        
                        gameSetMatchAnnouncement(player: "P2")
                        
                        current_set += 1
                    } else if(player_2_set_3_score == 7 && player_1_set_3_score == 5) {  //7-5
                        
                        set_winners[2] = 2
                        
                        gameSetMatchAnnouncement(player: "P2")
                        
                        current_set += 1
                    } else if(player_1_set_3_score == 6 && player_2_set_3_score == 6) { //Enter tiebreak
                        is_tiebreak = true
                        player_serving_to_start_tiebreak = player_serving
                        
                        // Announce "Game: P2"
                        gameAnnouncement(player: "P2")
                        
                        // Announce set score
                        setScoreAnnouncement(current_set: current_set, player_1_set_score: player_1_set_3_score, player_2_set_score: player_2_set_3_score)
                    } else {    //Normal Game announcement
                        // Announce "Game: P2"
                        gameAnnouncement(player: "P2")
                        
                        // Announce set score
                        setScoreAnnouncement(current_set: current_set, player_1_set_score: player_1_set_3_score, player_2_set_score: player_2_set_3_score)
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
            
            //Announce game score
            obtainGameScore()
            
            if(player_serving == 0) {
                gameScoreAnnouncement(server_score: player_1_game_score_string, receiver_score: player_2_game_score_string)
            } else {
                gameScoreAnnouncement(server_score: player_2_game_score_string, receiver_score: player_1_game_score_string)
            }
        } else {    //Tiebreaker
            player_2_game_score_label.setText(String(player_2_points_won_this_game))
            
            if((player_1_points_won_this_game + player_2_points_won_this_game) % 2 == 1) {
                changeServer()
            }
            
            if(player_2_points_won_this_game >= 7 && player_2_points_won_this_game - player_1_points_won_this_game >= 2) {
                
                player_1_game_score_label.setText("0")
                player_2_game_score_label.setText("0")
                
                player_1_points_won_this_game = 0
                player_2_points_won_this_game = 0
                
                // Changes server to the player who received first to the start the tiebreaker
                if(player_serving_to_start_tiebreak == player_serving) {
                    changeServer()
                }
                
                //Update set score corresponding to set
                if(current_set == 1) {
                    
                    player_2_set_1_score += 1
                    player_2_set_1_score_label.setText(String(player_2_set_1_score))
                    
                    set_winners[0] = 2
                    
                    // Announce "Set 1: P2"
                    setAnnouncement(player: "P2", set_number: "1")
                } else if(current_set == 2) {
                    
                    player_2_set_2_score += 1
                    player_2_set_2_score_label.setText(String(player_2_set_2_score))
                    
                    set_winners[1] = 2
                    
                    if(set_winners[0] == set_winners[1]) {  //Player 2 wins
                        gameSetMatchAnnouncement(player: "P2")
                    } else {
                        // Announce "Set 2: P2"
                        setAnnouncement(player: "P2", set_number: "2")
                    }
                } else {    //Set 3

                    player_2_set_3_score += 1
                    player_2_set_3_score_label.setText(String(player_2_set_3_score))
                    
                    set_winners[2] = 2
                    
                    // Announce "Set 3: P2"
                    setAnnouncement(player: "P2", set_number: "3")
                }
                
                current_set += 1
                is_tiebreak = false
            } else {    // Still in the the tiebreak so call the score
                //Announce game score
                
                if(player_serving == 0) {
                    gameScoreAnnouncement(server_score: String(player_1_points_won_this_game), receiver_score: String(player_2_points_won_this_game))
                } else {
                    gameScoreAnnouncement(server_score: String(player_2_points_won_this_game), receiver_score: String(player_1_points_won_this_game))
                }
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
        
        player_serving = 0
        
        player_serving_to_start_tiebreak = -1
        
        player_1_game_score_string = "Love"
        player_2_game_score_string = "Love"
        
        player_1_label.setTextColor(UIColor.white)
        player_2_label.setTextColor(UIColor.white)
        
        if(player_serving == 0) {   //P1 (left side) always starts serving
            player_1_serving_image.setHidden(false)
            player_2_serving_image.setHidden(true)
        }
        
        self.announcement_label.setHidden(true)
        
        //Allow the player to use increment buttons if they hit reset at the end of match
        self.increment_player_one_score_outlet.setEnabled(true)
        self.increment_player_two_score_outlet.setEnabled(true)
    }
    
    /* Delay a normal announcement */
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
    
    /* Delay for the Game, Set, Match announcement */
    func delayGameSetMatch() {
        // Delay the dismissal by 3 seconds
        let when = DispatchTime.now() + 3 // change 3 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Allow selection of reset and home buttons after the delay
            self.reset_button_outlet.setEnabled(true)
            self.home_button_outlet.setEnabled(true)
        }
    }
    
    /* Prevents selecting any of the buttons */
    func preventButtonSelection() {
        // Prevent selection of buttons during the delay
        self.reset_button_outlet.setEnabled(false)
        self.home_button_outlet.setEnabled(false)
        self.increment_player_one_score_outlet.setEnabled(false)
        self.increment_player_two_score_outlet.setEnabled(false)
    }
    
    /* Alternate server each game */
    func changeServer() {
        if(player_serving == 0) {   //P2 (right side) to serve
            player_serving = 1
            
            player_1_serving_image.setHidden(true)
            player_2_serving_image.setHidden(false)
        } else {    //P1 (left side) to serve
            player_serving = 0
            
            player_1_serving_image.setHidden(false)
            player_2_serving_image.setHidden(true)
        }
    }
    
    /* Calculate normal game scores (non-tiebreaker games) */
    func obtainGameScore() {
        //Basic P1 scores
        if(player_1_points_won_this_game == 0) {
            player_1_game_score_string = "Love"
        } else if(player_1_points_won_this_game == 1) {
            player_1_game_score_string = "15"
        } else if(player_1_points_won_this_game == 2) {
            player_1_game_score_string = "30"
        } else if(player_1_points_won_this_game == 3 || player_1_points_won_this_game == player_2_points_won_this_game) {
            player_1_game_score_string = "40"
        } else if(player_1_points_won_this_game - player_2_points_won_this_game == 1) {
            player_1_game_score_string = "AD"
        }
        
        //Basic P2 scores
        if(player_2_points_won_this_game == 0) {
            player_2_game_score_string = "Love"
        } else if(player_2_points_won_this_game == 1) {
            player_2_game_score_string = "15"
        } else if(player_2_points_won_this_game == 2) {
            player_2_game_score_string = "30"
        } else if(player_2_points_won_this_game == 3 || player_1_points_won_this_game == player_2_points_won_this_game) {
            player_2_game_score_string = "40"
        } else if(player_2_points_won_this_game - player_1_points_won_this_game == 1) {
            player_2_game_score_string = "AD"
        }
    }
    
    /* Score announcements */
    // Call the game score
    func gameScoreAnnouncement(server_score: String, receiver_score: String) {
        if(!is_tiebreak) {
            if(server_score == "40" && receiver_score == "40") {
                myUtterance = AVSpeechUtterance(string: "Deuce")
            } else if(server_score == "AD") {
                myUtterance = AVSpeechUtterance(string: "Ad In")
            } else if(receiver_score == "AD") {
                myUtterance = AVSpeechUtterance(string: "Ad Out")
            } else if(server_score == receiver_score) { //<Server score>-All
                myUtterance = AVSpeechUtterance(string: "\(server_score)-All")
            } else { // "<Server score>-<Receiver score>"
                myUtterance = AVSpeechUtterance(string: "\(server_score) \(receiver_score)")
            }
        }  else {   //Announce tiebreak score
            if(server_score == receiver_score) { //<Server score>-All
                myUtterance = AVSpeechUtterance(string: "\(server_score)-All")
            } else { // "<Server score>-<Receiver score>"
                myUtterance = AVSpeechUtterance(string: "\(server_score) \(receiver_score)")
            }
        }
        
        synth.speak(myUtterance)
        
        preventButtonSelection()
        delayAnnouncement()
    }
    
    func setScoreAnnouncement(current_set: Int, player_1_set_score: Int, player_2_set_score: Int) {
        if(player_1_set_score == player_2_set_score) {
            myUtterance = AVSpeechUtterance(string: "\(player_1_set_score)-All. Set \(current_set)")
        } else if(player_1_set_score > player_2_set_score) {
            myUtterance = AVSpeechUtterance(string: "P1 leeds \(player_1_set_score) \(player_2_set_score). Set \(current_set)")
        } else {    //P2 leads P1 in this set
            myUtterance = AVSpeechUtterance(string: "P2 leeds \(player_2_set_score) \(player_1_set_score). Set \(current_set)")
        }
        
        synth.speak(myUtterance)
        
        preventButtonSelection()
        delayAnnouncement()
    }

    /* Umpire announcements */
    func gameAnnouncement(player: String) {
        announcement_label.setHidden(false)
        announcement_label.setText("Game: \(player)")
        
        myUtterance = AVSpeechUtterance(string: "Game: \(player)")
        synth.speak(myUtterance)
        
        preventButtonSelection()
        delayAnnouncement()
    }
    
    func setAnnouncement(player: String, set_number: String) {
        announcement_label.setHidden(false)
        announcement_label.setText("Set \(set_number): \(player)")
        
        myUtterance = AVSpeechUtterance(string: "Set \(set_number): \(player)")
        synth.speak(myUtterance)
        
        preventButtonSelection()
        delayAnnouncement()
    }
    
    func gameSetMatchAnnouncement(player: String) {
        announcement_label.setHidden(false)
        announcement_label.setText("Game, Set, Match")
        
        myUtterance = AVSpeechUtterance(string: "Game, Set, Match: \(player)")
        synth.speak(myUtterance)
        
        // Change color for the winner
        if(player == "P1") {
            player_1_label.setTextColor(UIColor.green)
        } else {
            player_2_label.setTextColor(UIColor.green)
        }
        
        player_1_serving_image.setHidden(true)
        player_2_serving_image.setHidden(true)
        
        preventButtonSelection()
        delayGameSetMatch()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(player_serving == 0) {   //P1 (left side) always starts serving
            player_1_serving_image.setHidden(false)
            player_2_serving_image.setHidden(true)
        }
        
        //Set the Speech rate
        myUtterance.rate = 0.3
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
