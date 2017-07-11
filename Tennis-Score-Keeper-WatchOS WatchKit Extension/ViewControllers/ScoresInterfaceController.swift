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
import WatchConnectivity    //To have iOS app and Watch app talk to each other

class ScoresInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    // Starts a session to communicate with the iOS app
    var session: WCSession!
    
    // Passed in metadata from previous Interface Controllers
    //match_length: 0 means best of 1 set, 1 means best of 3 sets
    //ten_point_tiebreaker_format: 0 means Yes, 1 means No
    var metadata = Metadata(match_length_parameter: 1, ten_point_tiebreaker_format_parameter: 1)
    
    //Speech
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    // Current set [1, 3]
    var current_set = 1

    var is_tiebreak = false
    
    // Player who won the match [0, 1] where 0 is P1 and 1 is P2
    // Used to send data back to iOS app
    var player_won = -1
    
    // Player serving [0, 1] where 0 is P1 and 1 is P2
    var player_serving = 0
    
    // Tracks which player started serving in the tiebreak to handle the start of the next set
    var player_serving_to_start_tiebreak = -1
    
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
    @IBOutlet var set_1_dash_label: WKInterfaceLabel!
    @IBOutlet var player_2_set_1_score_label: WKInterfaceLabel!
    
    @IBOutlet var comma_between_set_1_and_2_label: WKInterfaceLabel!
    
    
    @IBOutlet var player_1_set_2_score_label: WKInterfaceLabel!
    @IBOutlet var set_2_dash_label: WKInterfaceLabel!
    @IBOutlet var player_2_set_2_score_label: WKInterfaceLabel!
    
    @IBOutlet var comma_between_set_2_and_3_label: WKInterfaceLabel!
    
    @IBOutlet var player_1_set_3_score_label: WKInterfaceLabel!
    @IBOutlet var set_3_dash_label: WKInterfaceLabel!
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
        
