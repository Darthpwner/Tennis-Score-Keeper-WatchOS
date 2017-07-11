//
//  ViewController.swift
//  Tennis-Score-Keeper-WatchOS
//
//  Created by Matthew Allen Lin on 7/3/17.
//  Copyright © 2017 Matthew Allen Lin Software. All rights reserved.
//

import UIKit
import WatchConnectivity    //To have iOS app and Watch app talk to each other

class ScoreViewController: UIViewController, WCSessionDelegate {    
    
    // Starts a session to communicate with the Watch app
    var session: WCSession!
    
    //Outlets
    //Set Score Outlets
    @IBOutlet weak var player_1_set_1_score_label: UILabel!
    @IBOutlet weak var set_1_dash_label: UILabel!
    @IBOutlet weak var player_2_set_1_score_label: UILabel!
    
    @IBOutlet weak var player_1_set_2_score_label: UILabel!
    @IBOutlet weak var set_2_dash_label: UILabel!
    @IBOutlet weak var player_2_set_2_score_label: UILabel!
    
    @IBOutlet weak var player_1_set_3_score_label: UILabel!
    @IBOutlet weak var set_3_dash_label: UILabel!
    @IBOutlet weak var player_2_set_3_score_label: UILabel!
    
    //Game Score Outlets
    @IBOutlet weak var player_1_serving_image: UIImageView!
    @IBOutlet weak var player_1_game_score_label: UILabel!
    @IBOutlet weak var game_score_dash_label: UILabel!
    @IBOutlet weak var player_2_game_score_label: UILabel!
    @IBOutlet weak var player_2_serving_image: UIImageView!
    
    //Player Outlets
    @IBOutlet weak var player_1_label: UILabel!
    @IBOutlet weak var player_2_label: UILabel!
    
    //Sharing Data
//    var sharedFilePath: String?
//    var sharedDefaults: UserDefaults?
//    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("iOS: WCSession.isSupported(): \(WCSession.isSupported())")
        if(WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
            
            print("session.activate(): \(session.activate)")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // For WCSession
    
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        print("SESSION: \(session)")
//        print("ACTIVATION_STATE: \(activationState)")
//        print("ERROR: \(error)")
    }
    
    // Receives data from Watch app
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("applicationContext: \(applicationContext)")
        
        // Set Scores
        let player_1_set_1_score = applicationContext["player_1_set_1_score_label"]!
        let player_2_set_1_score = applicationContext["player_2_set_1_score_label"]!
        let player_1_set_2_score = applicationContext["player_1_set_2_score_label"]!
        let player_2_set_2_score = applicationContext["player_2_set_2_score_label"]!
        let player_1_set_3_score = applicationContext["player_1_set_3_score_label"]!
        let player_2_set_3_score = applicationContext["player_2_set_3_score_label"]!
        
        // Game Scores
        let player_1_game_score_label = applicationContext["player_1_game_score_label"]!
        let player_2_game_score_label = applicationContext["player_2_game_score_label"]!
        var player_1_game_score_string = ""
        var player_2_game_score_string = ""
        
        // Miscellaneous
        let player_serving = applicationContext["player_serving"]!
        let player_won = applicationContext["player_won"]!
        let is_tiebreak = applicationContext["is_tiebreak"]!
        let match_length = applicationContext["match_length"]!
        // Might not be necessary
        let ten_point_tiebreaker_format = applicationContext["ten_point_tiebreaker_format"]!
        
        print("FUCK")
        
        //Basic P1 scores
        if(player_1_game_score_label as! Int == 0) {
            player_1_game_score_string = "0"
        } else if(player_1_game_score_label as! Int == 1) {
            player_1_game_score_string = "15"
        } else if(player_1_game_score_label as! Int == 2) {
            player_1_game_score_string = "30"
        } else if((player_1_game_score_label as! Int) == 3 || (player_1_game_score_label as! Int) == (player_2_game_score_label as! Int)) {
            player_1_game_score_string = "40"
        } else if((player_1_game_score_label as! Int) - (player_2_game_score_label as! Int) == 1) {
            player_1_game_score_string = "AD"
            player_2_game_score_string = "40"
        }
        
        //Basic P2 scores
        if(player_2_game_score_label as! Int == 0) {
            player_2_game_score_string = "0"
        } else if(player_2_game_score_label as! Int == 1) {
            player_2_game_score_string = "15"
        } else if(player_2_game_score_label as! Int == 2) {
            player_2_game_score_string = "30"
        } else if((player_2_game_score_label as! Int) == 3 || (player_1_game_score_label as! Int)  == (player_2_game_score_label as! Int)) {
            player_2_game_score_string = "40"
        } else if((player_2_game_score_label as! Int) - (player_1_game_score_label as! Int) == 1) {
            player_2_game_score_string = "AD"
            player_1_game_score_string = "40"
        }
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        DispatchQueue.main.async() {
            //If best of 1 set, hide the other set labels
            if(match_length as! Int == 0) {
                self.player_1_set_2_score_label.isHidden = true
                self.set_2_dash_label.isHidden = true
                self.player_2_set_2_score_label.isHidden = true
                
                self.player_1_set_3_score_label.isHidden = true
                self.set_3_dash_label.isHidden = true
                self.player_2_set_3_score_label.isHidden = true
            } else {
                self.player_1_set_2_score_label.isHidden = false
                self.set_2_dash_label.isHidden = false
                self.player_2_set_2_score_label.isHidden = false
                
                self.player_1_set_3_score_label.isHidden = false
                self.set_3_dash_label.isHidden = false
                self.player_2_set_3_score_label.isHidden = false
            }
            
            // Update Set Scores
            self.player_1_set_1_score_label.text = ("\(player_1_set_1_score)")
            self.player_2_set_1_score_label.text = ("\(player_2_set_1_score)")
            
            self.player_1_set_2_score_label.text = ("\(player_1_set_2_score)")
            self.player_2_set_2_score_label.text = ("\(player_2_set_2_score)")
            
            self.player_1_set_3_score_label.text = ("\(player_1_set_3_score)")
            self.player_2_set_3_score_label.text = ("\(player_2_set_3_score)")
            
            // Update Game Scores
            self.player_1_game_score_label.text = ("\(player_1_game_score_string)")
            self.player_2_game_score_label.text = ("\(player_2_game_score_string)")
            
            // Update Miscellaneous
            // Change server after each game
            if(player_serving as! Int == 0) {
                self.player_1_serving_image.isHidden = false
                self.player_2_serving_image.isHidden = true
            } else {
                self.player_1_serving_image.isHidden = true
                self.player_2_serving_image.isHidden = false
            }
            
            // Check if a player won and hide the serving image when match is over
            if(player_won as! Int == 0) {
                self.player_1_label.textColor = UIColor.green
                self.player_1_serving_image.isHidden = false
                self.player_2_serving_image.isHidden = false
                
            } else if(player_won as! Int == 1) {
                self.player_2_label.textColor = UIColor.green
                self.player_1_serving_image.isHidden = false
                self.player_2_serving_image.isHidden = false
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive session: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Begin the activation process for the new Apple Watch.
        print("sessionDidDeactivate session: \(session)")
        WCSession.default().activate()
    }

}