//        print("is_tiebreak: \(is_tiebreak)")
        
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
                        
                        current_set += 1
                        
                        set_winners[0] = 1
                        
                        if(metadata.match_length == 0) {    //If best of 1 set, Player 1 wins the match
                            gameSetMatchAnnouncement(player: "P1")
                        } else {
                            // Announce "Set 1: P1"
                            setAnnouncement(player: "P1", set_number: "1")
                            matchScoreAnnouncement()
                        }
                    } else if(player_1_set_1_score == 7 && player_2_set_1_score == 5) {  //7-5
                        
                        current_set += 1
                        
                        set_winners[0] = 1
                        
                        if(metadata.match_length == 0) {    //If best of 1 set, Player 1 wins the match
                            gameSetMatchAnnouncement(player: "P1")
                        } else {
                            // Announce "Set 1: P1"
                            setAnnouncement(player: "P1", set_number: "1")
                            matchScoreAnnouncement()
                        }
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
                        
                        current_set += 1
                        
                        set_winners[1] = 1
                        
                        if(set_winners[0] == set_winners[1]) {  //Player 1 wins the match
                            gameSetMatchAnnouncement(player: "P1")
                        } else {
                            // Announce "Set 2: P1"
                            setAnnouncement(player: "P1", set_number: "2")
                            matchScoreAnnouncement()
                            
                            if(metadata.ten_point_tiebreaker_format == 0) { //Start 10-point tiebreaker for the 3rd set
                                is_tiebreak = true
                            }
                        }
                    } else if(player_1_set_2_score == 7 && player_2_set_2_score == 5) { //7-5
                        
                        current_set += 1
                        
                        set_winners[1] = 1
                        
                        if(set_winners[0] == set_winners[1]) {  //Player 1 wins the match
                            gameSetMatchAnnouncement(player: "P1")
                        } else {
                            // Announce "Set 2: P1"
                            setAnnouncement(player: "P1", set_number: "2")
                            matchScoreAnnouncement()
                            
                            if(metadata.ten_point_tiebreaker_format == 0) { //Start 10-point tiebreaker for the 3rd set
                                is_tiebreak = true
                            }
                        }
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
                // Link data together
                updateApplicationContext()
                
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
            
            // Link data together
            updateApplicationContext()
        } else {    //Tiebreaker
            player_1_game_score_label.setText(String(player_1_points_won_this_game))
            
            if((player_1_points_won_this_game + player_2_points_won_this_game) % 2 == 1) {
                changeServer()
            }
            
            //10-point tiebreak logic
            if(metadata.ten_point_tiebreaker_format == 0) { //10-point tiebreaker for final set
                if(metadata.match_length == 0 || (metadata.match_length == 1 && current_set == 3)) {
                    if(player_1_points_won_this_game >= 10 && player_1_points_won_this_game - player_2_points_won_this_game >= 2) {
                        player_1_game_score_label.setText("0")
                        player_2_game_score_label.setText("0")
                        
                        player_1_points_won_this_game = 0
                        player_2_points_won_this_game = 0
                        
                        if(current_set == 1) {  //P1 wins 1st set 10-point tiebreak
                            player_1_set_1_score += 1
                            player_1_set_1_score_label.setText(String(player_1_set_1_score))
                            set_winners[0] = 1
                            
                            gameSetMatchAnnouncement(player: "P1")
                            
                            // Link data together
                            updateApplicationContext()
                            
                            return
                        } else {    //P1 wins 3rd set 10-point tiebreak
                            player_1_set_3_score += 1
                            player_1_set_3_score_label.setText(String(player_1_set_3_score))
                            set_winners[2] = 1
                            
                            gameSetMatchAnnouncement(player: "P1")
                            
                            // Link data together
                            updateApplicationContext()
                            
                            return
                        }
                    } else {    // Still in the the tiebreak so call the score
                        //Announce game score
                        
                        if(player_serving == 0) {
                            gameScoreAnnouncement(server_score: String(player_1_points_won_this_game), receiver_score: String(player_2_points_won_this_game))
                        } else {
                            gameScoreAnnouncement(server_score: String(player_2_points_won_this_game), receiver_score: String(player_1_points_won_this_game))
                        }
                        
                        // Link data together
                        updateApplicationContext()
                        
                        return
                    }
                }
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
                    
                    current_set += 1
                    
                    player_1_set_1_score += 1
                    player_1_set_1_score_label.setText(String(player_1_set_1_score))
                    
                    set_winners[0] = 1
                    
                    if(metadata.match_length == 0) {    //If best of 1 set, Player 1 wins the match
                        gameSetMatchAnnouncement(player: "P1")
                    } else {
                        // Announce "Set 1: P1"
                        setAnnouncement(player: "P1", set_number: "1")
                        matchScoreAnnouncement()
                    }
                } else if (current_set == 2) {
                    
                    current_set += 1
                    
                    player_1_set_2_score += 1
                    player_1_set_2_score_label.setText(String(player_1_set_2_score))
                    
                    set_winners[1] = 1
                    
                    if(set_winners[0] == set_winners[1]) {  //Player 1 wins
                        gameSetMatchAnnouncement(player: "P1")
                    } else {
                        // Announce "Set 2: P1"
                        setAnnouncement(player: "P1", set_number: "2")
                        matchScoreAnnouncement()
                        
                        if(metadata.ten_point_tiebreaker_format == 0) { //Start 10-point tiebreaker for the 3rd set
                            is_tiebreak = true
                        }
                    }
                } else {    //Set 3
                    
                    current_set += 1
                    
                    player_1_set_3_score += 1
                    player_1_set_3_score_label.setText(String(player_1_set_3_score))
                    
                    set_winners[2] = 1
                    
                    gameSetMatchAnnouncement(player: "P1")
                }
                
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
            
            // Link data together
            updateApplicationContext()
        }
        
//        print(player_1_points_won_this_game)
//        print(player_2_points_won_this_game)
    }
    
    @IBAction func incrementPlayerTwoScore() {
        player_2_points_won_this_game += 1
        
//        print("is_tiebreak: \(is_tiebreak)")
        
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
                        
                        current_set += 1
                        
                        set_winners[0] = 2
                        
                        if(metadata.match_length == 0) {    //If best of 1 set, Player 2 wins the match
                            gameSetMatchAnnouncement(player: "P2")
                        } else {
                            // Announce "Set 1: P2"
                            setAnnouncement(player: "P2", set_number: "1")
                            matchScoreAnnouncement()
                        }
                    } else if(player_2_set_1_score == 7 && player_1_set_1_score == 5) {  //7-5
                        
                        current_set += 1
                        
                        set_winners[0] = 2
                        
                        if(metadata.match_length == 0) {    //If best of 1 set, Player 2 wins the match
                            gameSetMatchAnnouncement(player: "P2")
                        } else {
                            // Announce "Set 1: P2"
                            setAnnouncement(player: "P2", set_number: "1")
                            matchScoreAnnouncement()
                        }
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
                        
                        current_set += 1
                        
                        set_winners[1] = 2
                        
                        if(set_winners[0] == set_winners[1]) {  //Player 2 wins
                            gameSetMatchAnnouncement(player: "P2")
                        } else {
                            // Announce "Set 2: P2"
                            setAnnouncement(player: "P2", set_number: "2")
                            matchScoreAnnouncement()
                            
                            if(metadata.ten_point_tiebreaker_format == 0) { //Start 10-point tiebreaker for the 3rd set
                                is_tiebreak = true
                            }
                        }
                        
                        
                    } else if(player_2_set_2_score == 7 && player_1_set_2_score == 5) { //7-5
                        
                        current_set += 1
                        
                        set_winners[1] = 2
                        
                        if(set_winners[0] == set_winners[1]) {  //Player 2 wins
                            gameSetMatchAnnouncement(player: "P2")
                        } else {
                            // Announce "Set 2: P2"
                            setAnnouncement(player: "P2", set_number: "2")
                            matchScoreAnnouncement()
                            
                            if(metadata.ten_point_tiebreaker_format == 0) { //Start 10-point tiebreaker for the 3rd set
                                is_tiebreak = true
                            }
                        }
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
                        
                        current_set += 1
                        
                        set_winners[2] = 2
                        
                        gameSetMatchAnnouncement(player: "P2")
                    } else if(player_2_set_3_score == 7 && player_1_set_3_score == 5) {  //7-5
                        
                        current_set += 1
                        
                        set_winners[2] = 2
                        
                        gameSetMatchAnnouncement(player: "P2")
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

                // Link data together
                updateApplicationContext()
                
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
            
            // Link data together
            updateApplicationContext()
        } else {    //Tiebreaker
            player_2_game_score_label.setText(String(player_2_points_won_this_game))
            
            if((player_1_points_won_this_game + player_2_points_won_this_game) % 2 == 1) {
                changeServer()
            }
            
            //10-point tiebreak logic
            if(metadata.ten_point_tiebreaker_format == 0) { //10-point tiebreaker for final set
                if(metadata.match_length == 0 || (metadata.match_length == 1 && current_set == 3)) {
                    if(player_2_points_won_this_game >= 10 && player_2_points_won_this_game - player_1_points_won_this_game >= 2) {
                        player_1_game_score_label.setText("0")
                        player_2_game_score_label.setText("0")
                        
                        player_1_points_won_this_game = 0
                        player_2_points_won_this_game = 0
                        
                        if(current_set == 1) {  //P2 wins 1st set 10-point tiebreak
                            player_2_set_1_score += 1
                            player_2_set_1_score_label.setText(String(player_2_set_1_score))
                            set_winners[0] = 2
                            
                            gameSetMatchAnnouncement(player: "P2")
                            
                            // Link data together
                            updateApplicationContext()
                            
                            return
                        } else {    //P2 wins 3rd set 10-point tiebreak
                            player_2_set_3_score += 1
                            player_2_set_3_score_label.setText(String(player_2_set_3_score))
                            set_winners[2] = 2
                            
                            gameSetMatchAnnouncement(player: "P2")
                            
                            // Link data together
                            updateApplicationContext()
                            
                            return
                        }
                    } else {    // Still in the the tiebreak so call the score
                        //Announce game score
                        
                        if(player_serving == 0) {
                            gameScoreAnnouncement(server_score: String(player_1_points_won_this_game), receiver_score: String(player_2_points_won_this_game))
                        } else {
                            gameScoreAnnouncement(server_score: String(player_2_points_won_this_game), receiver_score: String(player_1_points_won_this_game))
                        }
                        
                        // Link data together
                        updateApplicationContext()
                        
                        return
                    }
                }
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
                    
                    current_set += 1
                    
                    player_2_set_1_score += 1
                    player_2_set_1_score_label.setText(String(player_2_set_1_score))
                    
                    set_winners[0] = 2
                    
                    if(metadata.match_length == 0) {    //If best of 1 set, Player 2 wins the match
                        gameSetMatchAnnouncement(player: "P2")
                    } else {
                        // Announce "Set 1: P2"
                        setAnnouncement(player: "P2", set_number: "1")
                        matchScoreAnnouncement()
                    }
                } else if(current_set == 2) {
                    
                    current_set += 1
                    
                    player_2_set_2_score += 1
                    player_2_set_2_score_label.setText(String(player_2_set_2_score))
                    
                    set_winners[1] = 2
                    
                    if(set_winners[0] == set_winners[1]) {  //Player 2 wins
                        gameSetMatchAnnouncement(player: "P2")
                    } else {
                        // Announce "Set 2: P2"
                        setAnnouncement(player: "P2", set_number: "2")
                        matchScoreAnnouncement()
                        
                        if(metadata.ten_point_tiebreaker_format == 0) { //Start 10-point tiebreaker for the 3rd set
                            is_tiebreak = true
                        }
                    }
                } else {    //Set 3
                    
                    current_set += 1

                    player_2_set_3_score += 1
                    player_2_set_3_score_label.setText(String(player_2_set_3_score))
                    
                    set_winners[2] = 2
                    
                    gameSetMatchAnnouncement(player: "P2")
                }
                
                is_tiebreak = false
            } else {    // Still in the the tiebreak so call the score
                //Announce game score
                
                if(player_serving == 0) {
                    gameScoreAnnouncement(server_score: String(player_1_points_won_this_game), receiver_score: String(player_2_points_won_this_game))
                } else {
                    gameScoreAnnouncement(server_score: String(player_2_points_won_this_game), receiver_score: String(player_1_points_won_this_game))
                }
            }
            
            // Link data together
            updateApplicationContext()
        }
        
//        print(player_1_points_won_this_game)
//        print(player_2_points_won_this_game)
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
        
        player_won = -1
        
        player_1_game_score_string = "Love"
        player_2_game_score_string = "Love"
        
        player_1_label.setTextColor(UIColor.white)
        player_2_label.setTextColor(UIColor.white)
        
        if(player_serving == 0) {   //P1 (left side) always starts serving
            player_1_serving_image.setHidden(false)
            player_2_serving_image.setHidden(true)
        }
        
        self.announcement_label.setHidden(true)
        
        if(metadata.ten_point_tiebreaker_format == 0 && metadata.match_length == 0) {   //Best of 1 set and 10-point tiebreaker
            is_tiebreak = true
        } else {    //Any other case of resetting
            is_tiebreak = false
        }
        
        //Allow the player to use increment buttons if they hit reset at the end of match
        self.increment_player_one_score_outlet.setEnabled(true)
        self.increment_player_two_score_outlet.setEnabled(true)
        
        // Link data together
        updateApplicationContext()
    }
    
    /* Delay a game score announcement */
    func delayGameScoreAnnouncement() {
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
    
    /* Delay a normal announcement */
    func delayAnnouncement() {
        // Delay the dismissal by 5 seconds
        let when = DispatchTime.now() + 5 // change 5 to desired number of seconds
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
                if(player_serving == 0) {   //P1 serving
                    myUtterance = AVSpeechUtterance(string: "\(server_score) \(receiver_score), P1")
                } else {    //P2 serving
                    myUtterance = AVSpeechUtterance(string: "\(server_score) \(receiver_score), P2")
                }
            }
        }
        
        synth.speak(myUtterance)
        
        preventButtonSelection()
        delayGameScoreAnnouncement()
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
    
    func matchScoreAnnouncement() {
        if(current_set == 2) {
            if(set_winners[0] == 1) {   // P1 won the first set
                myUtterance = AVSpeechUtterance(string: "P1 leeds 1 set to love")
            } else {    // P2 won the first set
                myUtterance = AVSpeechUtterance(string: "P2 leeds 1 set to love")
            }
        } else {    //3rd set announcement
            myUtterance = AVSpeechUtterance(string: "1 set all")
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

        // This line could possibly be deprecated. Need to test
        delayAnnouncement()
    }
    
    func setAnnouncement(player: String, set_number: String) {
        announcement_label.setHidden(false)
        announcement_label.setText("Set \(set_number): \(player)")
        
        myUtterance = AVSpeechUtterance(string: "Game and Set \(set_number): \(player)")
        synth.speak(myUtterance)
        
        preventButtonSelection()
        delayAnnouncement()
    }
    
    func gameSetMatchAnnouncement(player: String) {
        announcement_label.setHidden(false)
        announcement_label.setText("Game, Set, Match")
        
        if(metadata.match_length == 0) {    //Best of 1 set format
            if(player == "P1") {    //P1 wins
                myUtterance = AVSpeechUtterance(string: "Game, Set, Match: \(player). \(player_1_set_1_score) \(player_2_set_1_score)")
            } else {    //P2 wins
                myUtterance = AVSpeechUtterance(string: "Game, Set, Match: \(player). \(player_2_set_1_score) \(player_1_set_1_score)")
            }
        } else {    //Best of 3 set format
            if(player == "P1") {
                if(set_winners[0] == set_winners[1]) {  //P1 won in straight sets
                    myUtterance = AVSpeechUtterance(string: "Game, Set, Match: \(player). \(player_1_set_1_score) \(player_2_set_1_score). \(player_1_set_2_score) \(player_2_set_2_score)")
                } else {    //P1 won in 3 sets
                    myUtterance = AVSpeechUtterance(string: "Game, Set, Match: \(player). \(player_1_set_1_score) \(player_2_set_1_score). \(player_1_set_2_score) \(player_2_set_2_score). \(player_1_set_3_score) \(player_2_set_3_score)")
                }
            } else {
                if(set_winners[0] == set_winners[1]) {  //P2 won in straight sets
                    myUtterance = AVSpeechUtterance(string: "Game, Set, Match: \(player). \(player_2_set_1_score) \(player_1_set_1_score). \(player_2_set_2_score) \(player_1_set_2_score)")
                } else {    //P1 won in 3 sets
                    myUtterance = AVSpeechUtterance(string: "Game, Set, Match: \(player). \(player_2_set_1_score) \(player_1_set_1_score). \(player_2_set_2_score) \(player_1_set_2_score). \(player_2_set_3_score) \(player_1_set_3_score)")
                }
            }
        }
        
        synth.speak(myUtterance)
        
        // Change color for the winner
        if(player == "P1") {
            player_1_label.setTextColor(UIColor.green)
            player_won = 0
        } else {
            player_2_label.setTextColor(UIColor.green)
            player_won = 1
        }
        
        player_1_serving_image.setHidden(true)
        player_2_serving_image.setHidden(true)
        
        preventButtonSelection()
        delayGameSetMatch()
    }
    
    func updateApplicationContext() {
        // Link data to the iOS app
        let applicationDict = ["player_1_set_1_score_label": player_1_set_1_score, "player_2_set_1_score_label": player_2_set_1_score, "player_1_set_2_score_label": player_1_set_2_score, "player_2_set_2_score_label": player_2_set_2_score, "player_1_set_3_score_label": player_1_set_3_score, "player_2_set_3_score_label": player_2_set_3_score, "player_1_game_score_label": player_1_points_won_this_game, "player_2_game_score_label": player_2_points_won_this_game,
            "player_serving": player_serving,
            "player_won": player_won,
            "is_tiebreak": Int(NSNumber(value:is_tiebreak)),
            "match_length": metadata.match_length,
        ]
        
        //
        DispatchQueue.main.async(execute: {
            // Update application context
            do {
                try self.session.updateApplicationContext(applicationDict)
                print("Updated Application Context with applicationDict\n")
            } catch {
                print("Error. Failed to update in updateApplicationContext()")
            }
        })
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
//        print("context: \(String(describing: context))")    // This prints nil
        
        // Configure interface objects here.
        if let passed_metadata = context as? Metadata {
//            print("match_type: \(passed_metadata.match_length)")
//            print("ten_point_tiebreaker_format: \(passed_metadata.ten_point_tiebreaker_format)")
            
            //Get the correct values of match_length and ten_point_tiebreaker_format from previous Interface Controllers
            metadata.match_length = passed_metadata.match_length
            metadata.ten_point_tiebreaker_format = passed_metadata.ten_point_tiebreaker_format
        }
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
        
        // Show only first set scores if best of 1 format
        if(metadata.match_length == 0) {
            comma_between_set_1_and_2_label.setHidden(true)
            player_1_set_2_score_label.setHidden(true)
            set_2_dash_label.setHidden(true)
            player_2_set_2_score_label.setHidden(true)
            comma_between_set_2_and_3_label.setHidden(true)
            player_1_set_3_score_label.setHidden(true)
            set_3_dash_label.setHidden(true)
            player_2_set_3_score_label.setHidden(true)
        }
        
        //If 10 point tiebreaker format for the final set, adjust certain conditions
        if(metadata.ten_point_tiebreaker_format == 0) {
            if(metadata.match_length == 0) {
                is_tiebreak = true
            }
        }
        
        // Link data together
        updateApplicationContext()
        
//        print("Activated scores")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    // For WCSession
    override init() {
        super.init()
        
        print("WATCH: WCSession.isSupported(): \(WCSession.isSupported())")
        if(WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()  // Check if this activates
            print("\n\nINIT ENTERED!!!\n\n")
        }
    }
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        
//        print("session: \(session)\n")
//        print("activationState: \(activationState)\n")
//        print("error: \(error)\n")
    }
    
}
